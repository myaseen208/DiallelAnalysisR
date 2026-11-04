test_that("the analysis of variance equals the sequential linear model", {
  p <- PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData)
  a <- stats::anova(stats::lm(y ~ factor(Rep) + factor(Cross1) * factor(Cross2), data = PartialDiallelData))
  expect_equal(p$ANOVA["GCA I", "Sum Sq"], a[2, "Sum Sq"])
  expect_equal(p$ANOVA["GCA II", "Sum Sq"], a[3, "Sum Sq"])
  expect_equal(p$ANOVA["SCA", "Sum Sq"], a[4, "Sum Sq"])
  expect_equal(p$ANOVA["Error", "Sum Sq"], a[5, "Sum Sq"])
  expect_equal(p$ANOVA["Error", "Df"], a[5, "Df"])
  expect_equal(p$ANOVA["SCA", "F value"], a[4, "F value"])
})

test_that("variance components and effects follow their formulas", {
  p <- PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData)
  ms <- p$ANOVA[["Mean Sq"]]
  B <- 4
  L <- 10
  M <- 4
  expect_equal(p$Genetic.Components$Components, c((ms[2] - ms[4]) / (B * M), (ms[3] - ms[4]) / (B * L),
                                                  (ms[4] - ms[5]) / B))
  expect_equal(sum(p$Genetic.Components$Percent), 1)
  expect_equal(sum(p$General[1:10]), 0)
  expect_equal(unname(rowSums(p$Specific)), rep(0, 10))
})

test_that("column arguments are used; input errors are reported; methods", {
  d <- PartialDiallelData
  names(d) <- c("A", "Bb", "Blk", "Yv")
  p1 <- PartialDiallel(y = Yv, Rep = Blk, Cross1 = A, Cross2 = Bb, data = d)
  p0 <- PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross2, data = PartialDiallelData)
  expect_equal(p1$ANOVA, p0$ANOVA)
  expect_error(PartialDiallel(y = y, Rep = Rep, Cross1 = Cross1, Cross2 = Cross1, data = PartialDiallelData),
               "both groups")
  expect_result(p0, "partial", components = c("Means", "ANOVA", "Genetic.Components", "General", "Specific"))
  expect_s3_class(plot(p0), "ggplot")
  expect_s3_class(plot(p0, which = "sca"), "ggplot")
})
