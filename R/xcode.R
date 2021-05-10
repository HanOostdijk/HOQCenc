#' Encrypt or decrypt character string
#'
#'
#'
#' @param text Character string or raw vector to encrypt or character string to decrypt
#' @param key Character string with encryption/decryption key.
#' Only the letters (in upper or lower case), digits, the character `#`
#' and the space are allowed in this key
#' @param ed Character (`'e'` or `'d'` or their upper case versions) that specifies what to do:
#'  `'e'` is encrypt, `'d'` is decrypt
#' @param trans Character string with encrypt/decrypt operations. See **Details**
#' @param noe Logical scalar that when set to `TRUE` will imit the `e` operation. Normally the default value of `FALSE`
#' should be used. See **Details**
#' @return a character string with the encrypted result when `ed == 'e'` or
#' the decrypted result when `ed == 'd'`
#' @importFrom stats setNames
#' @export
#' @details Operations in `trans` are sequentially executed in the order given for an encrypt
#' action and in reversed order for the decrypt action.
#' All operations are working on character strings that contain a multiple of 16 characters.
#' These characters must belong to the ordered set of the lower case letters, the
#' upper case letters, digits, the space and the `#` character. This order is changed by the key:
#' all (non-duplicated) characters from the key are placed before the other characters.
#'
#' To ensure that all characters belong to this ordered set,
#' an `e` operation is always added (prefixed) to `trans` unless `noe = TRUE` is used.
#' *When `noe` is set to `TRUE` the user must ensure that the string to be encrypted
#' only contains the characters mentioned above and that the number of characters is
#' a multiple of 2 when the `p` or `s` operation is used and a multiple of 16 when the `a` operation is used.*
#'
#' The following operations are defined (we describe only what happens in case of encryption
#' because for decryption the reversed action is performed):
#'
#' - e : encode all characters that are not a blank, a letter or a digit
#' and ensure that the length of the resulting string is a multiple of 16
#' - s : shuffle the characters in such a way that `0123456789abcdef` is translated to `0f2d4b6987a5c3e1`
#' - f : flip the characters in such a way that `0123456789abcdef` is translated to `fedcba9876543210`
#' - v : a Vigenère translation based on the key: the x-th character is shifted in the ordered set
#' based on the position of the x-th character in the ordered set.
#' - c : a Vigenère translation based on the first character of the ordered set for the first character
#' and from then on based on the result for the preceding character.
#' - p : a Playfair translation based on an 8x8 square filled with the ordered set
#' - a : an AES translation based on the key. This is in fact the [digest::AES()] function with `mode='ECB'`
#' - h : a Hill linear transformation based on the key. This handles 4 consecutive characters
#'
#' @examples
#' \dontrun{
#' my_key <- 'Mysecret123'
#' (s <- xcode('my message!',my_key,ed='e'))
#' # [1] "8Ge8D3F4Mh1s6q z"
#' xcode(s,my_key,ed='d')
#' # [1] "my message!"
#' }

