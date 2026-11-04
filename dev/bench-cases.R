# cases timed by tools/bench.R (released version against this one); the simulated diallels are built here so that
# both versions analyse identical data
sim <- function(P, B = 3, seed = 1) {
  set.seed(seed)
  d <- expand.grid(Cross1 = factor(seq_len(P)), Cross2 = factor(seq_len(P)), Rep = factor(seq_len(B)))
  d$Yield <- 100 + rnorm(P)[d$Cross1] + rnorm(P)[d$Cross2] + rnorm(nrow(d), sd = 2)
  d
}
assign("Sim12", sim(12), envir = globalenv())
assign("Sim20", sim(20), envir = globalenv())
list(
    griffing_m1_P8  = quote(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 1, Model = 1))
  , griffing_m2_P8  = quote(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Method = 2, Model = 1))
  , griffing_m1_P12 = quote(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = Sim12, Method = 1, Model = 1))
  , griffing_m1_P20 = quote(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = Sim20, Method = 1, Model = 1))
  , hayman_P8       = quote(Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = HaymanData))
  , hayman_P20      = quote(Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = Sim20))
  , partial_10x4    = quote(PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData))
  )
