#-------------------------------------------------------------------------------------------------------------------
# Helpers shared by the extension analyses
#-------------------------------------------------------------------------------------------------------------------

# analysis-of-variance table; `against` names, for each line, the line whose mean square is its denominator
# (NA: no test)
.da_aov <- function(ss, df, against) {
  ms <- ss / df
  den <- ms[against]
  dfd <- df[against]
  Fv <- unname(ms / den)
  pv <- stats::pf(Fv, df, dfd, lower.tail = FALSE)
  out <- data.frame(Df = unname(df), `Sum Sq` = unname(ss), `Mean Sq` = unname(ms), `F value` = Fv, `Pr(>F)` = pv,
                    check.names = FALSE, row.names = names(ss))
  class(out) <- c("anova", "data.frame")
  out
}

# sequential (type I) sums of squares of the column blocks of X for the response v
.da_seq_ss <- function(X, blocks, v) {
  ss <- numeric(length(blocks))
  prev <- 0
  cols <- integer(0)
  for (k in seq_along(blocks)) {
    cols <- c(cols, blocks[[k]])
    f <- stats::lm.fit(X[, cols, drop = FALSE], v)
    cur <- sum(f$fitted.values^2)
    ss[k] <- cur - prev
    prev <- cur
  }
  stats::setNames(ss, names(blocks))
}

# sum-to-zero coding of a factor with levels lab: P - 1 columns, the last level -1 everywhere
.da_sum0 <- function(idx, P) {
  X <- matrix(0, length(idx), P)
  X[cbind(seq_along(idx), idx)] <- 1
  X[, -P, drop = FALSE] - X[, P]
}

# full vector of P sum-to-zero effects from P - 1 coefficients, with their covariance matrix
.da_full_effects <- function(b, V) {
  P <- length(b) + 1L
  C <- rbind(diag(P - 1L), -1)
  list(est = drop(C %*% b), var = C %*% V %*% t(C))
}

# least-squares fit returning coefficients and the unscaled covariance matrix
.da_ls <- function(X, v) {
  qx <- qr(X)
  b <- qr.coef(qx, v)
  Ri <- backsolve(qr.R(qx), diag(ncol(X)))
  V <- Ri %*% t(Ri)
  piv <- qx$pivot
  Vb <- V
  Vb[piv, piv] <- V
  list(coef = b, unscaled = Vb, fitted = drop(X %*% b))
}
