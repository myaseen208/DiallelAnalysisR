fit1 <- function(m = 1, model = 1) {
  Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = get(paste0("GriffingData", m)), Method = m,
           Model = model)
}

test_that("fitted values and residuals are those of the block analysis", {
  f <- fit1()
  a <- stats::lm(Yield ~ factor(Rep) + interaction(Cross1, Cross2), data = GriffingData1)
  expect_equal(unname(fitted(f)), unname(fitted(a)))
  expect_equal(unname(residuals(f)), unname(residuals(a)))
  expect_identical(nobs(f), 256L)
  expect_equal(df.residual(f), 189)
  expect_identical(anova(f), f$ANOVA)
  p <- PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData)
  ap <- stats::lm(y ~ factor(Rep) + factor(Cross1) * factor(Cross2), data = PartialDiallelData)
  expect_equal(unname(fitted(p)), unname(fitted(ap)))
})

test_that("coef, vcov and confint agree with the standard errors", {
  for (m in 1:4) {
    f <- fit1(m)
    V <- vcov(f)
    expect_equal(unname(sqrt(diag(V))), rep(f$StdErr[["gi"]], nrow(V)))
    expect_equal(V[1, 1] + V[2, 2] - 2 * V[1, 2], f$StdErr[["gi_gj"]]^2)
    ci <- confint(object = f, parm = names(coef(f))[1:3], level = 0.95)
    q <- stats::qt(0.975, df.residual(f))
    expect_equal(unname(ci[, 2] - ci[, 1]), rep(2 * q * f$StdErr[["gi"]], 3))
    expect_true(all(startsWith(names(coef(f)), c("g_", "s_", "r_")[match(substr(names(coef(f)), 1, 1),
                                                                            c("g", "s", "r"))])))
  }
  expect_error(vcov(fit1(1, 2)), "fixed model")
  expect_identical(names(coef(fit1(1, 2))), rownames(fit1(1, 2)$Genetic.Components))
})

test_that("predict: the full model reproduces the means; gca alone gives mu + g_i + g_j", {
  for (m in 1:4) {
    f <- fit1(m)
    pr <- predict(object = f, newdata = NULL, type = "full")
    M <- f$Means
    obs <- M[cbind(match(pr$Cross1, rownames(M)), match(pr$Cross2, colnames(M)))]
    ok <- !is.na(obs)
    expect_equal(pr$predicted[ok], obs[ok], label = paste("Method", m))
  }
  f <- fit1(1)
  pg <- predict(object = f, newdata = data.frame(Cross1 = 3, Cross2 = 7), type = "gca")
  expect_equal(pg$predicted, mean(f$Means) + f$GCA[["3"]] + f$GCA[["7"]])
  expect_error(predict(object = f, newdata = data.frame(Cross1 = 3, Cross2 = 99), type = "gca"), "not in the diallel")
})

test_that("summaries, prints and plots", {
  f <- fit1()
  s <- summary(object = f, top = 3)
  expect_s3_class(s, "summary.da_griffing")
  expect_identical(nrow(s$sca_top), 3L)
  expect_equal(s$gca$t.value, unname(f$GCA / f$StdErr[["gi"]]))
  expect_output(print(s), "largest specific")
  expect_output(print(f), "General combining ability")
  h <- Hayman(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = HaymanData)
  expect_output(print(summary(h)), "Genetic ratios")
  p <- PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData)
  expect_output(print(summary(object = p, top = 5)), "Variance components")
  for (w in c("residuals", "qq")) {
    expect_s3_class(plot(x = f, which = w), "ggplot")
    expect_s3_class(plot(x = h, which = w), "ggplot")
    expect_s3_class(plot(x = p, which = w), "ggplot")
  }
  expect_s3_class(ggplot2::autoplot(f), "ggplot")
})
