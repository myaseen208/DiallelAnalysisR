test_that("the theme and the save helper work", {
  p <-
    ggplot2::ggplot(data = data.frame(x = 1:5, y = 1:5), mapping = ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point() +
    da_theme()
  expect_s3_class(p, "ggplot")
  f <- tempfile(fileext = ".pdf")
  skip_if_not(capabilities("cairo"), "no cairo device")
  expect_identical(da_save(plot = p, filename = f, width = 4, height = 3), f)
  expect_true(file.exists(f))
})
