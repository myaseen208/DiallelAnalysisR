#' Simulate diallel data
#'
#' @description
#' \code{DiallelSim()} simulates plot data of a diallel in randomized complete blocks, in one or several
#' environments, from Griffing's model with random effects. It serves teaching (data with known effects) and the
#' planning of experiments (see \code{\link{DiallelPower}}).
#'
#' @details
#' The response of the plot of cross \eqn{i \times j}{i x j} in block \eqn{k}{k} of environment \eqn{e}{e} is
#' \deqn{y_{ijke} = \mu + g_i + g_j + s_{ij} + r_{ij} + \eta_e + (gE)_{ie} + (gE)_{je} + (sE)_{ije} + b_{ke} +
#'   \varepsilon_{ijke},}{y_ijke = mu + g_i + g_j + s_ij + r_ij + eta_e + (gE)_ie + (gE)_je + (sE)_ije + b_ke + e_ijke,}
#' with independent normal effects of standard deviations \code{gca}, \code{sca} (\eqn{s_{ij} = s_{ji}}{s_ij =
#' s_ji}), \code{rec} (\eqn{r_{ij} = -r_{ji}}{r_ij = -r_ji}, Methods 1 and 3), \code{gcaEnv}, \code{scaEnv},
#' \code{Block} and \code{Error}; environment effects \eqn{\eta_e}{eta_e} have standard deviation \code{EnvSD}. The
#' gca, environment and block effects are centred to sum to zero and the sca effects to zero row and column sums over
#' the full \eqn{P \times P}{P x P} table (Griffing's constraints of Methods 1 and 2). The true effects are returned as
#' the attribute \code{"truth"}.
#'
#' @param Parents number of parents \eqn{P \geq 3}{P >= 3}.
#' @param Method Griffing's method, \code{1} to \code{4}: which crosses are grown.
#' @param Rep number of replicates (blocks) per environment.
#' @param Env number of environments (default \code{1}; the column \code{Env} is added when it is larger).
#' @param Mean overall mean \eqn{\mu}{mu}.
#' @param gca,sca,rec standard deviations of the gca, sca and reciprocal effects.
#' @param gcaEnv,scaEnv standard deviations of the gca \eqn{\times}{x} environment and sca \eqn{\times}{x}
#'   environment effects (default \code{0}).
#' @param EnvSD standard deviation of the environment effects (default \code{0}).
#' @param Block standard deviation of the block effects (default \code{0}).
#' @param Error standard deviation of the plot errors \eqn{\sigma}{sigma}.
#' @param seed seed of the random numbers, or \code{NULL} (default) to leave the generator as it is.
#' @return A \code{data.frame} with columns \code{Cross1}, \code{Cross2}, \code{Rep}, \code{y} (and \code{Env}),
#'   with the attribute \code{"truth"}: a list with \code{gca} (vector), \code{sca} and \code{rec} (matrices) and
#'   \code{Mean}.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{DiallelPower}}, \code{\link{Griffing}}, \code{\link{GriffingEnv}}
#' @family DiallelAnalysisR planning
#' @examples
#' d <-
#'   DiallelSim(
#'       Parents = 6
#'     , Method  = 1
#'     , Rep     = 3
#'     , Env     = 1
#'     , Mean    = 100
#'     , gca     = 5
#'     , sca     = 3
#'     , rec     = 1
#'     , gcaEnv  = 0
#'     , scaEnv  = 0
#'     , EnvSD   = 0
#'     , Block   = 2
#'     , Error   = 4
#'     , seed    = 123
#'     )
#' head(d)
#' attr(x = d, which = "truth")$gca
#' fit <-
#'   Griffing(
#'       y          = y
#'     , Rep        = Rep
#'     , Cross1     = Cross1
#'     , Cross2     = Cross2
#'     , data       = d
#'     , Method     = 1
#'     , Model      = 1
#'     , Reciprocal = c("combined", "split")[1]
#'     )
#' cbind(true = attr(x = d, which = "truth")$gca, estimated = fit$GCA)
#' @export
DiallelSim <- function(Parents, Method, Rep, Env = 1, Mean = 0, gca, sca, rec = 0, gcaEnv = 0, scaEnv = 0, EnvSD = 0,
                       Block = 0, Error, seed = NULL) {
  fn      <- "DiallelSim"
  Parents <- .da_check_number(Parents, "Parents", fn, min = 3, integer = TRUE)
  Method  <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  Rep     <- .da_check_number(Rep, "Rep", fn, min = 1, integer = TRUE)
  Env     <- .da_check_number(Env, "Env", fn, min = 1, integer = TRUE)
  Mean    <- .da_check_number(Mean, "Mean", fn)
  for (nm in c("gca", "sca", "rec", "gcaEnv", "scaEnv", "EnvSD", "Block", "Error")) {
    .da_check_number(get(nm), nm, fn, min = 0)
  }
  if (!is.null(seed)) set.seed(seed)
  P   <- Parents
  ctr <- function(v) v - mean(v)
  g   <- ctr(stats::rnorm(P, 0, gca))
  S   <- .da_sym_effects(P, sca)
  Rm  <- if (Method %in% c(1L, 3L)) .da_anti_effects(P, rec) else matrix(0, P, P)
  cells <- .da_cells(Method, P)
  i <- cells[, 1L]
  j <- cells[, 2L]
  eta <- ctr(stats::rnorm(Env, 0, EnvSD))
  out <- vector("list", Env)
  for (e in seq_len(Env)) {
    gE <- ctr(stats::rnorm(P, 0, gcaEnv))
    SE <- .da_sym_effects(P, scaEnv)
    mu <- Mean + g[i] + g[j] + S[cbind(i, j)] + Rm[cbind(i, j)] + eta[e] + gE[i] + gE[j] + SE[cbind(i, j)]
    b  <- ctr(stats::rnorm(Rep, 0, Block))
    k  <- rep(seq_len(Rep), each = length(i))
    d  <- data.frame(Cross1 = factor(rep(i, Rep), levels = seq_len(P)), Cross2 = factor(rep(j, Rep), levels = seq_len(P)),
                     Rep = factor(k), y = rep(mu, Rep) + b[k] + stats::rnorm(length(k), 0, Error))
    if (Env > 1L) d <- cbind(Env = factor(e, levels = seq_len(Env)), d)
    out[[e]] <- d
  }
  out <- do.call(rbind, out)
  rownames(out) <- NULL
  attr(out, "truth") <- list(Mean = Mean, gca = stats::setNames(g, seq_len(P)), sca = S, rec = Rm)
  out
}

