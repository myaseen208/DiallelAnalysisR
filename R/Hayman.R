#' Diallel analysis by Hayman's approach
#'
#' @description
#' \code{Hayman()} performs Hayman's analysis of a complete diallel (parents, \eqn{F_1}{F1} and reciprocals: Griffing's
#' Method 1) from the plot data of a randomized complete block experiment: Hayman's analysis of variance (additive,
#' non-additive with its parts \eqn{b_1}{b1}, \eqn{b_2}{b2}, \eqn{b_3}{b3}, maternal and reciprocal effects), the
#' array variances and covariances \eqn{V_r}{Vr} and \eqn{W_r}{Wr} with the \eqn{W_r}{Wr}-\eqn{V_r}{Vr} regression,
#' the components of variation \eqn{D}{D}, \eqn{H_1}{H1}, \eqn{H_2}{H2}, \eqn{F}{F}, \eqn{h^2}{h2} and \eqn{E}{E}
#' with their standard errors, the derived genetic ratios and the tests of the adequacy of the additive-dominance
#' model.
#'
#' @details
#' \strong{Data.} \eqn{P}{P} parents, all \eqn{P^2}{P^2} crosses, \eqn{B}{B} replicates. \eqn{\mathbf{Y}}{Y} is the
#' \eqn{P \times P}{P x P} matrix of cell means and \eqn{\mathbf{T}}{T} the matrix of cell totals over replicates.
#'
#' \strong{Analysis of variance} (Hayman 1954b), with \eqn{T_{i\cdot}}{T_i.}, \eqn{T_{\cdot i}}{T_.i},
#' \eqn{T_{\cdot\cdot}}{T_..} the totals of \eqn{\mathbf{T}}{T} and all sums of squares divided by \eqn{B}{B} to the
#' plot scale:
#' \deqn{a = \frac{1}{B}\left[\frac{1}{2P}\sum_i (T_{i\cdot} + T_{\cdot i})^2 - \frac{2}{P^2}T_{\cdot\cdot}^2\right],
#'   \quad b = \frac{1}{B}\left[\frac{1}{4}\sum_{i,j}(T_{ij} + T_{ji})^2 - \frac{1}{2P}\sum_i (T_{i\cdot} +
#'   T_{\cdot i})^2 + \frac{1}{P^2}T_{\cdot\cdot}^2\right],}{a = [sum_i (T_i. + T_.i)^2/(2P) - 2 T..^2/P^2]/B;
#'   b = [sum_ij (T_ij + T_ji)^2/4 - sum_i (T_i. + T_.i)^2/(2P) + T..^2/P^2]/B,}
#' \deqn{b_1 = \frac{(T_{\cdot\cdot} - P\sum_i T_{ii})^2}{P^2(P-1)B}, \quad b_2 = \frac{1}{B}\left[\frac{\sum_i
#'   (T_{i\cdot} + T_{\cdot i} - PT_{ii})^2}{P(P-2)} - \frac{(2T_{\cdot\cdot} - P\sum_i T_{ii})^2}{P^2(P-2)}\right],
#'   \quad b_3 = b - b_1 - b_2,}{b1 = (T.. - P sum_i T_ii)^2/(P^2(P - 1)B); b2 = [sum_i (T_i. + T_.i - P T_ii)^2/(P(P -
#'   2)) - (2 T.. - P sum_i T_ii)^2/(P^2(P - 2))]/B; b3 = b - b1 - b2,}
#' \deqn{c = \frac{1}{2PB}\sum_i (T_{\cdot i} - T_{i\cdot})^2, \quad d = \frac{1}{B}\left[\frac{1}{4}\sum_{i,j}
#'   (T_{ij} - T_{ji})^2 - \frac{1}{2P}\sum_i (T_{\cdot i} - T_{i\cdot})^2\right].}{c = sum_i (T_.i - T_i.)^2/(2PB);
#'   d = [sum_ij (T_ij - T_ji)^2/4 - sum_i (T_.i - T_i.)^2/(2P)]/B.}
#' \eqn{b_1}{b1} (1 df) tests the mean deviation of the \eqn{F_1}{F1} from the parents (directional dominance),
#' \eqn{b_2}{b2} (\eqn{P-1}{P-1} df) whether that deviation differs among parents, \eqn{b_3}{b3}
#' (\eqn{P(P-3)/2}{P(P-3)/2} df) the remaining dominance (sca), \eqn{c}{c} (\eqn{P-1}{P-1} df) maternal effects and
#' \eqn{d}{d} (\eqn{(P-1)(P-2)/2}{(P-1)(P-2)/2} df) the remaining reciprocal differences; every line is tested against
#' the error of the block analysis.
#'
#' \strong{Arrays.} The reciprocal crosses are averaged: \eqn{\bar{\mathbf{Y}} = (\mathbf{Y} + \mathbf{Y}^\top)/2}{
#' Ybar = (Y + Y')/2}. Array \eqn{r}{r} is column \eqn{r}{r} of \eqn{\bar{\mathbf{Y}}}{Ybar}; \eqn{V_r}{Vr} is its
#' variance and \eqn{W_r}{Wr} its covariance with the parents (the diagonal of \eqn{\bar{\mathbf{Y}}}{Ybar}).
#' \eqn{V_{0L0}}{V0L0} is the variance of the parents, \eqn{V_{1L1}}{V1L1} the mean of the \eqn{V_r}{Vr},
#' \eqn{V_{0L1}}{V0L1} the variance of the array means and \eqn{W_{0L01}}{W0L01} the mean of the \eqn{W_r}{Wr}. The
#' regression \eqn{W_r = a + bV_r}{Wr = a + b Vr} is fitted by least squares; under the additive-dominance model
#' \eqn{b = 1}{b = 1}. The uniformity test (Hayman 1954a)
#' \deqn{t^2 = \frac{P-2}{4}\,\frac{\left[\mathrm{Var}(V_r) - \mathrm{Var}(W_r)\right]^2}{\mathrm{Var}(V_r)
#'   \mathrm{Var}(W_r) - \mathrm{Cov}^2(V_r, W_r)}}{t^2 = (P - 2)/4 [Var(Vr) - Var(Wr)]^2/[Var(Vr) Var(Wr) -
#'   Cov(Vr, Wr)^2]}
#' is compared with the \eqn{F}{F} distribution on 1 and \eqn{P-2}{P-2} degrees of freedom.
#'
#' \strong{Components of variation} (Hayman 1954a; Mather and Jinks 1982), with \eqn{E}{E} the error variance of a
#' cell mean (block and error sums of squares pooled, divided by \eqn{B}{B}):
#' \deqn{D = V_{0L0} - E, \quad F = 2V_{0L0} - 4W_{0L01} - \frac{2(P-2)}{P}E, \quad H_1 = V_{0L0} - 4W_{0L01} +
#'   4V_{1L1} - \frac{3P-2}{P}E,}{D = V0L0 - E; F = 2 V0L0 - 4 W0L01 - 2(P - 2)E/P; H1 = V0L0 - 4 W0L01 + 4 V1L1 -
#'   (3P - 2)E/P;}
#' \deqn{H_2 = 4V_{1L1} - 4V_{0L1} - 2E, \quad h^2 = 4(\bar{Y}_{L1} - \bar{Y}_{L0})^2 - \frac{4(P-1)}{P^2}E,}{H2 =
#'   4 V1L1 - 4 V0L1 - 2E; h2 = 4 (ML1 - ML0)^2 - 4(P - 1)E/P^2,}
#' where \eqn{\bar{Y}_{L1}}{ML1} is the mean of all cells and \eqn{\bar{Y}_{L0}}{ML0} the mean of the parents. Their
#' standard errors use \eqn{s^2 = \mathrm{Var}(W_r - V_r)/2}{s^2 = Var(Wr - Vr)/2}: \eqn{\mathrm{Var}(D) =
#' (P^5 + P^4)s^2/P^5}{Var(D) = (P^5 + P^4) s^2/P^5}, \eqn{\mathrm{Var}(H_1) = (P^5 + 41P^4 - 12P^3 + 4P^2)s^2/P^5}{
#' Var(H1) = (P^5 + 41P^4 - 12P^3 + 4P^2) s^2/P^5}, \eqn{\mathrm{Var}(H_2) = 36P^4s^2/P^5}{Var(H2) = 36P^4 s^2/P^5},
#' \eqn{\mathrm{Var}(F) = (4P^5 + 20P^4 - 16P^3 + 16P^2)s^2/P^5}{Var(F) = (4P^5 + 20P^4 - 16P^3 + 16P^2) s^2/P^5},
#' \eqn{\mathrm{Var}(h^2) = (16P^4 + 16P^3 - 32P + 16)s^2/P^5}{Var(h2) = (16P^4 + 16P^3 - 32P + 16) s^2/P^5},
#' \eqn{\mathrm{Var}(E) = P^4s^2/P^5}{Var(E) = P^4 s^2/P^5}. Derived ratios: mean degree of dominance
#' \eqn{\sqrt{H_1/D}}{sqrt(H1/D)}, proportion of genes with positive and negative effects \eqn{H_2/(4H_1)}{H2/(4H1)},
#' ratio of dominant to recessive genes \eqn{(\sqrt{4DH_1} + F)/(\sqrt{4DH_1} - F)}{(sqrt(4 D H1) + F)/(sqrt(4 D H1) -
#' F)}, the correlation of \eqn{W_r + V_r}{Wr + Vr} with the parental values \eqn{Y_{rr}}{Yrr}, the number of gene
#' groups showing dominance \eqn{h^2/H_2}{h2/H2} and the narrow-sense heritability
#' \eqn{(D + H_1 - H_2 - F)/(D + H_1 - H_2/2 - F + 2E)}{(D + H1 - H2 - F)/(D + H1 - H2/2 - F + 2E)}.
#' \eqn{F_r = 2(V_{0L0} - W_{0L01} + V_{1L1} - W_r - V_r) - 2(P-2)E/P}{Fr = 2(V0L0 - W0L01 + V1L1 - Wr - Vr) - 2(P -
#' 2)E/P} for each array.
#'
#' \strong{Changes from version 0.6.0.} The column arguments are used (version 0.6.0 read the columns
#' \code{Cross1} and \code{Cross2} by name); \eqn{H_2}{H2} subtracts \eqn{4V_{0L1}}{4 V0L1} (version 0.6.0 added
#' it); \eqn{W_r}{Wr} and \eqn{V_r}{Vr} both come from the reciprocal-averaged table (version 0.6.0 took
#' \eqn{V_r}{Vr} from the upper triangle and \eqn{W_r}{Wr} from the unaveraged rows); the derived ratios are named;
#' the lines \eqn{b}{b}, \eqn{b_3}{b3} and \eqn{d}{d} of the analysis of variance divide by 4 where version 0.6.0
#' divided by the number of replicates (the two agree only with 4 replicates, as in \code{HaymanData}); the tests of
#' the model are returned (\code{Tests}).
#'
#' @inheritParams Griffing
#' @return An object of class \code{c("da_hayman", "da_result", "list")} with the components of earlier versions
#'   followed by a new one:
#' \describe{
#'   \item{\code{Means}}{\eqn{P \times P}{P x P} matrix of cell means (female parents in rows).}
#'   \item{\code{ANOVA}}{Hayman's analysis of variance (class \code{anova}): \code{Total}, \code{Rep},
#'     \code{Treatment}, additive (\code{a}), non-additive (\code{b}) with \code{b1}, \code{b2}, \code{b3},
#'     maternal (\code{c}), reciprocal (\code{d}), \code{Error}.}
#'   \item{\code{VOLO}}{\eqn{V_{0L0}}{V0L0}, the variance of the parents.}
#'   \item{\code{In.Value}}{\eqn{\sqrt{V_{1L1}V_{0L0}}}{sqrt(V1L1 V0L0)}, used to draw the limiting parabola.}
#'   \item{\code{a}, \code{b}}{intercept and slope of the regression of \eqn{W_r}{Wr} on \eqn{V_r}{Vr}.}
#'   \item{\code{Wr.Vr.Table}}{one row per array: \code{Wr}, \code{Vr}, \code{Wr.Minus.Vr}, \code{Wr.Plus.Vr},
#'     \code{Yr} (parental value), \code{Wri} (limiting parabola \eqn{\sqrt{V_rV_{0L0}}}{sqrt(Vr V0L0)}),
#'     \code{Wrei} (fitted regression), \code{Wreip} (line of unit slope through the means).}
#'   \item{\code{Components.of.Variation}}{\code{Estimate}, \code{StdErr}, \code{t.value} of \eqn{E}{E},
#'     \eqn{D}{D}, \eqn{F}{F}, \eqn{H_1}{H1}, \eqn{H_2}{H2}, \eqn{h^2}{h2}.}
#'   \item{\code{Other.Parameters}}{the derived ratios (named rows).}
#'   \item{\code{Fr}}{\eqn{F_r}{Fr} of each array.}
#'   \item{\code{Tests}}{(new) uniformity test \eqn{t^2}{t2}, and \eqn{t}{t} tests of \eqn{b = 0}{b = 0} and
#'     \eqn{b = 1}{b = 1}: statistic, degrees of freedom, p-value.}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (the \eqn{W_r}{Wr}-\eqn{V_r}{Vr} graph: limiting parabola,
#'   regression line, line of unit slope, parents labelled; \code{which = c("WrVr", "residuals", "qq")}),
#'   \code{anova()}, \code{coef()}, \code{fitted()}, \code{residuals()}, \code{data.table::as.data.table(x,
#'   component =)}; see \code{\link{diallel-methods}}.
#'
#' @references
#' Hayman, B. I. (1954a). The theory and analysis of diallel crosses. \emph{Genetics}, \strong{39}(6), 789--809.
#' \doi{10.1093/genetics/39.6.789}
#'
#' Hayman, B. I. (1954b). The analysis of variance of diallel tables. \emph{Biometrics}, \strong{10}(2), 235--244.
#' \doi{10.2307/3001877}
#'
#' Hayman, B. I. (1957). Interaction, heterosis and diallel crosses. \emph{Genetics}, \strong{42}(3), 336--355.
#' \doi{10.1093/genetics/42.3.336}
#'
#' Jinks, J. L. and Hayman, B. I. (1953). The analysis of diallel crosses. \emph{Maize Genetics Cooperation
#' Newsletter}, \strong{27}, 48--54.
#'
#' Mather, K. and Jinks, J. L. (1982). \emph{Biometrical Genetics}, 3rd edition. Chapman and Hall, London.
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com}), Kent M. Eskridge (\email{keskridge1@@unl.edu})
#' @seealso \code{\link{Griffing}}, \code{\link{HaymanData}}, \code{\link{da-methods}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Hayman's analysis of a complete diallel
#' #-------------------------------------------------------------
#' Hayman1Data <-
#'   Hayman(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = HaymanData
#'     )
#' Hayman1Data
#' Hayman1Data$ANOVA
#' Hayman1Data$Components.of.Variation
#' Hayman1Data$Other.Parameters
#' Hayman1Data$Tests
#'
#' #-------------------------------------------------------------
#' ## The Wr-Vr graph
#' #-------------------------------------------------------------
#' plot(Hayman1Data)
#' @export
Hayman <- function(y, Rep, Cross1, Cross2, data) {
  fn     <- "Hayman"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1 <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2 <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  cd <-
    .da_cell_data(
        y      = y$value
      , p1     = Cross1$value
      , p2     = Cross2$value
      , rep    = Rep$value
      , method = 1L
      , fn     = fn
      )
  if (!cd$balanced) .da_stop(fn, "every cross needs one plot in every replicate.")
  if (nrow(cd$M) < 4L) .da_stop(fn, "at least 4 parents are needed.")
  out <- .da_hayman_core(cd)
  attr(out, "plots") <- cd$plots
  .da_result(
      out
    , cls   = "hayman"
    , label = sprintf("Hayman's analysis; %d parents, %d replicates", nrow(cd$M), cd$R)
    , call  = match.call()
    , meta  = list(response = y$name, replicates = cd$R)
    )
}

