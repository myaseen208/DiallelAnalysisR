# Hayman's analysis of variance against the exact least-squares decomposition of the cell means (independent of the
# closed forms), with four and with three replicates; components against their formulas.

exact_parts <- function(d) {
  cd <- .da_cell_data(d$Yield, d$Cross1, d$Cross2, d$Rep, 1L, "test")
  dec <- .da_griffing_decompose(cd$M, 1L)
  list(B = cd$R, ss = dec$ss * cd$R, M = cd$M)
}

test_that("the analysis of variance equals the exact decomposition (4 and 3 replicates)", {
  for (d in list(HaymanData, droplevels(HaymanData[HaymanData$Rep != "4", ]))) {
    h <- Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d)
    ex <- exact_parts(d)
    ss <- h$ANOVA[["Sum Sq"]]
    expect_equal(ss[4], unname(ex$ss["gca"]))
    expect_equal(ss[5], unname(ex$ss["sca"]))
    expect_equal(sum(ss[6:8]), ss[5])
    expect_equal(ss[9] + ss[10], unname(ex$ss["reciprocals"]))
    expect_equal(sum(ss[c(4, 5, 9, 10)]), ss[3])
  }
})

test_that("b1 is the contrast of the parents with the crosses", {
  h <- Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = HaymanData)
  M <- h$Means
  P <- nrow(M)
  B <- 4
  Ys <- (M + t(M)) / 2
  cmean <- mean(Ys[upper.tri(Ys)])
  pmean <- mean(diag(M))
  # the 1-df contrast on the cells of the symmetric table (each cross on 2B plots, each parent on B plots)
  n_c <- P * (P - 1) / 2
  ss <- (cmean - pmean)^2 / (1 / (2 * B * n_c) + 1 / (B * P))
  expect_equal(h$ANOVA[6, "Sum Sq"], ss)
})

test_that("arrays, components and tests follow their formulas", {
  h <- Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = HaymanData)
  M <- h$Means
  P <- nrow(M)
  Ys <- (M + t(M)) / 2
  w <- h$Wr.Vr.Table
  expect_equal(unname(w$Vr), unname(apply(Ys, 2, stats::var)))
  expect_equal(unname(w$Wr), unname(drop(stats::cov(Ys, diag(Ys)))))
  cv <- h$Components.of.Variation
  E <- cv["E", "Estimate"]
  expect_equal(cv["H2", "Estimate"], 4 * mean(w$Vr) - 4 * stats::var(colMeans(Ys)) - 2 * E)
  expect_equal(cv["D", "Estimate"], stats::var(diag(Ys)) - E)
  expect_equal(h$b, unname(stats::coef(stats::lm(w$Wr ~ w$Vr))[2]))
  t2 <- (P - 2) / 4 * (stats::var(w$Vr) - stats::var(w$Wr))^2 /
    (stats::var(w$Vr) * stats::var(w$Wr) - stats::cov(w$Vr, w$Wr)^2)
  expect_equal(h$Tests[1, "Statistic"], t2)
  se_b <- summary(stats::lm(w$Wr ~ w$Vr))$coefficients[2, 2]
  expect_equal(h$Tests[3, "Statistic"], (1 - h$b) / se_b)
})

test_that("column arguments are used; results have the methods", {
  d <- HaymanData
  names(d) <- c("F", "M", "B", "Y")
  h1 <- Hayman(y = Y, Rep = B, Cross1 = F, Cross2 = M, data = d)
  h0 <- Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = HaymanData)
  expect_equal(h1$ANOVA, h0$ANOVA)
  expect_result(h0, "hayman", components = c("Means", "ANOVA", "Wr.Vr.Table", "Components.of.Variation", "Tests"))
  expect_s3_class(plot(h0), "ggplot")
  expect_error(Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2), "missing")
})
