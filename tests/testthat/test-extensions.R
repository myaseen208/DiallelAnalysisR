#-------------------------------------------------------------------------------------------------------------------
# Heterosis
#-------------------------------------------------------------------------------------------------------------------
test_that("heterosis follows its formulas", {
  h <- Heterosis(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Check = 3)
  expect_result(h, "heterosis", components = c("Means", "Heterosis", "StdErr", "RCBD"))
  M <- with(GriffingData2, tapply(Yield, list(Cross1, Cross2), mean))
  H <- h$Heterosis
  r <- H[Cross1 == "1" & Cross2 == "2"]
  mp <- (M[1, 1] + M[2, 2]) / 2
  bp <- max(M[1, 1], M[2, 2])
  expect_equal(r$MP, 100 * (M[1, 2] - mp) / mp)
  expect_equal(r$BP, 100 * (M[1, 2] - bp) / bp)
  expect_equal(r$SH, 100 * (M[1, 2] - M[3, 3]) / M[3, 3])
  mse <- stats::anova(stats::lm(Yield ~ factor(Rep) + factor(Cross1):factor(Cross2), data = GriffingData2))
  mse <- mse["Residuals", "Mean Sq"]
  expect_equal(h$StdErr[["F1_MP"]], sqrt(3 * mse / 8))
  expect_equal(r$t_BP, (M[1, 2] - bp) / sqrt(2 * mse / 4))
  expect_equal(nrow(H), 28L)
  lo <- Heterosis(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Better = "lower")
  expect_equal(lo$Heterosis$BetterParent[1], min(M[1, 1], M[2, 2]))
  for (w in c("MP", "BP", "SH", "residuals", "qq")) expect_s3_class(plot(h, which = w), "ggplot")
  expect_error(Heterosis(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData4), "selfs")
  expect_error(Heterosis(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Check = 99),
               "Check")
})

#-------------------------------------------------------------------------------------------------------------------
# maternal and non-maternal reciprocal effects
#-------------------------------------------------------------------------------------------------------------------
test_that("the reciprocal line splits into maternal and non-maternal parts", {
  for (m in c(1L, 3L)) {
    d <- if (m == 1L) GriffingData1 else GriffingData3
    s <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d, Method = m, Model = 1,
                  Reciprocal = "split")
    c0 <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d, Method = m, Model = 1)
    a <- s$ANOVA
    expect_equal(sum(a[c("maternal", "non-maternal"), "Sum Sq"]), c0$ANOVA["reciprocals", "Sum Sq"])
    expect_equal(sum(a[c("maternal", "non-maternal"), "Df"]), c0$ANOVA["reciprocals", "Df"])
    # exact least squares on the reciprocal differences
    D <- (s$Means - t(s$Means)) / 2
    off <- row(D) != col(D)
    P <- nrow(D)
    X <- outer(row(D)[off], seq_len(P), "==") - outer(col(D)[off], seq_len(P), "==")
    f <- stats::lm.fit(X[, -P], D[off])
    expect_equal(a["maternal", "Sum Sq"], sum(f$fitted.values^2))
    b <- c(f$coefficients, 0)
    expect_equal(unname(s$Maternal), unname(b - mean(b)))
    expect_equal(s$NonMaternal[off], D[off] - (outer(s$Maternal, s$Maternal, `-`))[off], ignore_attr = TRUE)
    expect_equal(s$ANOVA[c("gca", "sca"), ], c0$ANOVA[c("gca", "sca"), ])
  }
  r2 <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 1, Model = 2,
                 Reciprocal = "split")
  expect_equal(r2$ANOVA["maternal", "F value"], r2$ANOVA["maternal", "Mean Sq"] / r2$ANOVA["non-maternal", "Mean Sq"])
  expect_true(all(c("Maternal", "NonMaternal") %in% rownames(r2$Genetic.Components)))
})

