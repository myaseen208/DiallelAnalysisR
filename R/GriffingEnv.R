#' Griffing's diallel analysis over several environments
#'
#' @description
#' \code{GriffingEnv()} combines Griffing's analysis of the same diallel grown in several environments (locations,
#' years or seasons), each a randomized complete block experiment: the pooled analysis of variance with the
#' interactions gca \eqn{\times}{x} environment, sca \eqn{\times}{x} environment and, in Methods 1 and 3,
#' reciprocal \eqn{\times}{x} environment, the effects from the means over environments, the gca effects in every
#' environment and, in the random model, the variance components.
#'
#' @details
#' Let \eqn{\mathbf{Y}_e}{Y_e} be the table of cross means in environment \eqn{e = 1, \ldots, E}{e = 1, ..., E},
#' \eqn{\bar{\mathbf{Y}}}{Ybar} their mean and \eqn{SS_k(\cdot)}{SS_k(.)} the sum of squares of line \eqn{k}{k} (gca,
#' sca, reciprocals) of Griffing's analysis of a table. Because each line is a projection of the table,
#' \deqn{\sum_{e} SS_k(\mathbf{Y}_e) = E \cdot SS_k(\bar{\mathbf{Y}}) + \sum_e SS_k(\mathbf{Y}_e - \bar{\mathbf{Y}}),}{sum_e
#'   SS_k(Y_e) = E SS_k(Ybar) + sum_e SS_k(Y_e - Ybar),}
#' the first term being line \eqn{k}{k} and the second its interaction with environments, on \eqn{f_k}{f_k} and
#' \eqn{(E - 1)f_k}{(E - 1) f_k} degrees of freedom. The environments line is \eqn{c\sum_e (\bar{y}_e -
#' \bar{y})^2}{c sum_e (ybar_e - ybar)^2} with \eqn{c}{c} cells per table. Everything is on the scale of cross means;
#' the error is the pooled error of the block analyses divided by \eqn{B}{B} (harmonic mean of the replicates over
#' environments), on the pooled degrees of freedom, and \code{Rep(Env)} is the pooled replicate line on the same
#' scale.
#'
#' With \code{Model = 1} every line is tested against the error. With \code{Model = 2} (random genotypes and
#' environments) environments are tested against replicates within environments, gca, sca and reciprocals against
#' their interaction with environments, and the interactions against the error; with \eqn{c_{\cdot\cdot}}{c..} the
#' coefficients of the expected mean squares of the single-environment analysis,
#' \deqn{\hat{\sigma}^2_{sE} = \frac{MS_{sE} - MS_E}{c_{ss}}, \quad \hat{\sigma}^2_s = \frac{MS_s - MS_{sE}}{E c_{ss}}, \quad
#'   \hat{\sigma}^2_{gE} = \frac{MS_{gE} - MS_E - c_{gs}\hat{\sigma}^2_{sE}}{c_{gg}}, \quad \hat{\sigma}^2_g = \frac{MS_g -
#'   MS_{gE} - E c_{gs}\hat{\sigma}^2_s}{E c_{gg}}.}{sigma^2_sE = (MS_sE - MS_E)/c_ss; sigma^2_s = (MS_s - MS_sE)/(E
#'   c_ss); sigma^2_gE = (MS_gE - MS_E - c_gs sigma^2_sE)/c_gg; sigma^2_g = (MS_g - MS_gE - E c_gs sigma^2_s)/(E c_gg).}
#' The standard errors of the effects over environments are those of \code{\link{Griffing}} with the error variance
#' \eqn{MS_E/E}{MS_E/E}.
#'
#' @inheritParams Griffing
#' @param Env environment of each plot: a column of \code{data} or a vector, as for \code{y}. Replicate labels are
#'   taken within environments.
#' @return An object of class \code{c("da_griffingenv", "da_result", "list")}:
#' \describe{
#'   \item{\code{Means}}{table of cross means over environments.}
#'   \item{\code{ANOVA}}{pooled analysis of variance (class \code{anova}).}
#'   \item{\code{GCA}}{gca effects over environments; \code{GCA.Env}: matrix of gca effects, parents by
#'     environments.}
#'   \item{\code{SCA}}{sca effects over environments; \code{Reciprocal} (Methods 1 and 3) reciprocal effects.}
#'   \item{\code{StdErr}}{standard errors of the effects over environments, as in \code{\link{Griffing}}.}
#'   \item{\code{Genetic.Components}}{(Model 2) variance components.}
#'   \item{\code{ByEnv}}{list of the single-environment \code{\link{Griffing}} analyses.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (\code{which = c("gca", "gcaenv", "sca", "residuals",
#'   "qq")}; \code{"gcaenv"} draws the gca effect of every parent in every environment), \code{data.table::as.data.table(x,
#'   component =)}, \code{\link{da_export}}.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#'
#' Zhang, Y. and Kang, M. S. (1997). DIALLEL-SAS: a SAS program for Griffing's diallel analyses. \emph{Agronomy
#' Journal}, \strong{89}(2), 176--182. \doi{10.2134/agronj1997.00021962008900020005x}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{DiallelSim}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## A Method 2 diallel of six parents in three environments
#' #-------------------------------------------------------------
#' d <-
#'   DiallelSim(
#'       Parents = 6
#'     , Method  = 2
#'     , Rep     = 3
#'     , Env     = 3
#'     , Mean    = 50
#'     , gca     = 4
#'     , sca     = 2
#'     , rec     = 0
#'     , gcaEnv  = 1.5
#'     , scaEnv  = 1
#'     , EnvSD   = 0
#'     , Block   = 0
#'     , Error   = 3
#'     , seed    = 1
#'     )
#' fe <-
#'   GriffingEnv(
#'       y      = y
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , Env    = Env
#'     , data   = d
#'     , Method = 2
#'     , Model  = 2
#'     )
#' fe
#' fe$GCA.Env
#' plot(x = fe, which = c("gca", "gcaenv", "sca", "residuals", "qq")[2])
#' @export
GriffingEnv <- function(y, Rep, Cross1, Cross2, Env, data, Method, Model) {
  fn     <- "GriffingEnv"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1 <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2 <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  Env    <- .da_column(data, substitute(Env), "Env", fn, parent.frame())
  Method <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  Model  <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  env    <- factor(Env$value)
  if (nlevels(env) < 2L) .da_stop(fn, "at least two environments are needed.")
  cds <- lapply(levels(env), function(e) {
    k <- which(env == e)
    .da_cell_data(y = y$value[k], p1 = Cross1$value[k], p2 = Cross2$value[k], rep = Rep$value[k], method = Method,
                  fn = paste0(fn, "(Env = ", e, ")"))
  })
  names(cds) <- levels(env)
  labs <- lapply(cds, function(z) rownames(z$M))
  if (length(unique(labs)) != 1L) .da_stop(fn, "every environment must have the same parents.")
  if (nrow(cds[[1L]]$M) < 4L) .da_stop(fn, "at least 4 parents are needed.")
  out <- .da_griffingenv_core(cds, Method, Model)
  out$ByEnv <- lapply(cds, function(cd) {
    r <- .da_griffing_core(cd, Method, 1L)
    attr(r, "plots") <- cd$plots
    .da_result(r, cls = "griffing", label = "Griffing's analysis in one environment",
               meta = list(method = Method, model = 1L, replicates = cd$R))
  })
  pl <- data.table::rbindlist(lapply(names(cds), function(e) cbind(Env = e, cds[[e]]$plots)))
  attr(out, "plots") <- pl
  .da_result(
      out
    , cls   = "griffingenv"
    , label = sprintf("Griffing's Method %d, Model %d over %d environments; %d parents", Method, Model, length(cds),
                      nrow(out$Means))
    , call  = match.call()
    , meta  = list(method = Method, model = Model, response = y$name, environments = levels(env))
    )
}

