test_that("every published value in inst/extdata/reference.csv is reproduced", {
  lev <- as.integer(Sys.getenv("DIALLELANALYSISR_TEST_LEVEL", "1"))
  ref <- da_reference(evaluate = TRUE, level = lev)
  skip_if(nrow(ref) == 0L, "no reference values yet")
  tested <- ref[(is.na(note) | note == "") & level <= lev]
  for (r in seq_len(nrow(tested))) {
    expect_true(tested$agrees[r], label = sprintf("%s (%s, %s): computed %s, published %s", tested$id[r],
                                                  tested$source[r], tested$quantity[r], tested$computed[r],
                                                  tested$value[r]))
  }
})
