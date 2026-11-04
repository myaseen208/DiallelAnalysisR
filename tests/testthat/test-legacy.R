# Regression against the released version: the examples of every help page of the released version are run with
# this version and every object they create is compared with the saved result (tools/legacy-snapshot.R).
# Results that the released version got wrong are listed in dev/legacy/exceptions.csv (columns topic, object,
# reason): `object` is an object name, `name$component` for one component of a list, or `*` for the whole topic.
# Runs from the source tree only (dev/ is not part of the built package).
test_that("results agree with the released version (except documented corrections)", {
  dir <- legacy_dir()
  skip_if(!nzchar(dir), "no dev/legacy snapshots (source tree only)")
  exc  <- utils::read.csv(file.path(dir, "exceptions.csv"), stringsAsFactors = FALSE)
  skip <- function(topic, what) any(exc$topic == topic & (exc$object == what | exc$object == "*"))
  for (rds in list.files(dir, pattern = "\\.rds$", full.names = TRUE)) {
    topic <- sub("\\.rds$", "", basename(rds))
    old <- readRDS(rds)
    ex <- file.path(dir, "examples", paste0(topic, ".R"))
    if (!identical(old$status, "ok") || !file.exists(ex) || !length(old$objects)) next
    e <- new.env(parent = globalenv())
    sys.source(ex, envir = e, keep.source = FALSE)
    for (nm in names(old$objects)) {
      if (skip(topic, nm)) next
      ref <- old$objects[[nm]]
      new <- e[[nm]]
      if (is.list(ref) && !is.data.frame(ref)) {
        for (comp in names(ref)) {
          if (skip(topic, paste0(nm, "$", comp))) next
          expect_equal(unclass(new)[[comp]], ref[[comp]], tolerance = 1e-8, ignore_attr = TRUE,
                       label = sprintf("%s: %s$%s", topic, nm, comp))
        }
      } else {
        expect_equal(new, ref, tolerance = 1e-8, ignore_attr = TRUE, label = sprintf("%s: %s", topic, nm))
      }
    }
  }
})
