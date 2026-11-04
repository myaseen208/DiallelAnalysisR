#-------------------------------------------------------------------------------------------------------------------
# Reference implementation (used by the tests, never by the analyses): the exact least-squares decomposition of the
# vector of cell means into the gca, sca and reciprocal subspaces, with the effect operators and the expected mean
# squares computed from the projection matrices. The closed forms of .da_griffing_closed() must agree with it.
#-------------------------------------------------------------------------------------------------------------------

# Exact decomposition of the vector of cell means (Griffing 1956) for method 1 to 4.
# Returns the sums of squares, effects, the linear operators of the effects (for standard errors) and the
# coefficient matrices of the expected mean squares.
.da_griffing_decompose <- function(M, method) {
  P     <- nrow(M)
  cells <- .da_cells(method, P)
  i     <- cells$i
  j     <- cells$j
  K     <- nrow(cells)
  y     <- M[cbind(i, j)]
  # design columns: mean, gca, sca (unordered pairs, selfs included in methods 1 and 2), reciprocal (i < j)
  Zg <- matrix(0, K, P)
  Zg[cbind(seq_len(K), i)] <- 1
  Zg[cbind(seq_len(K), j)] <- Zg[cbind(seq_len(K), j)] + 1
  pair  <- paste(pmin(i, j), pmax(i, j))
  upair <- unique(pair)
  Zs    <- outer(pair, upair, `==`) * 1
  recip <- method %in% c(1L, 3L)
  if (recip) {
    off   <- i != j
    rpair <- unique(pair[off])
    Zr    <- outer(pair, rpair, `==`) * ifelse(i < j, 1, -1)
    Zr[!off, ] <- 0
  } else {
    Zr <- matrix(0, K, 0L)
  }
  proj <- function(X) {
    q <- qr(X)
    Q <- qr.Q(q)[, seq_len(q$rank), drop = FALSE]
    tcrossprod(Q)
  }
  one <- matrix(1, K, 1L)
  H0  <- proj(one)
  H1  <- proj(cbind(one, Zg))
  H2  <- proj(cbind(one, Zg, Zs))
  H3  <- if (recip) proj(cbind(one, Zg, Zs, Zr)) else H2
  Qg  <- H1 - H0
  Qs  <- H2 - H1
  Qr  <- H3 - H2
  # effect operators: gca from the gca part of the fit, sca and reciprocal effects from their parts
  Lg  <- solve(crossprod(Zg), crossprod(Zg, Qg))
  Ls  <- crossprod(Zs, Qs) / colSums(Zs)
  Lr  <- if (recip) crossprod(Zr, Qr) / colSums(Zr^2) else matrix(0, 0L, K)
  g   <- drop(Lg %*% y)
  s   <- drop(Ls %*% y)
  rr  <- if (recip) drop(Lr %*% y) else numeric(0)
  ss  <- c(gca = sum((Qg %*% y)^2), sca = sum((Qs %*% y)^2), if (recip) c(reciprocals = sum((Qr %*% y)^2)))
  df  <- c(gca = P - 1L, sca = round(sum(diag(Qs))), if (recip) c(reciprocals = round(sum(diag(Qr)))))
  # sca and reciprocal effects as P x P matrices (sca symmetric; reciprocal r_ij = -r_ji)
  S <- matrix(NA_real_, P, P)
  ip <- as.integer(sub(" .*$", "", upair))
  jp <- as.integer(sub("^.* ", "", upair))
  S[cbind(ip, jp)] <- s
  S[cbind(jp, ip)] <- s
  Rm <- matrix(if (recip) 0 else NA_real_, P, P)
  if (recip) {
    ir <- as.integer(sub(" .*$", "", rpair))
    jr <- as.integer(sub("^.* ", "", rpair))
    Rm[cbind(ir, jr)] <- rr
    Rm[cbind(jr, ir)] <- -rr
  }
  # expected mean squares (random model): E(MS_x) = sum_k coef[x, k] var_k + var_e, k in gca, sca, reciprocal
  Q   <- list(gca = Qg, sca = Qs, reciprocals = if (recip) Qr)
  Q   <- Q[!vapply(Q, is.null, logical(1))]
  Zk  <- list(gca = Zg, sca = Zs, reciprocals = if (recip) Zr)
  Zk  <- Zk[!vapply(Zk, is.null, logical(1))]
  ems <- vapply(Zk, function(Z) vapply(names(Q), function(x) sum(diag(Q[[x]] %*% tcrossprod(Z))) / df[[x]],
                                       numeric(1)), numeric(length(Q)))
  ems <- matrix(ems, nrow = length(Q), dimnames = list(names(Q), names(Zk)))
  list(P = P, K = K, y = y, cells = cells, ss = ss, df = df, g = g, S = S, R = Rm, Lg = Lg, Ls = Ls, Lr = Lr,
       pairs = upair, rpairs = if (recip) rpair else character(0), ems = ems, recip = recip, Zg = Zg, Qg = Qg,
       Qs = Qs, Qr = Qr)
}

