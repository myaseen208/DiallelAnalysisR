test_that("results keep the legacy components and gain the methods", {
  x <- .da_result(
      list(ANOVA = data.frame(Df = c(1, 2), row.names = c("a", "b")), Means = c(u = 1, v = 2))
    , cls   = "demo"
    , label = "a demonstration"
    )
  expect_result(x, "demo", components = c("ANOVA", "Means"))
  expect_identical(names(x), c("ANOVA", "Means"))
  expect_identical(x$Means, c(u = 1, v = 2))
  tb <- data.table::as.data.table(x, component = "ANOVA")
  expect_identical(names(tb), c("term", "Df"))
  expect_identical(tb$term, c("a", "b"))
  expect_identical(nrow(as.data.frame(x, component = "Means")), 2L)
  expect_error(data.table::as.data.table(x, component = "nope"), "no component")
  expect_error(plot(x), "no plot")
})