test_that("the standard errors of maternal effects agree with the exact covariance", {
  s <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 1, Model = 1,
                Reciprocal = "split")
  P <- 8
  vm <- s$ANOVA["Error", "Mean Sq"]
  # m = A d with d the reciprocal differences D_ij, i < j, each of variance vm / 2
  pr <- which(upper.tri(diag(P)), arr.ind = TRUE)
  A <- matrix(0, P, nrow(pr))
  A[cbind(pr[, 1], seq_len(nrow(pr)))] <- 1 / P
  A[cbind(pr[, 2], seq_len(nrow(pr)))] <- -1 / P
  V <- A %*% t(A) * vm / 2
  expect_equal(s$StdErr[["mi"]], sqrt(V[1, 1]))
  expect_equal(s$StdErr[["mi_mj"]], sqrt(V[1, 1] + V[2, 2] - 2 * V[1, 2]))
})

#-------------------------------------------------------------------------------------------------------------------
# Gardner and Eberhart
#-------------------------------------------------------------------------------------------------------------------
test_that("Gardner and Eberhart's analyses partition the entries", {
  g2 <- GardnerEberhart(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Analysis = 2)
  g3 <- GardnerEberhart(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Analysis = 3)
  gm <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData2, Method = 2, Model = 1)
  entries <- sum(gm$ANOVA[c("gca", "sca"), "Sum Sq"])
  expect_equal(sum(g2$ANOVA[c("Varieties", "Heterosis"), "Sum Sq"]), entries)
  expect_equal(sum(g3$ANOVA[c("Varieties", "Average heterosis", "gca", "sca"), "Sum Sq"]), entries)
  expect_equal(g2$ANOVA["Heterosis", "Sum Sq"],
               sum(g2$ANOVA[c("Average heterosis", "Variety heterosis", "Specific heterosis"), "Sum Sq"]))
  expect_equal(g2$ANOVA["Average heterosis", "Sum Sq"], g3$ANOVA["Average heterosis", "Sum Sq"])
  # Analysis III: gca and sca of the crosses are Griffing's Method 4
  g4 <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData4, Method = 4, Model = 1)
  expect_equal(g3$ANOVA["gca", "Sum Sq"], g4$ANOVA["gca", "Sum Sq"])
  expect_equal(g3$ANOVA["sca", "Sum Sq"], g4$ANOVA["sca", "Sum Sq"])
  expect_equal(g3$Effects$g, unname(g4$GCA))
  # Analysis II: variety effects are deviations of the parents, hbar the mean heterosis of the crosses
  M <- gm$Means
  expect_equal(sum(g2$Effects$v), 0)
  expect_equal(sum(g2$Effects$h), 0)
  P <- nrow(M)
  pm <- diag(M)
  mid <- outer(pm, pm, `+`)[upper.tri(M)] / 2
  expect_equal(g2$Average["hbar", "Estimate"], mean(M[upper.tri(M)] - mid))
  expect_result(g2, "gardner", components = c("Means", "ANOVA", "Effects", "Average", "Specific"))
  for (w in c("effects", "specific", "residuals", "qq")) expect_s3_class(plot(g2, which = w), "ggplot")
})

#-------------------------------------------------------------------------------------------------------------------
# line by tester and North Carolina designs
#-------------------------------------------------------------------------------------------------------------------
test_that("the line by tester analysis equals the linear model", {
  lt <- LineTester(y = Yield, Rep = Rep, Line = Line, Tester = Tester, data = LineTesterData, Inbreeding = 1)
  a <- stats::anova(stats::lm(Yield ~ Rep + Line * Tester, data = LineTesterData))
  expect_equal(lt$ANOVA[c("Rep", "Lines", "Testers", "Lines:Testers", "Error"), "Sum Sq"], a[["Sum Sq"]])
  expect_equal(lt$ANOVA["Lines:Testers", "F value"], a["Line:Tester", "F value"])
  expect_equal(sum(lt$Contribution), 100)
  expect_equal(sum(lt$GCA.Lines), 0)
  expect_equal(unname(rowSums(lt$SCA)), rep(0, 8))
  ms <- stats::setNames(lt$ANOVA[["Mean Sq"]], rownames(lt$ANOVA))
  expect_equal(lt$Genetic.Components["sca", 1], (ms[["Lines:Testers"]] - ms[["Error"]]) / 3)
  expect_equal(lt$Genetic.Components["Dominance", 1], lt$Genetic.Components["sca", 1])
  expect_equal(lt$StdErr[["gca_line"]], sqrt(ms[["Error"]] / 9))
  expect_result(lt, "linetester", components = c("Means", "ANOVA", "Contribution", "SCA", "Genetic.Components"))
  for (w in c("gca", "sca", "contribution", "biplot", "residuals", "qq")) expect_s3_class(plot(lt, which = w), "ggplot")
  d <- LineTesterData[-1, ]
  m <- LineTester(y = Yield, Rep = Rep, Line = Line, Tester = Tester, data = d)
  d$cell <- interaction(d$Line, d$Tester)
  ls <- stats::lm(Yield ~ 0 + cell + Rep, data = d, contrasts = list(Rep = "contr.sum"))
  expect_equal(m$Means[1, 1], unname(stats::coef(ls)[["cellL1.T1"]]))
  expect_error(LineTester(y = Yield, Rep = Rep, Line = Line, Tester = Tester,
                          data = LineTesterData[!(LineTesterData$Line == "L1" & LineTesterData$Tester == "T1"), ]),
               "no plot")
})

