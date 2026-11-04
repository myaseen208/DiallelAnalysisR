#-------------------------------------------------------------------------------------------------------------------
# Shared test helpers (common layer; synced from SKILL.qmd).
#-------------------------------------------------------------------------------------------------------------------

# level 1: fast tests (CRAN); level 2: slow tests (DIALLELANALYSISR_TEST_LEVEL=2, run by the maintainer)
skip_level <- function(level) {
  testthat::skip_if(as.integer(Sys.getenv("DIALLELANALYSISR_TEST_LEVEL", "1")) < level,
                    paste0("DIALLELANALYSISR_TEST_LEVEL below ", level))
}

# a result: the legacy list with its class and methods
expect_result <- function(x, cls, components = NULL) {
  testthat::expect_s3_class(x, c(paste0("da_", cls), "da_result", "list"))
  if (!is.null(components)) testthat::expect_true(all(components %in% names(x)))
  testthat::expect_output(print(x))
  # a tailored summary has the class summary.da_<analysis>, the general one summary.da_result
  testthat::expect_true(inherits(summary(x), c(paste0("summary.da_", cls), "summary.da_result")))
  testthat::expect_type(format(x), "character")
  invisible(x)
}

# numbers agree to `digits` significant digits (the precision of a printed table)
expect_digits <- function(object, expected, digits = 4L) {
  testthat::expect_equal(signif(unname(object), digits), signif(unname(expected), digits))
}

# the folder of the legacy snapshots (dev/legacy) when the tests run from the source tree, else ""
legacy_dir <- function() {
  for (d in c("../../dev/legacy", "dev/legacy")) if (dir.exists(d)) return(normalizePath(d))
  ""
}
