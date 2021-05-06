#' @name enc_file
NULL
#> NULL

#' Read and write encrypted files
#'
#'
#' @param filename a [connection()] object or a character string for use in [readLines()] or [writeLines()]
#' @param decode Logical scalar indicating if decoding should be done (if `TRUE`)
#' @param encode Logical scalar indicating if encoding should be done (if `TRUE`)
#' @param text Character string that has to be written
#' @param key Character string with key for the [xcode()] function
#' @param trans Character string with the transformations to be done by the [xcode()] function#'
#' @param bufsize Integer indicating the buffersize to be used for `read_enc_binfile`
#' @param raw2char Logical scalar indicating if `rawToChar` conversion should be done in `read_enc_binfile`
#' @return Character string with the data read in case of the `read_enc_ascfile` function otherwise `NULL`.
#' @export
#' @rdname enc_file
#' @examples
#' \dontrun{
#' han<- write_enc_ascfile("han",'mycoded.txt')
#' read_enc_ascfile('mycoded.txt',decode = FALSE)
#' # [1] "L7Gq 63aiI7x92kx"
#' read_enc_ascfile('mycoded.txt',decode = TRUE)
#' # [1] "han"
#' }
#'
read_enc_ascfile <- function (filename,decode=T,key='1VerySecretPasword',
                           trans="cfcvp") {
  x <- readLines(filename,warn=F)
  x <- paste(x,collapse='\n')
  if (decode == T) {
    x <-  xcode (x,ed='d',key=key,trans=trans)
  }
  x
}

#' @export
#' @rdname enc_file
#'
write_enc_ascfile <- function (text, filename,encode=T,key='1VerySecretPasword',
                            trans="cfcvp") {
  x <- paste(text,collapse='\n')
  if (encode == T) {
    x <-  xcode (x,ed='e',key=key,trans=trans)
  }
  writeLines(x,filename,sep='')
}
#' @export
#' @rdname enc_file
#'
read_enc_binfile <- function (filename,decode=T,key='1VerySecretPasword',
                              trans="cfcvp",bufsize=2000,raw2char=F) {
  f1 <- file(filename,open="rb")
  neof <- T
  x <-raw()
  while (neof) {
    x1 <- readBin(f1,"raw",n=bufsize)
    x  <- c(x,x1)
    neof <- ifelse(0 == length(x1),F,T)
  }
  close(f1)
  if (decode == T) {
    x <-  xcode (rawToChar(x),ed='d',key=key,trans=trans)
  }
  if (raw2char == T) {
    x <- rawToChar(x)
  }
  x
}

#' @export
#' @rdname enc_file
#'
write_enc_binfile <- function (text, filename,encode=T,key='1VerySecretPasword',
                               trans="cfcvp") {
  f1 <- file(filename,open="wb")
  if (inherits(text,"character")){
    x <- paste(text,collapse='\n')
  } else {
    x <- text
  }
  if (encode == T) {
    x <-  xcode (x,ed='e',key=key,trans=trans)
  }
  writeBin(x,f1)
  close(f1)
}