test_that("North Carolina designs equal the linear models", {
  d1 <- NCData[NCData$Design == 1, ]
  n1 <- NCDesign(y = Yield, Rep = Rep, Male = Male, Female = Female, data = d1, Design = 1)
  a1 <- stats::anova(stats::lm(Yield ~ Rep + Male / Female, data = d1))
  expect_equal(n1$ANOVA[["Sum Sq"]], a1[["Sum Sq"]])
  expect_equal(n1$ANOVA["Males", "F value"], a1["Male", "Mean Sq"] / a1["Male:Female", "Mean Sq"])
  d2 <- NCData[NCData$Design == 2, ]
  n2 <- NCDesign(y = Yield, Rep = Rep, Male = Male, Female = Female, data = d2, Design = 2)
  a2 <- stats::anova(stats::lm(Yield ~ Rep + Male * Female, data = d2))
  expect_equal(n2$ANOVA[["Sum Sq"]], a2[["Sum Sq"]])
  gc <- n2$Genetic.Components
  expect_equal(gc["Additive", 1], 2 * (gc["Males", 1] + gc["Females", 1]))
  d3 <- NCData[NCData$Design == 3, ]
  n3 <- NCDesign(y = Yield, Rep = Rep, Male = Male, Female = Female, data = d3, Design = 3)
  a3 <- stats::anova(stats::lm(Yield ~ Rep + Male * Female, data = d3))
  expect_equal(n3$ANOVA[["Sum Sq"]], a3[["Sum Sq"]])
  expect_equal(n3$Genetic.Components["Additive", 1], 4 * (a3["Male", "Mean Sq"] - a3["Residuals", "Mean Sq"]) / 6)
  expect_result(n3, "ncdesign", components = c("Means", "ANOVA", "Genetic.Components"))
  expect_s3_class(plot(n1), "ggplot")
  expect_error(NCDesign(y = Yield, Rep = Rep, Male = Male, Female = Female, data = d2, Design = 3), "two levels")
})

#-------------------------------------------------------------------------------------------------------------------
# several environments
#-------------------------------------------------------------------------------------------------------------------
test_that("the pooled analysis over environments adds up", {
  d <- DiallelSim(Parents = 5, Method = 1, Rep = 2, Env = 3, Mean = 20, gca = 3, sca = 2, rec = 1, gcaEnv = 1,
                  scaEnv = 1, EnvSD = 2, Error = 2, seed = 11)
  fe <- GriffingEnv(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, Env = Env, data = d, Method = 1, Model = 1)
  a <- fe$ANOVA
  for (k in c("gca", "sca", "reciprocals")) {
    per <- sum(vapply(fe$ByEnv, function(z) z$ANOVA[k, "Sum Sq"], numeric(1L)))
    expect_equal(per, a[k, "Sum Sq"] + a[paste0(k, ":Env"), "Sum Sq"])
  }
  # plot-level linear model: environments, replicates within them, crosses, crosses by environments
  lm0 <- stats::anova(stats::lm(y ~ Env / Rep + interaction(Cross1, Cross2) * Env, data = d))
  B <- 2
  expect_equal(a["Error", "Sum Sq"] * B, lm0["Residuals", "Sum Sq"])
  expect_equal(a["Env", "Sum Sq"] * B, lm0["Env", "Sum Sq"])
  expect_equal(sum(a[c("gca:Env", "sca:Env", "reciprocals:Env"), "Sum Sq"]) * B,
               lm0["Env:interaction(Cross1, Cross2)", "Sum Sq"])
  expect_equal(fe$GCA, rowMeans(fe$GCA.Env))
  f2 <- GriffingEnv(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, Env = Env, data = d, Method = 1, Model = 2)
  expect_equal(f2$ANOVA["gca", "F value"], f2$ANOVA["gca", "Mean Sq"] / f2$ANOVA["gca:Env", "Mean Sq"])
  expect_result(f2, "griffingenv", components = c("Means", "ANOVA", "GCA", "GCA.Env", "Genetic.Components"))
  for (w in c("gca", "gcaenv", "sca", "residuals", "qq")) expect_s3_class(plot(f2, which = w), "ggplot")
  expect_error(GriffingEnv(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, Env = rep(1, nrow(d)), data = d,
                           Method = 1, Model = 1), "two environments")
})

