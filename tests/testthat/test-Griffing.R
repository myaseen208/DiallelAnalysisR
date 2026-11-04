# Griffing's closed forms (Griffing 1956; Singh and Chaudhary 2004), written here independently of the core, are
# compared with the results of Griffing() for the four methods; standard errors and expected mean squares likewise.

fit <- function(m, model = 1) {
  Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = get(paste0("GriffingData", m)),
           Method = m, Model = model)
}
sym_table <- function(x) {
  M <- x$Means
  M[is.na(M)] <- 0
  M + t(M) - diag(diag(M))
}

test_that("Method 1: sums of squares, effects and standard errors match the closed forms", {
  x <- fit(1)
  M <- x$Means
  P <- nrow(M)
  a <- rowSums(M) + colSums(M)
  G <- sum(M)
  expect_equal(x$ANOVA["gca", "Sum Sq"], sum(a^2) / (2 * P) - 2 * G^2 / P^2)
  expect_equal(x$ANOVA["sca", "Sum Sq"], sum(M * (M + t(M))) / 2 - sum(a^2) / (2 * P) + G^2 / P^2)
  expect_equal(x$ANOVA["reciprocals", "Sum Sq"], sum((M - t(M))^2) / 4)
  expect_equal(unname(x$GCA), unname(a / (2 * P) - G / P^2))
  s12 <- (M[1, 2] + M[2, 1]) / 2 - (a[1] + a[2]) / (2 * P) + G / P^2
  expect_equal(x$SCA[1, 2], unname(s12))
  expect_equal(x$Reciprocal[1, 2], (M[1, 2] - M[2, 1]) / 2)
  v <- x$ANOVA["Error", "Mean Sq"]
  expect_equal(unname(x$StdErr), sqrt(v * c((P - 1) / (2 * P^2), (P - 1)^2 / P^2, (P^2 - 2 * P + 2) / (2 * P^2), 1 / 2,
                                             1 / P, 2 * (P - 2) / P, (3 * P - 2) / (2 * P), 3 * (P - 2) / (2 * P),
                                             (P - 1) / P, (P - 2) / P, 1)))
})

test_that("Method 2: closed forms", {
  x <- fit(2)
  Y <- sym_table(x)
  P <- nrow(Y)
  a <- rowSums(Y) + diag(Y)
  G <- sum(Y[upper.tri(Y, diag = TRUE)])
  expect_equal(x$ANOVA["gca", "Sum Sq"], (sum(a^2) - 4 * G^2 / P) / (P + 2))
  expect_equal(x$ANOVA["sca", "Sum Sq"], sum(Y[upper.tri(Y, diag = TRUE)]^2) - sum(a^2) / (P + 2) +
                 2 * G^2 / ((P + 1) * (P + 2)))
  expect_equal(unname(x$GCA), unname((a - 2 * G / P) / (P + 2)))
  v <- x$ANOVA["Error", "Mean Sq"]
  # Griffing (1956), Method 2: Var(s_ii) = P(P - 1)/((P + 1)(P + 2)), Var(s_ij) = (P^2 + P + 2)/((P + 1)(P + 2))
  # (version 0.6.0 had the two swapped)
  expect_equal(unname(x$StdErr), sqrt(v * c((P - 1) / (P * (P + 2)), P * (P - 1) / ((P + 1) * (P + 2)),
                                             (P^2 + P + 2) / ((P + 1) * (P + 2)), 2 / (P + 2), 2 * (P - 2) / (P + 2),
                                             2 * (P + 1) / (P + 2), 2 * P / (P + 2))))
})

test_that("Method 3: closed forms", {
  x <- fit(3)
  M <- x$Means
  M[is.na(M)] <- 0
  P <- nrow(M)
  a <- rowSums(M) + colSums(M)
  G <- sum(M)
  Ys <- M + t(M)
  expect_equal(x$ANOVA["gca", "Sum Sq"], sum(a^2) / (2 * (P - 2)) - 2 * G^2 / (P * (P - 2)))
  expect_equal(x$ANOVA["sca", "Sum Sq"], sum(Ys[upper.tri(Ys)]^2) / 2 - sum(a^2) / (2 * (P - 2)) +
                 G^2 / ((P - 1) * (P - 2)))
  expect_equal(unname(x$GCA), unname(a / (2 * (P - 2)) - G / (P * (P - 2))))
  v <- x$ANOVA["Error", "Mean Sq"]
  expect_equal(unname(x$StdErr), sqrt(v * c((P - 1) / (2 * P * (P - 2)), (P - 3) / (2 * (P - 1)), 1 / 2,
                                             1 / (P - 2), (P - 3) / (P - 2), (P - 4) / (P - 2))))
})

test_that("Method 4: closed forms; the undefined standard error is NA", {
  x <- fit(4)
  Y <- sym_table(x)
  P <- nrow(Y)
  a <- rowSums(Y)
  G <- sum(Y[upper.tri(Y)])
  expect_equal(x$ANOVA["gca", "Sum Sq"], sum(a^2) / (P - 2) - 4 * G^2 / (P * (P - 2)))
  expect_equal(x$ANOVA["sca", "Sum Sq"], sum(Y[upper.tri(Y)]^2) - sum(a^2) / (P - 2) + 2 * G^2 / ((P - 1) * (P - 2)))
  expect_equal(unname(x$GCA), unname((P * a - 2 * G) / (P * (P - 2))))
  v <- x$ANOVA["Error", "Mean Sq"]
  expect_true(is.na(x$StdErr[["not_defined"]]))
  expect_equal(unname(x$StdErr[-3]), sqrt(v * c((P - 1) / (P * (P - 2)), (P - 3) / (P - 1), 2 / (P - 2),
                                                 2 * (P - 3) / (P - 2), 2 * (P - 4) / (P - 2))))
})