.da_griffingenv_core <- function(cds, method, model) {
  E    <- length(cds)
  Ms   <- lapply(cds, `[[`, "M")
  Mbar <- Reduce(`+`, Ms) / E
  P    <- nrow(Mbar)
  R    <- 1 / mean(1 / vapply(cds, `[[`, numeric(1L), "R"))
  decs <- lapply(Ms, .da_griffing_closed, method = method)
  dbar <- .da_griffing_closed(Mbar, method)
  lines <- names(dbar$ss)
  ss_main <- E * dbar$ss
  ss_int  <- Reduce(`+`, lapply(decs, `[[`, "ss")) - ss_main
  names(ss_int) <- paste0(lines, ":Env")
  cells <- !is.na(Mbar)
  em    <- vapply(Ms, function(m) mean(m[cells]), numeric(1L))
  ss_env <- sum(cells) * sum((em - mean(em))^2)
  ss_rep <- sum(vapply(cds, function(z) z$anova["Rep", "Sum Sq"], numeric(1L))) / R
  df_rep <- sum(vapply(cds, function(z) z$anova["Rep", "Df"], numeric(1L)))
  ss_e   <- sum(vapply(cds, `[[`, numeric(1L), "ss_e")) / R
  df_e   <- sum(vapply(cds, `[[`, numeric(1L), "df_e"))
  ss <- c(Env = ss_env, `Rep(Env)` = ss_rep, ss_main, ss_int, Error = ss_e)
  df <- c(Env = E - 1, `Rep(Env)` = df_rep, dbar$df, (E - 1) * dbar$df, Error = df_e)
  names(df) <- names(ss)
  ag <- stats::setNames(rep("Error", length(ss)), names(ss))
  ag[["Error"]] <- NA
  if (model == 2L) {
    ag[["Env"]] <- "Rep(Env)"
    ag[lines] <- paste0(lines, ":Env")
  }
  ANOVA <- .da_aov(ss, df, ag)
  ANOVA[["F value"]][is.na(ag)] <- NA
  ANOVA[["Pr(>F)"]][is.na(ag)] <- NA
  ms    <- stats::setNames(ANOVA$`Mean Sq`, rownames(ANOVA))
  var_m <- ms[["Error"]]
  out <- list(Means = Mbar, ANOVA = ANOVA)
  GE <- vapply(decs, `[[`, numeric(P), "g")
  rownames(GE) <- rownames(Mbar)
  out$GCA <- stats::setNames(dbar$g, rownames(Mbar))
  out$GCA.Env <- GE
  S <- dbar$S
  dimnames(S) <- dimnames(Mbar)
  out$SCA <- S
  if (!is.null(dbar$R)) {
    Rm <- dbar$R
    dimnames(Rm) <- dimnames(Mbar)
    out$Reciprocal <- Rm
  }
  se <- sqrt(dbar$vse * var_m / E)
  if (method == 4L) se <- c(se[1:2], not_defined = NA_real_, se[3:5])
  out$StdErr <- se
  if (model == 2L) {
    em_ <- dbar$ems
    css <- em_["sca", "sca"]
    cgs <- em_["gca", "sca"]
    cgg <- em_["gca", "gca"]
    v_sE <- (ms[["sca:Env"]] - var_m) / css
    v_s  <- (ms[["sca"]] - ms[["sca:Env"]]) / (E * css)
    v_gE <- (ms[["gca:Env"]] - var_m - cgs * v_sE) / cgg
    v_g  <- (ms[["gca"]] - ms[["gca:Env"]] - E * cgs * v_s) / (E * cgg)
    comp <- c(gca = v_g, sca = v_s, `gca:Env` = v_gE, `sca:Env` = v_sE)
    if (!is.null(dbar$R)) {
      crr <- em_["reciprocals", "reciprocals"]
      comp <- c(comp, Reciprocal = (ms[["reciprocals"]] - ms[["reciprocals:Env"]]) / (E * crr),
                `Reciprocal:Env` = (ms[["reciprocals:Env"]] - var_m) / crr)
    }
    comp <- c(comp, Error = var_m, `gca/sca` = v_g / v_s)
    out$Genetic.Components <- data.frame(Components = unname(comp), row.names = names(comp))
  }
  out
}