#-------------------------------------------------------------------------------------------------------------------
# simulation, planning and the biplot
#-------------------------------------------------------------------------------------------------------------------
test_that("simulated data have the design and the true effects", {
  for (m in 1:4) {
    d <- DiallelSim(Parents = 5, Method = m, Rep = 3, gca = 2, sca = 1, rec = 0.5, Error = 1, seed = m)
    expect_equal(nrow(d), 3L * c(25L, 15L, 20L, 10L)[m])
    expect_equal(sum(attr(d, "truth")$gca), 0)
  }
  d <- DiallelSim(Parents = 6, Method = 1, Rep = 50, gca = 3, sca = 1, rec = 0, Error = 0.5, seed = 3)
  f <- Griffing(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d, Method = 1, Model = 1)
  expect_lt(max(abs(f$GCA - attr(d, "truth")$gca)), 0.1)
  expect_identical(DiallelSim(Parents = 4, Method = 2, Rep = 2, gca = 1, sca = 1, Error = 1, seed = 9),
                   DiallelSim(Parents = 4, Method = 2, Rep = 2, gca = 1, sca = 1, Error = 1, seed = 9))
  expect_error(DiallelSim(Parents = 2, Method = 1, Rep = 2, gca = 1, sca = 1, Error = 1), "Parents")
})

test_that("power grows with the replicates and the effects", {
  skip_level(2)
  pw <- DiallelPower(Parents = 6, Method = 2, Rep = c(2, 6), gca = 1.5, sca = 0, Error = 3, nsim = 200, seed = 4)
  expect_s3_class(pw, "da_power")
  g <- pw[Source == "gca"]$Power
  expect_gt(g[2], g[1])
  expect_lt(abs(pw[Source == "sca"]$Power[2] - 0.05), 0.06)
  expect_s3_class(plot(pw), "ggplot")
})

test_that("the biplot is drawn and fills missing cells", {
  g <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData4, Method = 4, Model = 1)
  expect_s3_class(plot(g, which = "biplot"), "ggplot")
  Y <- .da_symmetric_means(g$Means)
  expect_equal(Y, t(Y))
  diag(Y) <- NA
  bp <- .da_biplot_svd(Y)
  expect_equal(dim(bp$rows), c(8L, 2L))
  expect_lte(sum(bp$pv), 100)
})

#-------------------------------------------------------------------------------------------------------------------
# the application
#-------------------------------------------------------------------------------------------------------------------
test_that("the application analyses an example data set", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("bslib")
  dir <- system.file("app", package = "DiallelAnalysisR")
  skip_if(!nzchar(dir))
  app <- shiny::shinyAppDir(dir)
  shiny::testServer(app, {
    session$setInputs(source = "example", example = "GriffingData2", analysis = "Griffing", col_y = "Yield",
                      col_Rep = "Rep", col_a = "Cross1", col_b = "Cross2", method = "2", model = "1", split = FALSE)
    session$setInputs(run = 1)
    expect_s3_class(fit(), "da_griffing")
    expect_match(call_text(), "Method += 2")
  })
})
