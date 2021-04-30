
test_that("e operand", {
  key <- 'A1'

  x <- '' ;                 y <- ''
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'a' ;                y <- "a#00#00#00#00#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'ab' ;               y <- "ab#00#00#00#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abc' ;              y <- "abc#00#00#00#00 "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcd' ;             y <- "abcd#00#00#00#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcde' ;            y <- "abcde#00#00#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdef' ;           y <- "abcdef#00#00#00 "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefg' ;          y <- "abcdefg#00#00#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefgh' ;         y <- "abcdefgh#00#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefgh' ;         y <- "abcdefgh#00#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghi' ;        y <- "abcdefghi#00#00 "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghij' ;       y <- "abcdefghij#00#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijk' ;      y <- "abcdefghijk#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijkl' ;     y <- "abcdefghijkl#00 "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijklm' ;    y <- "abcdefghijklm#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijklmn' ;   y <- "abcdefghijklmn#00#00#00#00#00#00"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijklmno' ;  y <- "abcdefghijklmno#00#00#00#00#00  "
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  x <- 'abcdefghijklmnop' ;  y <- "abcdefghijklmnop"
  expect_equal(xcode(x,key,dir='e',trans=''),y)
  expect_equal(xcode(y,key,dir='d',trans=''),x)

  key <- "invalid: key!"
  x <- 'abcdefghijklmnop' ;
  y <- "invalid characters in key: `:`, `!`"
  expect_error(xcode(x,key,dir='e',trans=''),y)

})

test_that("check for valid key", {

  key <- "invalid: key!"
  x <- 'abcdefghijklmnop' ;
  y <- "invalid characters in key: `:`, `!`"
  expect_error(xcode(x,key,dir='e',trans=''),y)

})