.da_plot_griffingenv <- function(x, which = c("gca", "gcaenv", "sca", "residuals", "qq"), ...) {
  which <- match.arg(which)
  if (which %in% c("residuals", "qq")) return(.da_plot_resid(x, which))
  if (which == "gca") {
    return(.da_effect_bars(x$GCA, se = x$StdErr[["gi"]], title = "gca effects over environments", ylab = "gca effect"))
  }
  if (which == "sca") {
    S <- x$SCA
    S[lower.tri(S)] <- NA
    return(.da_effect_tiles(S, title = "sca effects over environments", xlab = "male parent", ylab = "female parent"))
  }
  G <- x$GCA.Env
  d <- data.table::data.table(Parent = factor(rownames(G)[row(G)], levels = rownames(G)),
                              Env = factor(colnames(G)[col(G)], levels = colnames(G)), g = as.vector(G))
  ggplot2::ggplot(data = d, mapping = ggplot2::aes(x = Env, y = g, group = Parent, colour = Parent)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_line() +
    ggplot2::geom_point(size = 1.8) +
    ggplot2::scale_y_continuous(breaks = scales::pretty_breaks(n = 8)) +
    ggplot2::labs(x = "Environment", y = "gca effect", colour = "Parent", title = "gca effects in each environment") +
    da_theme(legend_position = "right")
}

.da_print_griffingenv <- function(x, digits = 4L, ...) {
  cat(attr(x, "label"), "\n\nPooled analysis of variance (cross means)\n")
  print(x$ANOVA, digits = digits)
  cat("\ngca effects over environments\n")
  print(round(x$GCA, digits))
  if (!is.null(x$Genetic.Components)) {
    cat("\nGenetic components\n")
    print(x$Genetic.Components, digits = digits)
  }
  invisible(x)
}

.da_tables_griffingenv <- function(x) {
  out <- list(`Analysis of variance` = .da_df(x$ANOVA),
              `gca effects` = data.frame(Parent = names(x$GCA), gca = unname(x$GCA)),
              `gca effects by environment` = .da_df(x$GCA.Env, "Parent"),
              `sca effects` = .da_df(x$SCA, "Parent"), `Standard errors` = .da_df(x$StdErr, "Effect"))
  if (!is.null(x$Genetic.Components)) out$Components <- .da_df(x$Genetic.Components, "Component")
  out
}

utils::globalVariables("Env")
