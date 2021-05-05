
-   [HOQCenc](#hoqcenc)
    -   [Installation](#installation)
    -   [Example](#example)
    -   [Details](#details)
        -   [Key and alphabet](#key-and-alphabet)
        -   [Operations](#operations)
        -   [The `e` operation](#the-e-operation)
        -   [The `p` operation](#the-p-operation)
        -   [The `s` and `f` operations](#the-s-and-f-operations)
        -   [The `v` operation](#the-v-operation)
        -   [The `c` operation](#the-c-operation)
        -   [The `a` operation](#the-a-operation)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# HOQCenc

<!-- badges: start -->
<!-- badges: end -->

HOQCenc contains routines for encryption and decryption of character
strings and files. The main function is `xcode` that encrypts an input
string by executing a number of operations (specified by argument
`trans`) when argument `ed='e'`. When `ed='d'` is specified decryption
will be done by executing the operations in the reversed order.

## Installation

You can install this version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("HanOostdijk/HOQCenc") 
```

## Example

In the [Details](#details) section more examples are given and some
background. In this first example we show:

-   how to encrypt a message
-   that the result of encryption always is a character string with
    letters from the [alphabet](#key-and-alphabet)
-   that by choosing a set of [Operations](#operations) it is possible
    that small changes in the message lead to big differences in the
    encrypted text
-   that (happily) a sequence of encrypting and decrypting returns the
    original string

``` r
key <- "1VerySecretKey"
message1 <- "Line 1 of a two-line message!\nAs expected a second line."
message2 <- "Line 1 of a two-line message.\nAs expected a second line." 

(s <- xcode(message1,key=key,ed='e',trans='cscvp')) # encrypt message1
#> [1] "tSCLY5l2X4eM81f8Q7D3 gbmK9#hRSCtD5VC4M9CpH2LxQqGKKl4oHoKqc3dqOOT"
xcode(s,key=key,ed='d',trans='cscvp')               # show result of encryption
#> [1] "Line 1 of a two-line message!\nAs expected a second line."
xcode(message2,key=key,ed='e',trans='cscvp')        # encrypt message2
#> [1] "iixEWSv881hYenne#d9VnDEMEowLfD1HrwHyAiHK4qzwbwtneecPdwg1k1OioMOT"
```

## Details

### Key and alphabet

When we specify `key=''` an ordered set is constructed consisting of the
lower and upper case letters, the digits 0 till 9 and the space and the
`#` character. This ordered set is our ‘alphabet’: all operations will
work only with this set with the exception of the `e` operation that
converts our standard symbols to this new alphabet.  
When we use the key `1VerySecretKey` the characters in this key will be
inserted in this set before the others so that the following ordered set
will be constructed:

``` r
     [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
[1,] "1"  "V"  "e"  "r"  "y"  "S"  "c"  "t" 
[2,] "K"  "a"  "b"  "d"  "f"  "g"  "h"  "i" 
[3,] "j"  "k"  "l"  "m"  "n"  "o"  "p"  "q" 
[4,] "s"  "u"  "v"  "w"  "x"  "z"  "A"  "B" 
[5,] "C"  "D"  "E"  "F"  "G"  "H"  "I"  "J" 
[6,] "L"  "M"  "N"  "O"  "P"  "Q"  "R"  "T" 
[7,] "U"  "W"  "X"  "Y"  "Z"  "0"  "2"  "3" 
[8,] "4"  "5"  "6"  "7"  "8"  "9"  " "  "#" 
```

In almost all operations (but not the `e`, `s` and `f` operation) this
‘alfabet’ will be used.

### Operations

The following operations are defined (we describe only what happens in
case of encryption because for decryption the reversed action is
performed):

-   e : encode all characters that are not a blank, a letter or a digit
    and ensure that the length of the resulting string is a multiple of
    16
-   s : shuffle the characters in such a way that `0123456789abcdef` is
    translated to `0f2d4b6987a5c3e1`
-   f : flip the characters in such a way that `0123456789abcdef` is
    translated to `fedcba9876543210`
-   v : a Vigenère translation based on the key: the x-th character is
    shifted in the ordered set based on the position of the x-th
    character in the ordered set.
-   c : a Vigenère translation based on the first character of the
    ordered set for the first character and from then on based on the
    result for the preceding character.
-   p : a Playfair translation based on an 8x8 square filled with the
    ordered set (as show above)
-   a : an AES translation based on the key. This is in fact the
    \[digest::AES()\] function with `mode='ECB'`

The encryption characteristics of these operations are the following:

-   e : no real encryption because with a hex table the source text is
    easily derived
-   s : no encryption but useful in combination
-   f : no encryption but useful in combination
-   v : encryption with strength ‘proportional’ to the number of unique
    characters in the key
-   c : encryption based on key of length one, but has the advantage
    that a difference in a character leads to difference in later
    results. Always combine with `v`, `p` or `a` operations
-   p : pairwise encryption with strength better when the number of
    unique characters in the key is greater. When a pair occurs more
    than once, it is encrypted the same each time
-   a : When a 16-character block occurs more than once, it is encrypted
    the same each time.

So it is advised to combine several options as e.g. done in the example
below

``` r
key <- "1VerySecretKey"

# small differences in text lead to similar outcomes with simple trans
xcode("abcdefghijklmnopqrstuwvxyz",key=key,ed='e',trans='p')
#> [1] "bdrhybhiKqlmnopqmtB1vxwzSx9339  "
xcode("1bcdefghijklmnopqrstuwvxyz",key=key,ed='e',trans='p')
#> [1] "eKrhybhiKqlmnopqmtB1vxwzSx9339  "
xcode("abcdefghijklmnopqrstuwvxy1",key=key,ed='e',trans='p')
#> [1] "bdrhybhiKqlmnopqmtB1vxwzSV9339  "
xcode("ABabcdefghijklmnopqrstuwvxy1",key=key,ed='e',trans='p')
#> [1] "BsbdrhybhiKqlmnopqmtB1vxwzSV9329"

# small differences in text lead to unrelated outcomes with complex trans
xcode("abcdefghijklmnopqrstuwvxyz",key=key,ed='e',trans='cscvp')
#> [1] "DiQFluQYGgAia1Rck6#8ztKqOFCQupSH"
xcode("1bcdefghijklmnopqrstuwvxyz",key=key,ed='e',trans='cscvp')
#> [1] "B2k1QQQRlZ6GwdAT#kqrJ6K1VXZNwVH "
xcode("abcdefghijklmnopqrstuwvxy1",key=key,ed='e',trans='cscvp')
#> [1] "GTdRmtkyUuNwof6lzcieMmxz3TojYC6v"
xcode("ABabcdefghijklmnopqrstuwvxy1",key=key,ed='e',trans='cscvp')
#> [1] "7nCbDxf2eZMDNr Ywl9bqqJ4Mi2GkXdk"
```

### The `e` operation

Most of the operations used in the `xcode` function are working only at
the 64 characters of our ordered set of the lower and upper case
letters, the digits 0 till 9 and the space and the `#` character. The
`e` operation:

-   encodes the `#` character and the characters outside the ordered set
    by replacing each of those by `#` and their hex representation. E.g.
    the exclamation mark is replaced by `#21` and the `#` character
    itself is replaced by `#23` .
-   ensures that the number of characters is a multiple of 16 by adding
    one or more fillers (consisting of `#00`) and possible one or two
    spaces. The multiple of 16 is necessary when the `a` operation (AES
    encryption) is used but for the other operations an even number of
    characters is sufficient.

Because the `e` operation is necessary for most cases it is always
prefixed to the list of operations that is specified in the `trans`
argument.

``` r
xcode('Deze #!',key='',ed='e',trans='')
#> [1] "Deze #23#21#00  "
```

``` r
xcode('example!',key='',ed='e',trans='')
#> [1] "example#21#00#00"
xcode('example!',key='',ed='e',trans='p')
#> [1] "hueiimh832833899"
xcode('example!',key='',ed='e',trans='a')
#> [1] "f8028741438cf02b46c7c993804538ef"
```

Only when the `noe` argument is explicitly set to `TRUE` this is not
done.

``` r
xcode('example!',key='',ed='e',trans='',noe=T)
#> [1] "example!"
xcode('example!',key='',ed='e',trans='p',noe=T)
#> Error in playfair(text, ed): invalid characters in text of `p` operation: `!`
xcode('example ',key='',ed='e',trans='p',noe=T) # but with space instead of !
#> [1] "hueiimg8"
xcode('example ',key='',ed='e',trans='a',noe=T)
#> Error in aes$encrypt(text): Text length must be a multiple of 16 bytes
```

### The `p` operation

With the `p` operation a Playfair transformation is done that acts on
pairs of characters. With `key=''` the following ‘alfabet’ is used

``` r
     [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
[1,] "a"  "b"  "c"  "d"  "e"  "f"  "g"  "h" 
[2,] "i"  "j"  "k"  "l"  "m"  "n"  "o"  "p" 
[3,] "q"  "r"  "s"  "t"  "u"  "v"  "w"  "x" 
[4,] "y"  "z"  "A"  "B"  "C"  "D"  "E"  "F" 
[5,] "G"  "H"  "I"  "J"  "K"  "L"  "M"  "N" 
[6,] "O"  "P"  "Q"  "R"  "S"  "T"  "U"  "V" 
[7,] "W"  "X"  "Y"  "Z"  "0"  "1"  "2"  "3" 
[8,] "4"  "5"  "6"  "7"  "8"  "9"  " "  "#" 
```

and therefore “ex” is converted to "hu’ because ‘h’ and ‘u’ lie on the
opposite corner of the rectangle though ‘e’ and ‘x’. Special cases:

-   equal row : ‘km’ -&gt; ‘ln’ and ‘ip’ -&gt; ’ji
-   equal column : ‘zP’ -&gt; ‘HX’ and ‘J7’ -&gt; ‘Rd’
-   equal cell : ‘CC’ -&gt; ‘LL’ , ‘FF’ -&gt; ‘GG’ and ‘\#\#’ -&gt; ‘aa’

Advantage of Playfair is that a frequency distribution on character
level makes little sense because the method works on pairs of
characters.

``` r
xcode('example ',key='',ed='e',trans='p',noe=T)
#> [1] "hueiimg8"
xcode("hueiimg8",key='',ed='d',trans='p',noe=T)
#> [1] "example "
```

### The `s` and `f` operations

The `s` (shuffle) operation shuffles the characters in such a way that
`0123456789abcdef` is translated to `0f2d4b6987a5c3e1` and the `f`
operations (flip) flips the characters in such a way that
`0123456789abcdef` is translated to `fedcba9876543210`.

``` r
xcode('0123456789abcdef',key='',ed='e',trans='s',noe=T)
#> [1] "0f2d4b6987a5c3e1"
xcode('0123456789abcdef',key='',ed='e',trans='f',noe=T)
#> [1] "fedcba9876543210"
```

### The `v` operation

The `v` (Vigenère) operation shifts the i-th character a number of
places in the ‘alfabet’. That number is determined by the position of
the i-th letter in the ‘alfabet’. In the first example the ‘alfabet’ is
`ABCabcdef ...` and therefore the shifts for the letters ‘a’, ‘b’ etc.
are 4, 5 etc. resulting in ‘4’, ‘6’ etc. In the second example the
‘alfabet’ is `abcdef ...` and therefore the shifts for the letters ‘a’,
‘b’ etc. are 1, 2 etc. resulting in ‘1’, ‘3’ etc.

``` r
xcode('0123456789abcdef',key='ABC',ed='e',trans='v',noe=T)
#> [1] "468 ACbdfhoqsuwy"
xcode('0123456789abcdef',key='abc',ed='e',trans='v',noe=T)
#> [1] "13579#bdfhlnprtv"
```

### The `c` operation

The `c` operation shifts the first character a number of places in the
‘alfabet’. That number is again determined by the position of the first
letter in the ‘alfabet’. In the first example the ‘alfabet’ is
`abcdef ...` and therefore the shifts for the letter ‘a’ is 1 resulting
in ‘1’ . The shift for the next position is therefore determined by the
position of ‘1’ in the ‘alfabet’ and that is 44. So the next position
(the ‘1’) is shifted by 44 positions in the ‘alfabet’ resulting in ‘R’ .
And so on … The main advantage of this method is that the encryption of
a character is determined by all of its predecessors. The weak point is
that only the position of the ‘a’ in the ‘alfabet’ has to be guessed or
tried by brute force and this is very easy. So this method should never
be used on its own.

``` r
xcode('0123456789abcdef',key='abc',ed='e',trans='c',noe=T)
#> [1] "1RIAtnieb#acfjou"
```

### The `a` operation

The `a` uses the `digest::AES` function with the `mode='ECB'` method.
The method works in blocks of 16 characters: blocks that are identical
with the exception of one character will be encrypted very unrelated
results. However if a block occurs more than once, each block is
identically encryped. So also this method should never be used on its
own.

``` r
xcode('0123456789abcdef',key='abc',ed='e',trans='a',noe=T)
#> [1] "747f22502381a3fb7eb0cb42cb5f6612"
xcode('1123456789abcdef',key='abc',ed='e',trans='a',noe=T)
#> [1] "85762ea7ba16b3a881fc3144898bcdec"
xcode('0123456789abcdee',key='abc',ed='e',trans='a',noe=T)
#> [1] "4ada7b6fcbeb0f93d9fdb0d731074152"

xcode('0123456789abcdef0123456789abcdef',key='abc',ed='e',trans='a',noe=T)
#> [1] "747f22502381a3fb7eb0cb42cb5f6612747f22502381a3fb7eb0cb42cb5f6612"
```