xcode <- function (text, key='1VerySecretPasword', ed = c('e','d'), trans = "cfcvp", noe = FALSE) {

  ed <- tolower(ed)
  ed <- match.arg(ed)

  nbyn <- function (text,n) {
    text <- matrix(unlist(strsplit(text, '')), ncol = n, byrow = T)
    apply(text, 1, function(x)
      paste(x, collapse = ''))
  }

  create_matrix <- function(key) {
    letters1 <- unique(unlist(strsplit(key, '')))
    letters2 <- c(letters, LETTERS, paste(0:9), ' ', '#')
    letters3 <- c(letters1, setdiff(letters2, letters1))
    letters4 <- setdiff(letters1, letters2)
    if (length(letters4) > 0 ) {
      stop(glue::glue('invalid characters in key: ',
             glue::glue_collapse(glue::backtick(letters4), sep = ", ") )
      )

    }
    nummers  <- 1:64
    alf <- match(letters2, letters3)
    alf <- setNames(alf, letters2)
    nums <- letters3
    list(alf, nums)
  }

  init_matrix <- function (key) {
    x = create_matrix(key)
    assign("tonum",x[[1]],envir = parent.frame())
    assign("toalf",x[[2]],envir = parent.frame())
  }

  cihc <- function (x) {
    #convert raw to hex
    alfabet <- c('0','1','2','3','4','5','6','7','8','9',
                 'a','b','c','d','e','f')
    c1 <- x %/% 16
    c2 <- x %% 16
    paste(alfabet[1+c1],alfabet[1+c2],sep="")
  }

  chci <- function (x) {
    # convert hex to raw
     x <- purrr::map_dbl(nbyn(x,2),~strtoi(.,16L))
     as.raw(x)
  }


  hill_proc <- function (text, ed = 'e') { # Lester S. Hill
    if (ed == 'e') {
      m  <- matrix( data = c(1, 2, 3, 1, 0, 1, 2, 1, 3, 1, 1, 1, 0, 1, 3, 3),
                       nrow = 4, byrow = T )
    } else {
      m  <- matrix( data = c(-2, 4, 1, -1, 9, -18, -3, 4, -6, 13, 2,-3, 3, -7, -1, 2),
                       nrow = 4, byrow = T )
    }
    x <- purrr::map(nbyn(text,4), function (x) {
      d <- purrr::map_dbl(unlist(strsplit(x,'')),~tonum[.]-1)
      paste(toalf[1+(m %*% d) %% 64],collapse='')
      })
    paste(x,collapse='')
  }

  aes_proc <- function(text,ed = 'e') {
    key     <- paste(toalf[1:16],collapse = '')
    aes_key <- charToRaw(key)
    aes <- digest::AES(aes_key, mode="ECB")
    if (ed == 'e') {
      text <- aes$encrypt(text)
      text <- paste(purrr::map_chr(
                   strtoi(text, 16L), cihc) ,
            collapse = "")
    } else {
      text <- aes$decrypt(chci(text))
    }
   text
  }

  playfair <- function (text, ed = 'e') {
    playfair_pair <- function(c1c2, tonum, toalf, ed = c('e', 'd')) {
      if (ed == 'e') {
        add = 1
      } else {
        add = -1
      }
      nn  <- round(sqrt(length(tonum)) + 0.25)
      n1  <- unname(tonum[substr(c1c2, 1, 1)] - 1)
      n2  <- unname(tonum[substr(c1c2, 2, 2)] - 1)
      n1r <- n1 %/% nn
      n1c <- n1 %% nn

      n2r <- n2 %/% nn
      n2c <- n2 %% nn


      if ((n1r == n2r) && (n1c == n2c)) {
        n1r <- n1r + add
        n1c <- n1c + add
        n2r <- n2r + add
        n2c <- n2c + add
      } else if (n1r == n2r) {
        n1c <- n1c + add
        n2c <- n2c + add
      } else if (n1c == n2c) {
        n1r <- n1r + add
        n2r <- n2r + add
      } else {
        nx <- n1c
        n1c <- n2c
        n2c <- nx
      }
      n1r <- n1r %% nn
      n1c <- n1c %% nn

      n2r <- n2r %% nn
      n2c <- n2c %% nn

      n1  <- 1 + nn * n1r + n1c
      n2  <- 1 + nn * n2r + n2c
      paste(toalf[n1], toalf[n2], sep = '')
    }

    if ((nchar(text) %% 2 ) == 1) {
      stop('uneven number of characters in `p` operation' )
    }

    tekst2 <- setdiff(strsplit(text,'')[[1]],toalf)
    if (length(tekst2) > 0) {
       stop(glue::glue('invalid characters in text of `p` operation: ',
             glue::glue_collapse(glue::backtick(tekst2), sep = ", ") )
       )
    }

    text <- nbyn(text,2)
    text <- purrr::map_chr(text,  ~ playfair_pair(., tonum, toalf, ed))
    text <- paste(text, collapse = '')
    text
  }

  endecode <- function (text, ed = 'e') {
    encode1 <- function(x) {
      y = charToRaw(x)
      if ((y == 32) ||           # space
          (y > 47 && y < 58) ||  # numbers
          (y > 64 && y < 91) ||  # upper and lower case
          (y > 96 && y < 123)) {
        z = x
      } else {
        z = paste('#', format(y, '2x'), sep = '')
      }
    }

    decode1 <- function(x, i) {
      if (i == 1) {
        z = x
      } else {
        code = substr(x, 1, 2)
        # next line by jbaums:
        # https://stackoverflow.com/questions/29251934/how-to-convert-a-hex-string-to-text-in-r
        code = rawToChar(as.raw(strtoi(code, 16L)))
        z = paste(code, substr(x, 3, nchar(x)), sep = '')
      }
      z
    }

    if (ed == 'e') {
      if (inherits(x,"raw")) {
        x <- purrr::map_chr(x,~paste('#', format(., '2x'), sep = ''))
        x <- paste('raw',paste(x,collapse = ''),sep='')
      } else {
        x <- strsplit(text, '')[[1]]
        x <- purrr::map(x, encode1)
        x <- paste(x, collapse = '')
      }
      n <- nchar(x)
      m <- n %% 16
      if (m > 0) # add filler so that number of characters is multiple of 16
        if (m %in% 14:15) {
          m <- 32 - m
        } else {
          m <- 16 - m
        }
        i <- m %/% 3
        r <- m %% 3
        x <- paste(x,
          paste(rep('#00',i),collapse = ''),
          paste(rep(" ",r),collapse = ''),
          sep = '')
    } else {
      x <- sub("(#00)+([ ]*)$","",text) # remove filler
      if (substr(x,1,3) == 'raw') {
        x <- substr(x,4,nchar(x))
        x <- unlist(purrr::map(nbyn(x,3),~chci(substr(.,2,3))))
      } else {
        x <- strsplit(x, '#')[[1]]
        x <- purrr::imap(x, decode1)
        x <- paste(x, collapse = '')
      }
    }
    x
  }

  vigenere <- function (text, ed = 'e') {
    if (ed == 'e') {
      mult = 1
    } else {
      mult = -1
    }
    x <- strsplit(text, '')[[1]]
    x <- tonum[x] # indexes of text
    x <- x + rep_len(tonum, length(x)) * mult
    x <- toalf[1 + ((x - 1) %% 64)]
    paste(x, collapse = '')
  }

  vig_cum <- function (text, ed = 'e') {
    if (ed == 'e') {
      mult = 1
    } else {
      mult = -1
    }
    x  <- strsplit(text, '')[[1]]
    x  <- tonum[x]
    c1 <- tonum[1]
    for (i in seq(1, length(x))) {
      t <- x[i] + c1 * mult
      if (ed == 'd') {
        c1   <- x[i]
      }
      x[i] <- 1 + ((t - 1) %% 64)
      if (ed == 'e') {
        c1   <- x[i]
      }
    }
    x <- toalf[x]
    paste(x, collapse = '')
  }

  shuffle <- function (text) {
    n  <- nchar(text)
    p1 <- seq(1, n, 2)
    p2 <- rev(seq(2, n, 2))
    m  <- matrix(c(p1, p2), nrow = 2, byrow = T)
    m  <- as.numeric(m)
    paste(substring(text, m, m), collapse = '')
  }

  flip <- function (text) {
    stringi::stri_reverse(text)
  }

  dotrans <- function (text, type, ed) {
    switch(
      type,
      'e' = {
        text <- endecode(text, ed)
      },
      's' = {
        text <- shuffle(text)
      },
      'f' = {
        text <- flip(text)
      },
      'c' = {
        text <- vig_cum(text, ed)
      },
      'v' = {
        text <- vigenere(text, ed)
      },
      'p' = {
        text <- playfair(text, ed)
      },
      'a' = {
        text <- aes_proc(text, ed)
      },
      'h' = {
        text <- hill_proc(text, ed)
      },
      stop("Invalid `x` value")
    )
  }

  init_matrix(key)

  if (noe == FALSE) {
    trans = paste("e", trans, sep = "")
  }
  if (ed != 'e') {
    trans =  stringi::stri_reverse(trans)
  }
  x = text
  for (t in unlist(strsplit(trans, ''))) {
    x = dotrans(x, t, ed = ed)
  }
  x
}

utils::globalVariables(c("tonum", "toalf"))

