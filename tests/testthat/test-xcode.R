
test_that("e operand works fine", {
  key <- ''

  x <- '' ;                 y <- ''
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'a' ;                y <- "a#00#00#00#00#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'ab' ;               y <- "ab#00#00#00#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abc' ;              y <- "abc#00#00#00#00 "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcd' ;             y <- "abcd#00#00#00#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcde' ;            y <- "abcde#00#00#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdef' ;           y <- "abcdef#00#00#00 "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefg' ;          y <- "abcdefg#00#00#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefgh' ;         y <- "abcdefgh#00#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefgh' ;         y <- "abcdefgh#00#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghi' ;        y <- "abcdefghi#00#00 "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghij' ;       y <- "abcdefghij#00#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijk' ;      y <- "abcdefghijk#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijkl' ;     y <- "abcdefghijkl#00 "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijklm' ;    y <- "abcdefghijklm#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijklmn' ;   y <- "abcdefghijklmn#00#00#00#00#00#00"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijklmno' ;  y <- "abcdefghijklmno#00#00#00#00#00  "
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- 'abcdefghijklmnop' ;  y <- "abcdefghijklmnop"
  expect_equal(xcode(x,key,ed='e',trans=''),y)
  expect_equal(xcode(y,key,ed='d',trans=''),x)

  x <- intToUtf8(0:127) ; # all asci codes
  y <- xcode(x,key,ed='e',trans='')
  x1 <- xcode(y,key,ed='d',trans='')
  expect_identical(x,x1)

  x <- charToRaw("abcdefg") # raw
  y <- xcode(x,key,ed='e',trans='')
  x1 <-xcode(y,key,ed='d',trans='')
  expect_identical(x,x1)

})

test_that("check for valid key ", {

  key <- "invalid: key!"
  x <- 'abcdefghijklmnop' ;
  y <- "invalid characters in key: `:`, `!`"
  expect_error(xcode(x,key,ed='e',trans=''),y)

  key <- "correct key"
  x <- 'abcdefghijklmnop'
  expect_silent(xcode(x,key,ed='e',trans='') )

})


test_that("check for valid ed ", {

  key <- "" ;
  x <- 'abcdefghijklmnop'
  dirs <- c('e','E','d','D')
  purrr::walk( dirs,
     ~ expect_silent(xcode(x,key,ed=.,trans=''))
  )

  key <- "" ;
  x <- 'abcdefghijklmnop'
  y <- "'arg' should be one of \"e\", \"d\""
  ed <- "s"
  expect_error(xcode(x,key,ed=ed,trans=''),y)

})

test_that("check for s operand (shuffle) ", {

  key <- "" ;
  x <- '0123456789abcdef'
  y <- "0f2d4b6987a5c3e1"

  expect_equal(xcode(x,key,ed='e',trans='s'),y)
  expect_equal(xcode(y,key,ed='d',trans='s'),x)

})

test_that("check for f operand (shuffle) ", {

  key <- "" ;
  x <- '0123456789abcdef'
  y <- "fedcba9876543210"

  expect_equal(xcode(x,key,ed='e',trans='f'),y)
  expect_equal(xcode(y,key,ed='d',trans='f'),x)

})

test_that("check for v operand (vigenere) ", {

  key <- "abcdefghijklmnop"
  x <- '0123456789abcdef'
  y <- "13579#bdfhlnprtv"

  expect_equal(xcode(x,key,ed='e',trans='v'),y)
  expect_equal(xcode(y,key,ed='d',trans='v'),x)

})

test_that("check for c operand (vigenere cum) ", {

  key <- "abcdefghijklmnop"
  x <- '0123456789abcdef'
  y <- "1RIAtnieb#acfjou"

  expect_equal(xcode(x,key,ed='e',trans='c'),y)
  expect_equal(xcode(y,key,ed='d',trans='c'),x)

})

test_that("check for p operand (playfair) ", {

  key <- "abcdefghijklmnop"
  x <- '0123456789AbCdEf'
  y <- "123W56789 zcBeDg"

  expect_equal(xcode(x,key,ed='e',trans='p'),y)
  expect_equal(xcode(y,key,ed='d',trans='p'),x)

})

test_that("check for a operand (AES) ", {

  key <- "abcdefghijklmnop"
  x <- '0123456789AbCdEf'
  y <- "70f95b9161e5f23689966277ff4d5280"

  expect_equal(xcode(x,key,ed='e',trans='a'),y)
  expect_equal(xcode(y,key,ed='d',trans='a'),x)

})


test_that("check for h operand (Hill) ", {

  key <- "abcdefghijklmnop"
  x <- 'This is a message1'
  y <- "LPOvcQs4KAoU8yoKFN0ocBd3cBKnuUmO"

  expect_equal(xcode(x,key,ed='e',trans='h'),y)
  expect_equal(xcode(y,key,ed='d',trans='h'),x)

})


