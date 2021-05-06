test_that("enc_file tests ", {

tekst     <- "This is a 21st century example of an English text."
tekst2    <- "iFLbqk9MTET mpNazXQsSBBJLgPEU3LF1J5iuesj9#dMJsf7aTtkp32Slzk6Tfno"

tekstraw  <- charToRaw(tekst)
tekstraw2 <- paste(
       "LwCx7#VrahgD2rlUPByFMuY5CSVmBOSAZmWsDSIVOLXvu9O W6 S",
       "aJCYfTyTgcq6Ia#3xFJhlsjuJxmvudlg389JMEyNmt90QDHTUriD",
       "2pmQDMPwDxgmzMO7mD i3iVZX2LZWVcBZlXB5T1tVNW8nxIc1UtpVOVi",
              sep=""
              )


tfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".txt")

# write and read without en- and de-coding
d1 <- write_enc_ascfile(tekst,tfile,encode=F)
expect_true(is.null(d1))
t1 <- read_enc_ascfile(tfile,decode=F)
expect_equal(t1,tekst)

# write with encoding, read without decoding
d1 <- write_enc_ascfile(tekst,tfile,encode=T)
t1 <- read_enc_ascfile(tfile,decode=F)
expect_equal(t1,tekst2)
# write and read with encoding resp. decoding
t2 <- read_enc_ascfile(tfile,decode=T)
expect_equal(t2,tekst)

# binary character write and read without en- and de-coding
d1 <- write_enc_binfile(tekst,tfile,encode=F)
testthat::expect_equal(d1,0)
t1 <- read_enc_binfile(tfile,decode=F,raw2char=T)
expect_equal(t1,tekst)

# binary character write and read with en- and de-coding
d1 <- write_enc_binfile(tekst,tfile,encode=T)
t1 <- read_enc_binfile(tfile,decode=F,raw2char=T)
expect_equal(t1,tekst2)
t1 <- read_enc_binfile(tfile,decode=T)
expect_equal(t1,tekst)

# binary raw write and read without en- and de-coding
d1 <- write_enc_binfile(tekstraw,tfile,encode=F)
t1 <- read_enc_binfile(tfile,decode=F)
expect_equal(t1,tekstraw)

# binary raw write and read with en- and de-coding
d1 <- write_enc_binfile(tekstraw,tfile,encode=T)
t1 <- read_enc_binfile(tfile,decode=F,raw2char=T)
expect_equal(t1,tekstraw2)
t1 <- read_enc_binfile(tfile,decode=T)
expect_equal(t1,tekstraw)

})