# standard errors of effects and of differences of effects (Griffing 1956), from the effect operators;
# var_m is the error variance of a cell mean (error mean square / replicates)
.da_griffing_se_ref <- function(dec, method, var_m) {
  P   <- dec$P
  vg  <- var_m * tcrossprod(dec$Lg)
  vs  <- var_m * tcrossprod(dec$Ls)
  pid <- function(a, b) match(paste(min(a, b), max(a, b)), dec$pairs)
  se  <- function(v, a, b = NULL) if (is.null(b)) sqrt(v[a, a]) else sqrt(v[a, a] + v[b, b] - 2 * v[a, b])
  out <-
    switch(
        method
      , c(  gi       = se(vg, 1L)
          , sii      = se(vs, pid(1, 1))
          , sij      = se(vs, pid(1, 2))
          , rij      = sqrt(var_m * sum(dec$Lr[1L, ]^2))
          , gi_gj    = se(vg, 1L, 2L)
          , sii_sjj  = se(vs, pid(1, 1), pid(2, 2))
          , sii_sij  = se(vs, pid(1, 1), pid(1, 2))
          , sii_sjk  = se(vs, pid(1, 1), pid(2, 3))
          , sij_sik  = se(vs, pid(1, 2), pid(1, 3))
          , sij_skl  = se(vs, pid(1, 2), pid(3, 4))
          , rij_rkl  = sqrt(var_m * sum((dec$Lr[1L, ] - dec$Lr[match(paste(3, 4), dec$rpairs), ])^2))
          )
      , c(  gi       = se(vg, 1L)
          , sii      = se(vs, pid(1, 1))
          , sij      = se(vs, pid(1, 2))
          , gi_gj    = se(vg, 1L, 2L)
          , sii_sjj  = se(vs, pid(1, 1), pid(2, 2))
          , sij_sik  = se(vs, pid(1, 2), pid(1, 3))
          , sij_skl  = se(vs, pid(1, 2), pid(3, 4))
          )
      , c(  gi       = se(vg, 1L)
          , sij      = se(vs, pid(1, 2))
          , rij      = sqrt(var_m * sum(dec$Lr[1L, ]^2))
          , gi_gj    = se(vg, 1L, 2L)
          , sij_sik  = se(vs, pid(1, 2), pid(1, 3))
          , sij_skl  = se(vs, pid(1, 2), pid(3, 4))
          )
      , c(  gi       = se(vg, 1L)
          , sij      = se(vs, pid(1, 2))
          , gi_gj    = se(vg, 1L, 2L)
          , sij_sik  = se(vs, pid(1, 2), pid(1, 3))
          , sij_skl  = se(vs, pid(1, 2), pid(3, 4))
          )
      )
  out
}
