#-------------------------------------------------------------------------------------------------------------------
# Computational core shared by the diallel analyses: cell means, the error mean square of the randomized complete
# block experiment, and the exact least-squares decomposition of the table of cell means into general combining
# ability (gca), specific combining ability (sca) and reciprocal effects (Griffing 1956). One code path serves the
# four methods; every quantity is a linear or quadratic function of the cell means, so standard errors and expected
# mean squares follow exactly from the same projection matrices.
#-------------------------------------------------------------------------------------------------------------------

# parents in a natural order: numeric labels numerically, other labels alphabetically
.da_parent_levels <- function(...) {
  lab <- unique(unlist(lapply(list(...), function(v) as.character(if (is.factor(v)) levels(droplevels(v)) else v))))
  num <- suppressWarnings(as.numeric(lab))
  if (!anyNA(num)) lab[order(num)] else sort(lab)
}

# cells (ordered pairs of parent indices) of each of Griffing's methods for P parents
.da_cells <- function(method, P) {
  ij <- expand.grid(i = seq_len(P), j = seq_len(P))
  keep <-
    switch(
        method
      , ij$i <= P                 # 1: parents, F1 and reciprocals
      , ij$i <= ij$j              # 2: parents and one set of F1
      , ij$i != ij$j              # 3: F1 and reciprocals
      , ij$i <  ij$j              # 4: one set of F1
      )
  ij <- ij[keep, ]
  ij[order(ij$i, ij$j), ]
}

# Cell means and the error mean square from plot data.
# Returns list(M = P x P matrix of cell means (NA where a cell is not part of the design), parents, R (replicates),
#              mse, df_e, ss_e (plot scale), anova (data frame: Rep, Crosses, Residuals), n_plots)
.da_cell_data <- function(y, p1, p2, rep, method, fn) {
  if (!is.numeric(y)) .da_stop(fn, "`y` must be numeric.")
  ok <- !is.na(y) & !is.na(p1) & !is.na(p2) & !is.na(rep)
  if (!all(ok)) .da_warn(fn, sum(!ok), " plot(s) with missing values dropped.")
  y   <- y[ok]
  rep <- factor(rep[ok])
  parents <- .da_parent_levels(p1[ok], p2[ok])
  P   <- length(parents)
  i   <- match(as.character(p1[ok]), parents)
  j   <- match(as.character(p2[ok]), parents)
  if (method %in% c(2L, 4L)) {
    # one set of F1: a cross may be recorded either way round; store it with the lower parent first
    lo <- pmin(i, j)
    hi <- pmax(i, j)
    i  <- lo
    j  <- hi
  }
  if (method %in% c(3L, 4L) && any(i == j)) {
    .da_stop(fn, "Method ", method, " has no parents (selfs), but `data` has rows with Cross1 equal to Cross2.")
  }
  if (method %in% c(2L, 4L) && P < 3L) .da_stop(fn, "at least 3 parents are needed.")
  cells <- .da_cells(method, P)
  key   <- (i - 1L) * P + j
  want  <- (cells$i - 1L) * P + cells$j
  if (length(setdiff(unique(key), want))) .da_stop(fn, "`data` has crosses that Method ", method, " does not include.")
  miss <- setdiff(want, unique(key))
  if (length(miss)) {
    .da_stop(fn, length(miss), " cross(es) of Method ", method, " are missing from `data` (for example ",
             parents[(miss[1L] - 1L) %/% P + 1L], " x ", parents[(miss[1L] - 1L) %% P + 1L],
             "). The analysis needs every cross; for incomplete diallels fit a linear mixed model.")
  }
  # cell means by grouped sums (one pass)
  cell <- factor(key, levels = want)
  s    <- rowsum(y, cell, reorder = TRUE)[, 1L]
  cnt  <- tabulate(cell, nbins = length(want))
  M    <- matrix(NA_real_, P, P, dimnames = list(parents, parents))
  M[cbind(cells$i, cells$j)] <- s / cnt
  # randomized complete block analysis: closed form when every cell has one plot in every replicate
  R <- nlevels(rep)
  N <- length(y)
  balanced <- all(cnt == R) && all(table(cell, rep) == 1L)
  if (R == 1L && N == length(want)) {
    fit <- s / cnt
    df  <- c(0L, length(want) - 1L, 0L)
    ss  <- c(0, sum((y - mean(y))^2), 0)
  } else if (balanced) {
    G      <- sum(y)
    ss_tot <- sum(y^2) - G^2 / N
    ss_rep <- sum(rowsum(y, rep)[, 1L]^2) / length(want) - G^2 / N
    ss_trt <- sum(s^2) / R - G^2 / N
    ss_e   <- ss_tot - ss_rep - ss_trt
    df     <- c(R - 1L, length(want) - 1L, N - R - length(want) + 1L)
    ss     <- c(ss_rep, ss_trt, ss_e)
    fit    <- (s / cnt)[as.integer(cell)] + (rowsum(y, rep)[, 1L] / length(want))[as.integer(rep)] - G / N
  } else {
    # missing plots: least-squares cell means adjusted for blocks (block effects summing to zero), so a cross that
    # lost its plot in a good or a poor block is not biased; the error variance of a cell mean uses the harmonic mean
    # of the numbers of plots per cross (exact when every cross has the same number of plots)
    X1  <- stats::model.matrix(~ rep)
    X2  <- stats::model.matrix(~ 0 + cell + rep, contrasts.arg = list(rep = "contr.sum"))
    f1  <- stats::lm.fit(X1, y)
    f2  <- stats::lm.fit(X2, y)
    ss  <- c(sum((f1$fitted.values - mean(y))^2), sum(f1$residuals^2) - sum(f2$residuals^2), sum(f2$residuals^2))
    fit <- f2$fitted.values
    df  <- c(f1$rank - 1L, f2$rank - f1$rank, N - f2$rank)
    if (df[3L] < 1L) .da_stop(fn, "no degrees of freedom left for the error.")
    M[cbind(cells$i, cells$j)] <- f2$coefficients[seq_along(want)]
    R   <- 1 / mean(1 / cnt)                                    # harmonic mean of plots per cross
  }
  anova <- data.frame(Df = df, `Sum Sq` = ss, `Mean Sq` = ss / df, check.names = FALSE,
                      row.names = c("Rep", "Crosses", "Residuals"))
  plots <- data.table::data.table(Cross1 = parents[i], Cross2 = parents[j], Rep = rep, y = y, fitted = unname(fit),
                                  residual = unname(y - fit))
  list(M = M, parents = parents, R = R, mse = ss[3L] / df[3L], df_e = df[3L], ss_e = ss[3L], anova = anova,
       n_plots = N, cells = cells, balanced = balanced, plots = plots)
}