# symmetric effects with zero row sums over the off-diagonal cells (selfs included on the diagonal)
.da_sym_effects <- function(P, sd) {
  if (sd == 0) return(matrix(0, P, P))
  A <- matrix(stats::rnorm(P * P, 0, sd), P, P)
  A[lower.tri(A)] <- t(A)[lower.tri(A)]
  A - outer(rowMeans(A), colMeans(A), `+`) + mean(A)
}

.da_anti_effects <- function(P, sd) {
  if (sd == 0) return(matrix(0, P, P))
  A <- matrix(stats::rnorm(P * P, 0, sd), P, P)
  A[lower.tri(A)] <- -t(A)[lower.tri(A)]
  diag(A) <- 0
  A
}

#' Power of the combining-ability tests for planning a diallel
#'
#' @description
#' \code{DiallelPower()} estimates by simulation the power of Griffing's \eqn{F}{F} tests of gca, sca and reciprocal
#' effects for numbers of replicates, so that the size of a diallel experiment can be planned.
#'
#' @details
#' For every number of replicates in \code{Rep}, \code{nsim} data sets are drawn with \code{\link{DiallelSim}} and
#' analysed with Griffing's closed forms; the power is the share of data sets whose test is significant at level
#' \code{alpha}, with its Monte Carlo standard error \eqn{\sqrt{\hat{p}(1 - \hat{p})/n_{sim}}}{sqrt(p (1 - p)/nsim)}.
#' The tests are those of \code{Model}: in Model 1 every line against the error, in Model 2 gca against sca. The
#' block effects do not change the tests and are left out.
#'
#' @inheritParams DiallelSim
#' @param Rep vector of numbers of replicates to compare.
#' @param Model \code{1} (fixed effects) or \code{2} (random effects): which tests.
#' @param nsim number of simulated data sets for each number of replicates (default \code{500}).
#' @param alpha level of the tests (default \code{0.05}).
#' @return A \code{data.table} of class \code{c("da_power", ...)}: columns \code{Rep}, \code{Source} (gca, sca,
#'   reciprocals), \code{Power} and \code{SE}; \code{plot()} draws the power curves.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{DiallelSim}}, \code{\link{Griffing}}
#' @family DiallelAnalysisR planning
#' @examples
#' pw <-
#'   DiallelPower(
#'       Parents = 6
#'     , Method  = 2
#'     , Rep     = 2:4
#'     , Model   = 1
#'     , gca     = 1
#'     , sca     = 1.5
#'     , rec     = 0
#'     , Error   = 4
#'     , nsim    = 100
#'     , alpha   = 0.05
#'     , seed    = 1
#'     )
#' pw
#' plot(pw)
#' @export
DiallelPower <- function(Parents, Method, Rep, Model = 1, gca, sca, rec = 0, Error, nsim = 500, alpha = 0.05,
                         seed = NULL) {
  fn    <- "DiallelPower"
  Rep   <- .da_check_number(Rep, "Rep", fn, min = 2, integer = TRUE, scalar = FALSE)
  Model <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  nsim  <- .da_check_number(nsim, "nsim", fn, min = 10, integer = TRUE)
  alpha <- .da_check_number(alpha, "alpha", fn, min = 1e-6, max = 0.5)
  Method <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  if (!is.null(seed)) set.seed(seed)
  res <- lapply(Rep, function(B) {
    hits <- replicate(nsim, {
      d  <- DiallelSim(Parents = Parents, Method = Method, Rep = B, Mean = 0, gca = gca, sca = sca, rec = rec,
                       Error = Error)
      cd <- .da_cell_data(y = d$y, p1 = d$Cross1, p2 = d$Cross2, rep = d$Rep, method = Method, fn = fn)
      a  <- .da_griffing_core(cd, Method, Model)$ANOVA
      a[["Pr(>F)"]][rownames(a) != "Error"] < alpha
    })
    hits <- matrix(hits, ncol = nsim)
    p <- rowMeans(hits)
    data.table::data.table(Rep = B, Source = c("gca", "sca", "reciprocals")[seq_along(p)], Power = p,
                           SE = sqrt(p * (1 - p) / nsim))
  })
  out <- data.table::rbindlist(res)
  data.table::setattr(out, "class", c("da_power", class(out)))
  data.table::setattr(out, "settings", list(Parents = Parents, Method = Method, Model = Model, gca = gca, sca = sca,
                                            rec = rec, Error = Error, nsim = nsim, alpha = alpha))
  out
}

#' @rdname DiallelPower
#' @param x a \code{da_power} object.
#' @param ... unused.
#' @export
plot.da_power <- function(x, ...) {
  d <- data.table::as.data.table(unclass(x))
  ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Rep, y = Power, colour = Source)) +
    ggplot2::geom_hline(yintercept = 0.8, linetype = "dashed", linewidth = 0.3) +
    ggplot2::geom_line() +
    ggplot2::geom_point(size = 2) +
    ggplot2::geom_errorbar(mapping = ggplot2::aes(ymin = pmax(0, Power - 2 * SE), ymax = pmin(1, Power + 2 * SE)),
                           width = 0.1) +
    ggplot2::scale_colour_manual(values = .da_palette) +
    ggplot2::scale_x_continuous(breaks = unique(d$Rep)) +
    ggplot2::scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
    ggplot2::labs(x = "Replicates", y = "Power", colour = NULL,
                  title = "Power of the combining-ability tests (dashed: 0.8)") +
    da_theme()
}

utils::globalVariables(c("Power", "SE", "Rep"))