.da_hayman_core <- function(cd) {
  M  <- cd$M
  n  <- nrow(M)
  r  <- cd$R
  Tt <- M * r                                   # cell totals over replicates
  rs <- rowSums(Tt)
  cs <- colSums(Tt)
  G  <- sum(Tt)
  dT <- diag(Tt)
  A  <- cd$anova
  #-----------------------------------------------------------------------------------------------------------------
  # Hayman's (1954b) analysis of variance (plot scale)
  #-----------------------------------------------------------------------------------------------------------------
  SS.a  <- (sum((cs + rs)^2) / (2 * n) - 2 * G^2 / n^2) / r
  SS.b  <- (sum((Tt + t(Tt))^2) / 4 - sum((cs + rs)^2) / (2 * n) + G^2 / n^2) / r
  SS.b1 <- ((G - n * sum(dT))^2 / (n^2 * (n - 1))) / r
  SS.b2 <- (sum((cs + rs - n * dT)^2) / (n * (n - 2)) - (2 * G - n * sum(dT))^2 / (n^2 * (n - 2))) / r
  SS.b3 <- (sum((Tt + t(Tt))^2) / 4 - sum(dT^2) - sum((cs + rs - 2 * dT)^2) / (2 * (n - 2)) +
              (G - sum(dT))^2 / ((n - 1) * (n - 2))) / r
  SS.c  <- (sum((cs - rs)^2) / (2 * n)) / r
  SS.d  <- (sum((Tt - t(Tt))^2) / 4 - sum((cs - rs)^2) / (2 * n)) / r
  df <-
    c(
        sum(A$Df)
      , A["Rep", "Df"]
      , A["Crosses", "Df"]
      , n - 1
      , n * (n - 1) / 2
      , 1
      , n - 1
      , n * (n - 3) / 2
      , n - 1
      , (n - 1) * (n - 2) / 2
      , A["Residuals", "Df"]
      )
  SS <- c(sum(A[["Sum Sq"]]), A["Rep", "Sum Sq"], A["Crosses", "Sum Sq"], SS.a, SS.b, SS.b1, SS.b2, SS.b3, SS.c,
          SS.d, A["Residuals", "Sum Sq"])
  MS <- c(NA, SS[-1L] / df[-1L])
  Fv <- c(NA, MS[2:10] / MS[11L], NA)
  pv <- c(NA, stats::pf(Fv[2:10], df[2:10], df[11L], lower.tail = FALSE), NA)
  ANOVA <-
    data.frame(
        Df          = df
      , `Sum Sq`    = SS
      , `Mean Sq`   = MS
      , `F value`   = Fv
      , `Pr(>F)`    = pv
      , check.names = FALSE
      , row.names   = c("Total", "Rep", "Treatment", "  Additive", "  Non-Additive", "      b1", "      b2",
                        "      b3", "  Maternal", "  Reciprocal", "Error")
      )
  class(ANOVA) <- c("anova", "data.frame")
  #-----------------------------------------------------------------------------------------------------------------
  # arrays of the reciprocal-averaged table: Vr, Wr and the Wr-Vr regression
  #-----------------------------------------------------------------------------------------------------------------
  Ys    <- (M + t(M)) / 2
  Yr    <- diag(Ys)
  VOLO  <- stats::var(Yr)
  Vr    <- apply(Ys, 2L, stats::var)
  Wr    <- drop(stats::cov(Ys, Yr))
  V1L1  <- mean(Vr)
  V0L1  <- stats::var(colMeans(Ys))
  WOLO1 <- mean(Wr)
  b     <- stats::cov(Vr, Wr) / stats::var(Vr)
  a     <- mean(Wr) - b * mean(Vr)
  In.Value <- sqrt(V1L1 * VOLO)
  Wr.Vr <-
    data.frame(
        Wr          = Wr
      , Vr          = Vr
      , Wr.Minus.Vr = Wr - Vr
      , Wr.Plus.Vr  = Wr + Vr
      , Yr          = Yr
      , Wri         = sqrt(Vr * VOLO)
      , Wrei        = a + b * Vr
      , Wreip       = mean(Wr) - mean(Vr) + Vr
      , row.names   = cd$parents
      )
  #-----------------------------------------------------------------------------------------------------------------
  # components of variation (Hayman 1954a), standard errors from s^2 = Var(Wr - Vr)/2
  #-----------------------------------------------------------------------------------------------------------------
  E  <- (A["Rep", "Sum Sq"] + A["Residuals", "Sum Sq"]) / ((A["Rep", "Df"] + A["Residuals", "Df"]) * r)
  D  <- VOLO - E
  Fc <- 2 * VOLO - 4 * WOLO1 - 2 * (n - 2) * E / n
  H1 <- VOLO - 4 * WOLO1 + 4 * V1L1 - (3 * n - 2) * E / n
  H2 <- 4 * V1L1 - 4 * V0L1 - 2 * E
  h2 <- 4 * (mean(M) - mean(diag(M)))^2 - 4 * (n - 1) * E / n^2
  s2 <- stats::var(Wr - Vr) / 2
  Estimate <- c(E, D, Fc, H1, H2, h2)
  StdErr   <- sqrt(s2 * c(n^4, n^5 + n^4, 4 * n^5 + 20 * n^4 - 16 * n^3 + 16 * n^2, n^5 + 41 * n^4 - 12 * n^3 + 4 * n^2,
                          36 * n^4, 16 * n^4 + 16 * n^3 - 32 * n + 16) / n^5)
  Components.of.Variation <-
    data.frame(
        Estimate  = Estimate
      , StdErr    = StdErr
      , t.value   = Estimate / StdErr
      , row.names = c("E", "D", "F", "H1", "H2", "h2")
      )
  Fr <- data.frame(Fr = 2 * (VOLO - WOLO1 + V1L1 - (Wr + Vr)) - 2 * (n - 2) * E / n, row.names = paste0("Fr", 1:n))
  h2.ns <- (D + H1 - H2 - Fc) / (D + H1 - 0.5 * H2 - Fc + 2 * E)
  rho   <- stats::cor(Wr + Vr, Yr)
  Other.Parameters <-
    data.frame(
        `Other Parameters` = c(sqrt(H1 / D), H2 / (4 * H1), (sqrt(4 * D * H1) + Fc) / (sqrt(4 * D * H1) - Fc), rho,
                               rho^2, h2 / H2, h2.ns)
      , check.names = FALSE
      , row.names   = c("Mean degree of dominance sqrt(H1/D)", "Proportion of genes H2/(4H1)",
                        "Dominant to recessive genes", "r(Wr + Vr, Yr)", "r^2(Wr + Vr, Yr)", "Gene groups h2/H2",
                        "Narrow-sense heritability")
      )
  #-----------------------------------------------------------------------------------------------------------------
  # tests of the additive-dominance model
  #-----------------------------------------------------------------------------------------------------------------
  vV  <- stats::var(Vr)
  vW  <- stats::var(Wr)
  cVW <- stats::cov(Vr, Wr)
  t2  <- (n - 2) / 4 * (vV - vW)^2 / (vV * vW - cVW^2)
  se_b <- sqrt((stats::var(Wr) * (n - 1) - b^2 * vV * (n - 1)) / (n - 2) / (vV * (n - 1)))
  Tests <-
    data.frame(
        Statistic = c(t2, b / se_b, (1 - b) / se_b)
      , Df        = c(n - 2, n - 2, n - 2)
      , p.value   = c(stats::pf(t2, 1, n - 2, lower.tail = FALSE), 2 * stats::pt(-abs(b / se_b), n - 2),
                      2 * stats::pt(-abs((1 - b) / se_b), n - 2))
      , row.names = c("Uniformity of Wr - Vr (t^2)", "b = 0 (t)", "b = 1 (t)")
      )
  list(
      Means                   = M
    , ANOVA                   = ANOVA
    , VOLO                    = VOLO
    , In.Value                = In.Value
    , a                       = a
    , b                       = b
    , Wr.Vr.Table             = Wr.Vr
    , Components.of.Variation = Components.of.Variation
    , Other.Parameters        = Other.Parameters
    , Fr                      = Fr
    , Tests                   = Tests
    )
}