#-------------------------------------------------------------------------------------------------------------------
# Closed forms of Griffing (1956) for the four methods: sums of squares, effects, coefficients of the expected mean
# squares and of the variances of the effects. tests/testthat/test-core.R checks every quantity against the exact
# least-squares decomposition (.da_griffing_decompose(), R/utils-reference.R) for several numbers of parents.
#-------------------------------------------------------------------------------------------------------------------
.da_griffing_closed <- function(M, method) {
  P <- nrow(M)
  if (method %in% c(2L, 4L)) {
    # one set of F1: the symmetric table of the crosses (each cross in both of its arrays)
    U <- M
    U[is.na(U)] <- 0
    Y <- U + t(U) - diag(diag(U))
  } else {
    Y <- M
    if (method == 3L) diag(Y) <- 0
  }
  out <-
    switch(
        method
      , {                                                                    # Method 1
          a <- rowSums(Y) + colSums(Y)
          G <- sum(Y)
          list(
              ss  = c(gca = sum(a^2) / (2 * P) - 2 * G^2 / P^2,
                      sca = sum(Y * (Y + t(Y))) / 2 - sum(a^2) / (2 * P) + G^2 / P^2,
                      reciprocals = sum((Y - t(Y))^2) / 4)
            , df  = c(gca = P - 1, sca = P * (P - 1) / 2, reciprocals = P * (P - 1) / 2)
            , g   = a / (2 * P) - G / P^2
            , S   = (Y + t(Y)) / 2 - outer(a, a, `+`) / (2 * P) + G / P^2
            , R   = (Y - t(Y)) / 2
            , ems = rbind(gca = c(2 * P, 2 * (P - 1) / P, 0), sca = c(0, 2 * (P^2 - P + 1) / P^2, 0),
                          reciprocals = c(0, 0, 2))
            , vse = c(gi = (P - 1) / (2 * P^2), sii = (P - 1)^2 / P^2, sij = (P^2 - 2 * P + 2) / (2 * P^2), rij = 1 / 2,
                      gi_gj = 1 / P, sii_sjj = 2 * (P - 2) / P, sii_sij = (3 * P - 2) / (2 * P),
                      sii_sjk = 3 * (P - 2) / (2 * P), sij_sik = (P - 1) / P, sij_skl = (P - 2) / P, rij_rkl = 1)
            )
        }
      , {                                                                    # Method 2
          a <- rowSums(Y) + diag(Y)
          G <- sum(Y[upper.tri(Y, diag = TRUE)])
          S <- Y - outer(a, a, `+`) / (P + 2) + 2 * G / ((P + 1) * (P + 2))
          list(
              ss  = c(gca = (sum(a^2) - 4 * G^2 / P) / (P + 2),
                      sca = sum(Y[upper.tri(Y, diag = TRUE)]^2) - sum(a^2) / (P + 2) + 2 * G^2 / ((P + 1) * (P + 2)))
            , df  = c(gca = P - 1, sca = P * (P - 1) / 2)
            , g   = (a - 2 * G / P) / (P + 2)
            , S   = S
            , R   = NULL
            , ems = rbind(gca = c(P + 2, 1), sca = c(0, 1))
            , vse = c(gi = (P - 1) / (P * (P + 2)), sii = P * (P - 1) / ((P + 1) * (P + 2)),
                      sij = (P^2 + P + 2) / ((P + 1) * (P + 2)), gi_gj = 2 / (P + 2), sii_sjj = 2 * (P - 2) / (P + 2),
                      sij_sik = 2 * (P + 1) / (P + 2), sij_skl = 2 * P / (P + 2))
            )
        }
      , {                                                                    # Method 3
          a <- rowSums(Y) + colSums(Y)
          G <- sum(Y)
          Ys <- Y + t(Y)
          S <- Ys / 2 - outer(a, a, `+`) / (2 * (P - 2)) + G / ((P - 1) * (P - 2))
          diag(S) <- NA
          list(
              ss  = c(gca = sum(a^2) / (2 * (P - 2)) - 2 * G^2 / (P * (P - 2)),
                      sca = sum(Ys[upper.tri(Ys)]^2) / 2 - sum(a^2) / (2 * (P - 2)) + G^2 / ((P - 1) * (P - 2)),
                      reciprocals = sum((Y - t(Y))^2) / 4)
            , df  = c(gca = P - 1, sca = P * (P - 3) / 2, reciprocals = P * (P - 1) / 2)
            , g   = a / (2 * (P - 2)) - G / (P * (P - 2))
            , S   = S
            , R   = (Y - t(Y)) / 2
            , ems = rbind(gca = c(2 * (P - 2), 2, 0), sca = c(0, 2, 0), reciprocals = c(0, 0, 2))
            , vse = c(gi = (P - 1) / (2 * P * (P - 2)), sij = (P - 3) / (2 * (P - 1)), rij = 1 / 2, gi_gj = 1 / (P - 2),
                      sij_sik = (P - 3) / (P - 2), sij_skl = (P - 4) / (P - 2))
            )
        }
      , {                                                                    # Method 4
          a <- rowSums(Y)
          G <- sum(Y[upper.tri(Y)])
          S <- Y - outer(a, a, `+`) / (P - 2) + 2 * G / ((P - 1) * (P - 2))
          diag(S) <- NA
          list(
              ss  = c(gca = sum(a^2) / (P - 2) - 4 * G^2 / (P * (P - 2)),
                      sca = sum(Y[upper.tri(Y)]^2) - sum(a^2) / (P - 2) + 2 * G^2 / ((P - 1) * (P - 2)))
            , df  = c(gca = P - 1, sca = P * (P - 3) / 2)
            , g   = (P * a - 2 * G) / (P * (P - 2))
            , S   = S
            , R   = NULL
            , ems = rbind(gca = c(P - 2, 1), sca = c(0, 1))
            , vse = c(gi = (P - 1) / (P * (P - 2)), sij = (P - 3) / (P - 1), gi_gj = 2 / (P - 2),
                      sij_sik = 2 * (P - 3) / (P - 2), sij_skl = 2 * (P - 4) / (P - 2))
            )
        }
      )
  k <- nrow(out$ems)
  out$ems <- out$ems[, seq_len(k), drop = FALSE]
  dimnames(out$ems) <- list(names(out$ss), names(out$ss))
  out$recip <- method %in% c(1L, 3L)
  out$g <- unname(out$g)
  out
}
