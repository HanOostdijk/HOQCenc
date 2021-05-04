test_that("enc_file tests ", {

tekst     <- "This is a 21st century example of an English text."
tekst2    <- "Roi3WahvYtyWzyXUba3J9xAgtaf0nTZbf3Nxr4kI8iL2Pfoh HqEEJV9fmMQfJzs"

tekstraw  <- charToRaw(tekst)
tekstraw2 <- paste(
              "4ElK3kDV1KwWgTfNdXz92HCoMEF2#jE7fG0cVQBBPbF5g2oaZUuqa9KefJYiIbsEcuaTmiMNd" ,
              "7UJNuM712X#ycmEteOdDlPn5TChz#rWTPJLNYeqBZw3Ig5NztpmAR3qWx UxqnsBFZauNXdTiY" ,
              "Ld#FrG1LBBz6B",
              sep=""
              )


tfile <- tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".txt")

# write and read without en- and de-coding
d1 <- write_enc_file(tekst,tfile,encode=F)
expect_true(is.null(d1))
t1 <- read_enc_file(tfile,decode=F)
expect_equal(t1,tekst)

# write with encoding, read without decoding
d1 <- write_enc_file(tekst,tfile,encode=T)
t1 <- read_enc_file(tfile,decode=F)
expect_equal(t1,tekst2)
# write and read with encoding resp. decoding
t2 <- read_enc_file(tfile,decode=T)
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