test_that("the expected mean squares of the random model are Griffing's", {
  P <- 8
  for (m in 1:4) {
    x <- fit(m, model = 2)
    dec <- .da_griffing_decompose(x$Means, m)
    cg <- c(2 * P, P + 2, 2 * (P - 2), P - 2)[m]
    cs_g <- c(2 * (P - 1) / P, 1, 2, 1)[m]
    cs_s <- c(2 * (P^2 - P + 1) / P^2, 1, 2, 1)[m]
    expect_equal(unname(dec$ems["gca", c("gca", "sca")]), c(cg, cs_g), label = paste("Method", m, "gca"))
    expect_equal(unname(dec$ems["sca", c("gca", "sca")]), c(0, cs_s), label = paste("Method", m, "sca"))
    if (m %in% c(1, 3)) expect_equal(unname(dec$ems["reciprocals", "reciprocals"]), 2)
    gc <- x$Genetic.Components
    ms <- x$ANOVA[["Mean Sq"]]
    nl <- nrow(x$ANOVA)
    sca <- (ms[2] - ms[nl]) / cs_s
    expect_equal(gc["sca", "Components"], sca)
    expect_equal(gc["gca", "Components"], (ms[1] - ms[nl] - cs_g * sca) / cg)
    expect_equal(gc["Additive", "Components"], 2 * gc["gca", "Components"])
  }
})

test_that("the error mean square is that of the block analysis of the plot data", {
  x <- fit(1)
  a <- stats::anova(stats::lm(Yield ~ factor(Rep) + interaction(Cross1, Cross2), data = GriffingData1))
  expect_equal(x$ANOVA["Error", "Mean Sq"], a[3, "Mean Sq"] / 4)
  expect_equal(x$ANOVA["Error", "Df"], a[3, "Df"])
  expect_equal(x$RCBD["Residuals", "Sum Sq"], a[3, "Sum Sq"])
})

test_that("tests: fixed model against the error, random model gca against sca", {
  x1 <- fit(1, 1)
  x2 <- fit(1, 2)
  A1 <- x1$ANOVA
  A2 <- x2$ANOVA
  expect_equal(A1["gca", "F value"], A1["gca", "Mean Sq"] / A1["Error", "Mean Sq"])
  expect_equal(A2["gca", "F value"], A2["gca", "Mean Sq"] / A2["sca", "Mean Sq"])
  expect_equal(A2["reciprocals", "Pr(>F)"], stats::pf(A2["reciprocals", "F value"], 28, 189, lower.tail = FALSE))
})

test_that("columns are taken by name, as strings or as vectors; crosses may be recorded either way round", {
  d <- GriffingData1
  names(d) <- c("F", "M", "B", "Y")
  x <- Griffing(y = Y, Rep = B, Cross1 = F, Cross2 = M, data = d, Method = 1, Model = 1)
  x0 <- fit(1)
  expect_equal(x$ANOVA, x0$ANOVA)
  x <- Griffing(y = "Y", Rep = "B", Cross1 = "F", Cross2 = "M", data = d, Method = 1, Model = 1)
  expect_equal(x$GCA, x0$GCA)
  d2 <- GriffingData2
  sw <- seq(1, nrow(d2), 2)
  tmp <- d2$Cross1[sw]
  d2$Cross1[sw] <- d2$Cross2[sw]
  d2$Cross2[sw] <- tmp
  expect_equal(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d2, Method = 2,
                        Model = 1)$ANOVA, fit(2)$ANOVA)
})

test_that("input errors are reported", {
  expect_error(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 5,
                        Model = 1), "Method")
  expect_error(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 3,
                        Model = 1), "no parents")
  expect_error(Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = subset(GriffingData1, !(Cross1 == 1 & Cross2 == 2)),
                        Method = 1, Model = 1), "missing")
  expect_error(Griffing(y = Nope, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = GriffingData1, Method = 1,
                        Model = 1), "column")
})

test_that("results keep the components of earlier versions and have the methods", {
  x <- fit(1)
  expect_result(x, "griffing", components = c("Means", "ANOVA", "Genetic.Components", "Effects", "StdErr"))
  expect_identical(names(x)[1:5], c("Means", "ANOVA", "Genetic.Components", "Effects", "StdErr"))
  expect_identical(names(fit(1, 2))[1:3], c("Means", "ANOVA", "Genetic.Components"))
  expect_s3_class(plot(x), "ggplot")
  expect_s3_class(plot(x, which = "sca"), "ggplot")
  expect_s3_class(plot(fit(2, 2)), "ggplot")
  expect_identical(names(data.table::as.data.table(x, component = "ANOVA"))[1:2], c("term", "Df"))
})

test_that("Griffing's (1956) example: every published number within its last printed digit", {
  r <- da_reference(source = "Griffing \\(1956\\)", evaluate = TRUE, level = 1)
  expect_gt(nrow(r), 70)
  expect_true(all(abs(r$computed - r$value) < 1.5 * 10^-r$digits))
})

test_that("missing plots: cell means adjusted for blocks equal the least-squares means", {
  set.seed(3)
  d <- GriffingData1[-sample(nrow(GriffingData1), 5), ]
  f <- Griffing(y = Yield, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = d, Method = 1, Model = 1)
  a <- stats::lm(Yield ~ 0 + interaction(Cross1, Cross2, lex.order = TRUE) + Rep, data = d,
                 contrasts = list(Rep = "contr.sum"))
  expect_equal(unname(f$Means[1, 1:3]), unname(stats::coef(a)[1:3]))
  expect_equal(f$ANOVA["Error", "Df"], 184)
  expect_match(attr(f, "label"), "missing plots")
})
