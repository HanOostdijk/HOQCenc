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
#' @param trans Character string with the transformations to be done by the [xcode()] function
#' @return Character string with the data read in case of the `read_enc_file` function otherwise `NULL`.
#' @export
#' @rdname enc_file
#' @examples
#' han<- write_enc_file("han",'mycoded.txt')
#' read_enc_file('mycoded.txt',decode = F)
#' # [1] "L7Gq 63aiI7x92kx"
#' read_enc_file('mycoded.txt',decode = T)
#' # [1] "han"
#'
read_enc_file <- function (filename,decode=T,key="My9Key",trans="cfcvp") {
  x <- readLines(filename,warn=F)
  x <- paste(x,collapse='\n')
  if (decode == T) {
    x <-  xcode (x,dir='d',key=key,trans=trans)
  }
  x
}

#' @export
#' @rdname enc_file
#'
write_enc_file <- function (text, filename,encode=T,key="My9Key",trans="cfcvp") {
  x <- paste(text,collapse='\n')
  if (encode == T) {
    x <-  xcode (x,dir='e',key=key,trans=trans)
  }
  writeLines(x,filename,sep='')
}
