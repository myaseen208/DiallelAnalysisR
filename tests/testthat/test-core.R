# The closed forms of Griffing (1956) used by the analyses against the exact least-squares decomposition of the
# cell means (R/utils-reference.R), for the four methods and several numbers of parents.
test_that("closed forms agree with the exact decomposition", {
  set.seed(7)
  for (P in 5:9) for (m in 1:4) {
    M <- matrix(stats::rnorm(P * P, 50, 10), P, P)
    if (m %in% c(2, 4)) M[lower.tri(M)] <- NA
    if (m %in% c(3, 4)) diag(M) <- NA
    cf <- .da_griffing_closed(M, m)
    ex <- .da_griffing_decompose(M, m)
    lab <- sprintf("P = %d, Method %d", P, m)
    expect_equal(cf$ss, ex$ss, label = paste(lab, "sums of squares"))
    expect_equal(cf$df, ex$df, label = paste(lab, "df"))
    expect_equal(cf$g, ex$g, label = paste(lab, "gca"))
    defined <- !is.na(ex$S)
    expect_equal(cf$S[defined], ex$S[defined], label = paste(lab, "sca"))
    if (m %in% c(1, 3)) expect_equal(cf$R, ex$R, label = paste(lab, "reciprocal"))
    expect_equal(unname(cf$ems), unname(ex$ems), label = paste(lab, "expected mean squares"))
    expect_equal(unname(cf$vse), unname(.da_griffing_se_ref(ex, m, 1)^2), label = paste(lab, "variances"))
  }
})
