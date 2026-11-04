#' Diallel analysis by Griffing's methods
#'
#' @description
#' \code{Griffing()} performs the combining-ability analysis of a diallel cross by the four methods and two models of
#' Griffing (1956): the analysis of variance of general combining ability (gca), specific combining ability (sca) and
#' reciprocal effects, the estimates of the effects with their standard errors (fixed model) or the variance
#' components (random model), from the plot data of a randomized complete block experiment.
#'
#' @details
#' \strong{Data and cell means.} Each plot belongs to a cross \eqn{i \times j}{i x j} of parents \eqn{i}{i} (female,
#' \code{Cross1}) and \eqn{j}{j} (male, \code{Cross2}) and to a replicate (block). With \eqn{P}{P} parents and
#' \eqn{B}{B} replicates, the cell means form the \eqn{P \times P}{P x P} matrix \eqn{\mathbf{Y}}{Y} with elements
#' \eqn{Y_{ij}}{Y_ij}; \eqn{Y_{i\cdot}}{Y_i.}, \eqn{Y_{\cdot j}}{Y_.j} and \eqn{Y_{\cdot\cdot}}{Y_..} are its row,
#' column and grand totals. The four methods differ in the cells present:
#' \tabular{ll}{
#'   Method 1 \tab parents, \eqn{F_1}{F1} and reciprocal \eqn{F_1}{F1}: all \eqn{P^2}{P^2} cells \cr
#'   Method 2 \tab parents and one set of \eqn{F_1}{F1}: \eqn{P(P+1)/2}{P(P+1)/2} cells \cr
#'   Method 3 \tab \eqn{F_1}{F1} and reciprocals, no parents: \eqn{P(P-1)}{P(P-1)} cells \cr
#'   Method 4 \tab one set of \eqn{F_1}{F1} only: \eqn{P(P-1)/2}{P(P-1)/2} cells \cr
#' }
#' In Methods 2 and 4 a cross may be recorded either way round (\code{Cross1} = 3, \code{Cross2} = 5 or the reverse);
#' it is stored with the lower-numbered parent first. Every cross of the method must be present; individual plots may
#' be missing. With missing plots the cell means are the least-squares means of the block analysis (block effects
#' summing to zero), which removes the bias a missing plot in a good or a poor block would cause, and \eqn{B}{B} in the
#' error variance of a cell mean is the harmonic mean of the numbers of plots per cross (exact when every cross has the
#' same number of plots, an approximation otherwise).
#'
#' \strong{Model.} The mean of cross \eqn{i \times j}{i x j} is
#' \deqn{Y_{ij} = \mu + g_i + g_j + S_{ij} + R_{ij} + \bar{e}_{ij},}{Y_ij = mu + g_i + g_j + S_ij + R_ij + e_ij,}
#' with gca effects \eqn{\mathbf{g} = (g_1, \ldots, g_P)^\top}{g = (g_1, ..., g_P)'}, symmetric sca effects
#' \eqn{S_{ij} = S_{ji}}{S_ij = S_ji} and reciprocal effects \eqn{R_{ij} = -R_{ji}}{R_ij = -R_ji} (Methods 1 and 3
#' only), and an error of variance \eqn{\sigma^2/B}{sigma^2/B}. In the fixed model (\code{Model = 1}) the effects are
#' constants with \eqn{\sum_i g_i = 0}{sum g_i = 0} and the sca and reciprocal effects summing to zero over each
#' array; in the random model (\code{Model = 2}) they are independent random variables with variances
#' \eqn{\sigma^2_g}{sigma^2_g}, \eqn{\sigma^2_s}{sigma^2_s} and \eqn{\sigma^2_r}{sigma^2_r}.
#'
#' \strong{Error mean square.} The plot data are analysed as a randomized complete block design with the crosses as
#' treatments; \eqn{MS_E}{MS_E} is its residual mean square on \eqn{f_E}{f_E} degrees of freedom. The error line of the
#' combining-ability table is on the scale of a cell mean: sum of squares \eqn{SS_E/B}{SS_E/B}, mean square
#' \eqn{\sigma^2_m = MS_E/B}{sigma^2_m = MS_E/B}.
#'
#' \strong{Sums of squares} (Griffing 1956; Singh and Chaudhary 2004), on the scale of cell means. Method 1:
#' \deqn{SS_g = \frac{1}{2P}\sum_i (Y_{i\cdot} + Y_{\cdot i})^2 - \frac{2}{P^2}Y_{\cdot\cdot}^2, \quad
#'   SS_s = \frac{1}{2}\sum_i\sum_j Y_{ij}(Y_{ij} + Y_{ji}) - \frac{1}{2P}\sum_i (Y_{i\cdot} + Y_{\cdot i})^2
#'   + \frac{1}{P^2}Y_{\cdot\cdot}^2, \quad SS_r = \frac{1}{2}\sum_{i<j} (Y_{ij} - Y_{ji})^2,}{SS_g = (1/(2P))
#'   sum_i (Y_i. + Y_.i)^2 - (2/P^2) Y..^2; SS_s = (1/2) sum_ij Y_ij (Y_ij + Y_ji) - (1/(2P)) sum_i (Y_i. + Y_.i)^2
#'   + Y..^2/P^2; SS_r = (1/2) sum_{i<j} (Y_ij - Y_ji)^2,}
#' on \eqn{P-1}{P-1}, \eqn{P(P-1)/2}{P(P-1)/2} and \eqn{P(P-1)/2}{P(P-1)/2} degrees of freedom. Method 2 (totals over
#' the symmetric table, each cross counted once in each of its two arrays):
#' \deqn{SS_g = \frac{1}{P+2}\left[\sum_i (Y_{i\cdot} + Y_{ii})^2 - \frac{4}{P}Y_{\cdot\cdot}^2\right], \quad
#'   SS_s = \sum_{i \le j} Y_{ij}^2 - \frac{1}{P+2}\sum_i (Y_{i\cdot} + Y_{ii})^2
#'   + \frac{2}{(P+1)(P+2)}Y_{\cdot\cdot}^2,}{SS_g = [sum_i (Y_i. + Y_ii)^2 - (4/P) Y..^2]/(P + 2); SS_s =
#'   sum_{i<=j} Y_ij^2 - sum_i (Y_i. + Y_ii)^2/(P + 2) + 2 Y..^2/((P + 1)(P + 2)),}
#' on \eqn{P-1}{P-1} and \eqn{P(P-1)/2}{P(P-1)/2} degrees of freedom. Method 3:
#' \eqn{SS_g = \sum_i (Y_{i\cdot} + Y_{\cdot i})^2/(2(P-2)) - 2Y_{\cdot\cdot}^2/(P(P-2))}{SS_g = sum_i (Y_i. +
#' Y_.i)^2/(2(P - 2)) - 2 Y..^2/(P(P - 2))}, \eqn{SS_s = \frac{1}{2}\sum_{i<j}(Y_{ij}+Y_{ji})^2 - \sum_i (Y_{i\cdot} +
#' Y_{\cdot i})^2/(2(P-2)) + Y_{\cdot\cdot}^2/((P-1)(P-2))}{SS_s = (1/2) sum_{i<j} (Y_ij + Y_ji)^2 - sum_i (Y_i. +
#' Y_.i)^2/(2(P - 2)) + Y..^2/((P - 1)(P - 2))} on \eqn{P(P-3)/2}{P(P-3)/2} degrees of freedom, \eqn{SS_r}{SS_r} as in
#' Method 1. Method 4: \eqn{SS_g = \sum_i Y_{i\cdot}^2/(P-2) - 4Y_{\cdot\cdot}^2/(P(P-2))}{SS_g = sum_i Y_i.^2/(P - 2)
#' - 4 Y..^2/(P(P - 2))}, \eqn{SS_s = \sum_{i<j} Y_{ij}^2 - \sum_i Y_{i\cdot}^2/(P-2) + 2Y_{\cdot\cdot}^2/((P-1)(P-2))}{
#' SS_s = sum_{i<j} Y_ij^2 - sum_i Y_i.^2/(P - 2) + 2 Y..^2/((P - 1)(P - 2))}. These are the sums of squares of the
#' orthogonal least-squares decomposition of the cell means into the gca, sca and reciprocal subspaces, which is how
#' they are computed (one computation for the four methods; the closed forms above are the result).
#'
#' \strong{Tests.} Fixed model: every line against \eqn{\sigma^2_m}{sigma^2_m}. Random model: gca against sca, sca
#' and reciprocals against \eqn{\sigma^2_m}{sigma^2_m}.
#'
#' \strong{Effects} (fixed model). Method 1: \eqn{\hat{g}_i = (Y_{i\cdot} + Y_{\cdot i})/(2P) - Y_{\cdot\cdot}/P^2}{
#' g_i = (Y_i. + Y_.i)/(2P) - Y../P^2}, \eqn{\hat{S}_{ij} = (Y_{ij} + Y_{ji})/2 - (Y_{i\cdot} + Y_{\cdot i} + Y_{j\cdot}
#' + Y_{\cdot j})/(2P) + Y_{\cdot\cdot}/P^2}{S_ij = (Y_ij + Y_ji)/2 - (Y_i. + Y_.i + Y_j. + Y_.j)/(2P) + Y../P^2},
#' \eqn{\hat{R}_{ij} = (Y_{ij} - Y_{ji})/2}{R_ij = (Y_ij - Y_ji)/2}; Methods 2 to 4 analogously (Griffing 1956). The
#' standard errors of the effects and of their differences are \eqn{\sqrt{\mathrm{Var}}}{sqrt(Var)} of these linear
#' functions of the cell means with \eqn{\sigma^2}{sigma^2} replaced by \eqn{MS_E}{MS_E}; for Method 1 for example
#' \eqn{\mathrm{Var}(\hat{g}_i) = (P-1)\sigma^2_m/(2P^2)}{Var(g_i) = (P - 1) sigma^2_m/(2P^2)},
#' \eqn{\mathrm{Var}(\hat{S}_{ii}) = (P-1)^2\sigma^2_m/P^2}{Var(S_ii) = (P - 1)^2 sigma^2_m/P^2},
#' \eqn{\mathrm{Var}(\hat{S}_{ij}) = (P^2 - 2P + 2)\sigma^2_m/(2P^2)}{Var(S_ij) = (P^2 - 2P + 2) sigma^2_m/(2P^2)},
#' \eqn{\mathrm{Var}(\hat{R}_{ij}) = \sigma^2_m/2}{Var(R_ij) = sigma^2_m/2},
#' \eqn{\mathrm{Var}(\hat{g}_i - \hat{g}_j) = \sigma^2_m/P}{Var(g_i - g_j) = sigma^2_m/P}.
#'
#' \strong{Components.} Fixed model, as in Griffing (1956): Method 1 gca \eqn{(MS_g - \sigma^2_m)/(2P)}{(MS_g -
#' sigma^2_m)/(2P)}, sca \eqn{MS_s - \sigma^2_m}{MS_s - sigma^2_m}, reciprocal \eqn{(MS_r - \sigma^2_m)/2}{(MS_r -
#' sigma^2_m)/2}; Method 2 gca \eqn{(MS_g - \sigma^2_m)/(P+2)}{(MS_g - sigma^2_m)/(P + 2)}, sca \eqn{MS_s -
#' \sigma^2_m}{MS_s - sigma^2_m}; Method 3 gca \eqn{(MS_g - \sigma^2_m)/(2(P-2))}{(MS_g - sigma^2_m)/(2(P - 2))}, sca
#' \eqn{(MS_s - \sigma^2_m)/2}{(MS_s - sigma^2_m)/2}, reciprocal as Method 1; Method 4 gca \eqn{(MS_g -
#' \sigma^2_m)/(P-2)}{(MS_g - sigma^2_m)/(P - 2)}, sca \eqn{MS_s - \sigma^2_m}{MS_s - sigma^2_m}. Random model: the
#' variance components solve the expected mean squares, for Method 1
#' \deqn{\mathrm{E}(MS_g) = \sigma^2_m + \frac{2(P-1)}{P}\sigma^2_s + 2P\sigma^2_g, \quad \mathrm{E}(MS_s) = \sigma^2_m
#'   + \frac{2(P^2-P+1)}{P^2}\sigma^2_s, \quad \mathrm{E}(MS_r) = \sigma^2_m + 2\sigma^2_r,}{E(MS_g) = sigma^2_m +
#'   2(P - 1)/P sigma^2_s + 2P sigma^2_g; E(MS_s) = sigma^2_m + 2(P^2 - P + 1)/P^2 sigma^2_s; E(MS_r) = sigma^2_m +
#'   2 sigma^2_r,}
#' for Method 2 \eqn{\mathrm{E}(MS_g) = \sigma^2_m + \sigma^2_s + (P+2)\sigma^2_g}{E(MS_g) = sigma^2_m + sigma^2_s +
#' (P + 2) sigma^2_g}, \eqn{\mathrm{E}(MS_s) = \sigma^2_m + \sigma^2_s}{E(MS_s) = sigma^2_m + sigma^2_s}; Method 3
#' \eqn{\mathrm{E}(MS_g) = \sigma^2_m + 2\sigma^2_s + 2(P-2)\sigma^2_g}{E(MS_g) = sigma^2_m + 2 sigma^2_s + 2(P - 2)
#' sigma^2_g}, \eqn{\mathrm{E}(MS_s) = \sigma^2_m + 2\sigma^2_s}{E(MS_s) = sigma^2_m + 2 sigma^2_s}; Method 4
#' \eqn{\mathrm{E}(MS_g) = \sigma^2_m + \sigma^2_s + (P-2)\sigma^2_g}{E(MS_g) = sigma^2_m + sigma^2_s + (P - 2)
#' sigma^2_g}, \eqn{\mathrm{E}(MS_s) = \sigma^2_m + \sigma^2_s}{E(MS_s) = sigma^2_m + sigma^2_s}. The coefficients are
#' computed exactly from the design, so they hold for any number of parents. Additive and dominance variances follow
#' as \eqn{\sigma^2_A = 2\sigma^2_g}{sigma^2_A = 2 sigma^2_g} and \eqn{\sigma^2_D = \sigma^2_s}{sigma^2_D =
#' sigma^2_s} (non-inbred parents, no epistasis).
#'
#' \strong{Maternal and non-maternal reciprocal effects.} With \code{Reciprocal = "split"} the reciprocal effect is
#' written \eqn{r_{ij} = m_i - m_j + n_{ij}}{r_ij = m_i - m_j + n_ij} (Cockerham and Weir 1977), where \eqn{m_i}{m_i}
#' is the maternal effect of parent \eqn{i}{i} (\eqn{\sum_i m_i = 0}{sum m_i = 0}) and \eqn{n_{ij} = -n_{ji}}{n_ij =
#' -n_ji} the non-maternal (specific) reciprocal effect. With \eqn{D_{ij} = (\bar{y}_{ij} - \bar{y}_{ji})/2}{D_ij =
#' (y_ij - y_ji)/2} the least-squares estimates are
#' \deqn{\hat{m}_i = \frac{1}{P}\sum_{j \neq i} D_{ij}, \qquad \hat{n}_{ij} = D_{ij} - \hat{m}_i + \hat{m}_j,}{m_i =
#'   (1/P) sum_j D_ij; n_ij = D_ij - m_i + m_j,}
#' and the reciprocal sum of squares \eqn{\sum_{i \neq j} D_{ij}^2}{sum D_ij^2} splits into maternal,
#' \eqn{2P\sum_i \hat{m}_i^2}{2P sum m_i^2} on \eqn{P - 1}{P - 1} degrees of freedom, and non-maternal, the rest on
#' \eqn{(P - 1)(P - 2)/2}{(P - 1)(P - 2)/2}. Their expected mean squares are \eqn{\sigma^2/B + 2\sigma^2_n +
#' 2P\sigma^2_m}{sigma^2/B + 2 sigma^2_n + 2P sigma^2_m} and \eqn{\sigma^2/B + 2\sigma^2_n}{sigma^2/B + 2
#' sigma^2_n}, so in Model 2 the maternal line is tested against the non-maternal line and \eqn{\hat{\sigma}^2_m =
#' (MS_{mat} - MS_{nm})/(2P)}{sigma^2_m = (MS_mat - MS_nm)/(2P)}. The standard errors are \eqn{\sqrt{(P -
#' 1)\sigma^2/(2P^2B)}}{sqrt((P - 1) sigma^2/(2 P^2 B))} for \eqn{\hat{m}_i}{m_i}, \eqn{\sqrt{\sigma^2/(PB)}}{sqrt(sigma^2/(P
#' B))} for \eqn{\hat{m}_i - \hat{m}_j}{m_i - m_j} and \eqn{\sqrt{(P - 2)\sigma^2/(2PB)}}{sqrt((P - 2) sigma^2/(2 P B))}
#' for \eqn{\hat{n}_{ij}}{n_ij}.
#'
#' \strong{Changes from version 0.6.0.} The standard errors of Model 1 now use the error mean square; version 0.6.0
#' used the replicate mean square. In Method 2 the standard errors of \eqn{\hat{S}_{ii}}{S_ii} and
#' \eqn{\hat{S}_{ij}}{S_ij} were swapped in version 0.6.0. In Model 2 of Methods 1 and 3 the reciprocal line is tested
#' on the error degrees of freedom (version 0.6.0 used those of sca for its p-value). The third standard error of Method 4 (a Method 1 formula that has no meaning in
#' Method 4) is \code{NA}. The table of means keeps the parents' labels and has every parent in its rows and columns.
#' The sums of squares, tests, effects and components are unchanged.
#'
#' @param y response: a column of \code{data} given by name (\code{y = Yield} or \code{y = "Yield"}) or a numeric
#'   vector of length \code{nrow(data)}.
#' @param Rep replicate (block): a column of \code{data} or a vector, as for \code{y}.
#' @param Cross1 female parent of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param Cross2 male parent of each plot: a column of \code{data} or a vector, as for \code{y}.
#' @param data a data frame (or \code{data.table}) with one row per plot.
#' @param Method \code{1} (parents, \eqn{F_1}{F1} and reciprocals), \code{2} (parents and one set of
#'   \eqn{F_1}{F1}), \code{3} (\eqn{F_1}{F1} and reciprocals) or \code{4} (one set of \eqn{F_1}{F1}). No default.
#' @param Model \code{1} (fixed effects) or \code{2} (random effects). No default.
#' @param Reciprocal \code{"combined"} (default; one line for the reciprocal effects, as in earlier versions) or
#'   \code{"split"}: in Methods 1 and 3 the reciprocal line is split into maternal and non-maternal parts (Cockerham
#'   and Weir 1977); see Details. Ignored in Methods 2 and 4.
#'
#' @return An object of class \code{c("da_griffing", "da_result", "list")}, with the components of earlier versions
#'   followed by new ones:
#' \describe{
#'   \item{\code{Means}}{\eqn{P \times P}{P x P} matrix of cell means, female parents in rows, male parents in columns
#'     (\code{NA} for cells that are not part of the method).}
#'   \item{\code{ANOVA}}{combining-ability analysis of variance (class \code{anova}): lines \code{gca}, \code{sca},
#'     \code{reciprocals} (Methods 1 and 3) and \code{Error}; columns \code{Df}, \code{Sum Sq}, \code{Mean Sq},
#'     \code{F value}, \code{Pr(>F)}.}
#'   \item{\code{Genetic.Components}}{data frame with one column \code{Components}: Model 1 rows \code{gca},
#'     \code{sca}, \code{Reciprocal} (Methods 1, 3), \code{gca/sca}; Model 2 rows \code{gca}, \code{sca},
#'     \code{Reciprocal} (Methods 1, 3), \code{Error}, \code{Additive}, \code{Dominant} (\code{Dominance} in Method
#'     2), \code{gca/sca}.}
#'   \item{\code{Effects}}{(Model 1) \eqn{P \times P}{P x P} matrix: gca effects on the diagonal, sca effects above
#'     it, reciprocal effects below it (Methods 1, 3; \code{NA} in Methods 2, 4).}
#'   \item{\code{StdErr}}{(Model 1) named vector of standard errors of effects and of their differences: Method 1
#'     \code{gi, sii, sij, rij, gi_gj, sii_sjj, sii_sij, sii_sjk, sij_sik, sij_skl, rij_rkl}; Method 2 \code{gi, sii,
#'     sij, gi_gj, sii_sjj, sij_sik, sij_skl}; Method 3 \code{gi, sij, rij, gi_gj, sij_sik, sij_skl}; Method 4
#'     \code{gi, sij, not_defined, gi_gj, sij_sik, sij_skl}.}
#'   \item{\code{GCA}}{(new; Model 1) named vector of gca effects \eqn{\hat{\mathbf{g}}}{g}.}
#'   \item{\code{SCA}}{(new; Model 1) symmetric matrix of sca effects, selfs included in Methods 1 and 2.}
#'   \item{\code{Reciprocal}}{(new; Model 1, Methods 1 and 3) matrix of reciprocal effects,
#'     \eqn{\hat{R}_{ij} = -\hat{R}_{ji}}{R_ij = -R_ji}.}
#'   \item{\code{Maternal}, \code{NonMaternal}}{(new; Model 1, Methods 1 and 3, \code{Reciprocal = "split"}) vector of
#'     maternal effects \eqn{\hat{\mathbf{m}}}{m} and matrix of non-maternal effects \eqn{\hat{n}_{ij}}{n_ij}; the
#'     \code{StdErr} vector then also has \code{mi}, \code{mi_mj} and \code{nij}, the \code{ANOVA} lines
#'     \code{maternal} and \code{non-maternal} in place of \code{reciprocals}, and \code{Genetic.Components} the rows
#'     \code{Maternal} and \code{NonMaternal} in place of \code{Reciprocal}.}
#'   \item{\code{RCBD}}{(new) analysis of variance of the plot data as a randomized complete block design (lines
#'     \code{Rep}, \code{Crosses}, \code{Residuals}).}
#' }
#'   Methods: \code{print()}, \code{summary()}, \code{plot()} (gca effects with standard-error bars and the sca
#'   effects as a heat map, residuals of the block analysis against fitted values, normal quantile plot of the
#'   residuals, and a biplot of the cross means; \code{which = c("gca", "sca", "biplot", "residuals", "qq")}), \code{anova()}, \code{coef()}, \code{vcov()},
#'   \code{confint()}, \code{fitted()}, \code{residuals()}, \code{predict()}, \code{data.table::as.data.table(x,
#'   component =)}; see \code{\link{diallel-methods}} and \code{\link{da-methods}}.
#'
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#'
#' Cockerham, C. C. and Weir, B. S. (1977). Quadratic analyses of reciprocal crosses. \emph{Biometrics},
#' \strong{33}(1), 187--203. \doi{10.2307/2529312}
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com}), Kent M. Eskridge (\email{keskridge1@@unl.edu})
#' @seealso \code{\link{Hayman}}, \code{\link{PartialDiallel}}, \code{\link{GriffingData1}} to
#'   \code{\link{GriffingData4}}, \code{\link{da-methods}}
#' @family DiallelAnalysisR analyses
#' @examples
#' #-------------------------------------------------------------
#' ## Method 1 (parents, F1 and reciprocals), Model 1 (fixed effects)
#' #-------------------------------------------------------------
#' Griffing1Data1 <-
#'   Griffing(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData1
#'     , Method = 1
#'     , Model  = 1
#'     )
#' Griffing1Data1
#' summary(Griffing1Data1)
#' Griffing1Data1$ANOVA
#' Griffing1Data1$StdErr
#' data.table::as.data.table(Griffing1Data1, component = "ANOVA")
#' plot(Griffing1Data1)
#'
#' #-------------------------------------------------------------
#' ## Method 1, Model 2 (random effects)
#' #-------------------------------------------------------------
#' Griffing2Data1 <-
#'   Griffing(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData1
#'     , Method = 1
#'     , Model  = 2
#'     )
#' Griffing2Data1$Genetic.Components
#'
#' #-------------------------------------------------------------
#' ## Method 2 (parents and one set of F1), Model 1
#' #-------------------------------------------------------------
#' Griffing1Data2 <-
#'   Griffing(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData2
#'     , Method = 2
#'     , Model  = 1
#'     )
#' Griffing1Data2$ANOVA
#' Griffing1Data2$GCA
#'
#' #-------------------------------------------------------------
#' ## Method 3 (F1 and reciprocals), Model 1
#' #-------------------------------------------------------------
#' Griffing1Data3 <-
#'   Griffing(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData3
#'     , Method = 3
#'     , Model  = 1
#'     )
#' Griffing1Data3$ANOVA
#'
#' #-------------------------------------------------------------
#' ## Method 4 (one set of F1), Model 2
#' #-------------------------------------------------------------
#' Griffing2Data4 <-
#'   Griffing(
#'       y      = Yield
#'     , Rep    = Rep
#'     , Cross1 = Cross1
#'     , Cross2 = Cross2
#'     , data   = GriffingData4
#'     , Method = 4
#'     , Model  = 2
#'     )
#' Griffing2Data4$Genetic.Components
#' @export
Griffing <- function(y, Rep, Cross1, Cross2, data, Method, Model, Reciprocal = c("combined", "split")) {
  fn     <- "Griffing"
  data   <- .da_check_data(data, fn)
  y      <- .da_column(data, substitute(y), "y", fn, parent.frame())
  Rep    <- .da_column(data, substitute(Rep), "Rep", fn, parent.frame())
  Cross1 <- .da_column(data, substitute(Cross1), "Cross1", fn, parent.frame())
  Cross2 <- .da_column(data, substitute(Cross2), "Cross2", fn, parent.frame())
  Method <- .da_check_number(Method, "Method", fn, min = 1, max = 4, integer = TRUE)
  Model  <- .da_check_number(Model, "Model", fn, min = 1, max = 2, integer = TRUE)
  Reciprocal <- match.arg(Reciprocal)
  cd <-
    .da_cell_data(
        y      = y$value
      , p1     = Cross1$value
      , p2     = Cross2$value
      , rep    = Rep$value
      , method = Method
      , fn     = fn
      )
  if (cd$M |> nrow() < 4L) .da_stop(fn, "at least 4 parents are needed.")
  out <- .da_griffing_core(cd, Method, Model, split = Reciprocal == "split")
  attr(out, "plots") <- cd$plots
  .da_result(
      out
    , cls   = "griffing"
    , label = sprintf("Griffing's Method %d, Model %d (%s effects); %d parents, %s replicates%s", Method, Model,
                      c("fixed", "random")[Model], nrow(cd$M), format(round(cd$R, 2)),
                      if (cd$balanced) "" else " (missing plots: least-squares cross means)")
    , call  = match.call()
    , meta  = list(method = Method, model = Model, response = y$name, replicates = cd$R, reciprocal = Reciprocal)
    )
}

#-------------------------------------------------------------------------------------------------------------------
# One core for the eight method-model combinations
#-------------------------------------------------------------------------------------------------------------------
.da_griffing_core <- function(cd, method, model, split = FALSE) {
  M     <- cd$M
  P     <- nrow(M)
  dec   <- .da_griffing_closed(M, method)
  split <- split && method %in% c(1L, 3L)
  if (split) dec <- .da_reciprocal_split(dec, P)
  var_m <- cd$mse / cd$R                       # error variance of a cell mean
  df    <- c(dec$df, Error = cd$df_e)
  ss    <- c(dec$ss, Error = cd$ss_e / cd$R)
  ms    <- ss / df
  nl    <- length(dec$ss)                      # gca, sca (, reciprocals)
  #-----------------------------------------------------------------------------------------------------------------
  # tests: fixed model against the error; random model gca against sca, the others against the error
  #-----------------------------------------------------------------------------------------------------------------
  den   <- rep(ms[["Error"]], nl)
  dfd   <- rep(df[["Error"]], nl)
  if (model == 2L) {
    den[1L] <- ms[["sca"]]
    dfd[1L] <- df[["sca"]]
    if (split) {
      den[3L] <- ms[["non-maternal"]]
      dfd[3L] <- df[["non-maternal"]]
    }
  }
  Fv    <- c(ms[seq_len(nl)] / den, NA)
  pv    <- c(stats::pf(Fv[seq_len(nl)], df[seq_len(nl)], dfd, lower.tail = FALSE), NA)
  ANOVA <-
    data.frame(
        Df          = df
      , `Sum Sq`    = ss
      , `Mean Sq`   = ms
      , `F value`   = Fv
      , `Pr(>F)`    = pv
      , check.names = FALSE
      , row.names   = names(df)
      )
  class(ANOVA) <- c("anova", "data.frame")
  #-----------------------------------------------------------------------------------------------------------------
  # components: Griffing's fixed-model quantities, or the random-model variance components from the exact
  # expected mean squares
  #-----------------------------------------------------------------------------------------------------------------
  recip <- dec$recip
  cgg   <- dec$ems["gca", "gca"]
  if (split) {
    nm_v <- (ms[["non-maternal"]] - var_m) / 2
    rcomp <- c(Maternal = (ms[["maternal"]] - if (model == 1L) var_m else ms[["non-maternal"]]) / (2 * P),
               NonMaternal = nm_v)
  }
  if (model == 1L) {
    gca_v <- (ms[["gca"]] - var_m) / cgg
    sca_v <- (ms[["sca"]] - var_m) / if (method == 3L) 2 else 1
    comp  <- c(gca = gca_v, sca = sca_v,
               if (recip) { if (split) rcomp else c(Reciprocal = (ms[["reciprocals"]] - var_m) / 2) },
               `gca/sca` = gca_v / sca_v)
  } else {
    sca_v <- (ms[["sca"]] - var_m) / dec$ems["sca", "sca"]
    gca_v <- (ms[["gca"]] - var_m - dec$ems["gca", "sca"] * sca_v) / cgg
    rec_v <- if (recip) { if (split) rcomp else
      c(Reciprocal = (ms[["reciprocals"]] - var_m) / dec$ems["reciprocals", "reciprocals"]) }
    comp  <- c(gca = gca_v, sca = sca_v, if (recip) rec_v, Error = var_m, Additive = 2 * gca_v,
               stats::setNames(sca_v, if (method == 2L) "Dominance" else "Dominant"), `gca/sca` = gca_v / sca_v)
  }
  Genetic.Components <- data.frame(Components = unname(comp), row.names = names(comp))
  out <- list(Means = M, ANOVA = ANOVA, Genetic.Components = Genetic.Components)
  if (model == 1L) {
    #---------------------------------------------------------------------------------------------------------------
    # effects in the layout of earlier versions: gca on the diagonal, sca above, reciprocal below
    #---------------------------------------------------------------------------------------------------------------
    Effects <- matrix(0, P, P, dimnames = dimnames(M))
    diag(Effects) <- dec$g
    up <- upper.tri(Effects)
    Effects[up] <- dec$S[up]
    lo <- lower.tri(Effects)
    Effects[lo] <- if (recip) t(dec$R)[lo] else NA
    StdErr <- sqrt(dec$vse * var_m)
    if (method == 4L) StdErr <- c(StdErr[1:2], not_defined = NA_real_, StdErr[3:5])
    SCA <- dec$S
    dimnames(SCA) <- dimnames(M)
    out <- c(out, list(Effects = Effects, StdErr = StdErr, GCA = stats::setNames(dec$g, cd$parents), SCA = SCA))
    if (recip) {
      Rm <- dec$R
      dimnames(Rm) <- dimnames(M)
      out$Reciprocal <- Rm
    }
    if (split) {
      out$Maternal <- stats::setNames(dec$m, cd$parents)
      Nm <- dec$N
      dimnames(Nm) <- dimnames(M)
      out$NonMaternal <- Nm
      out$StdErr <- c(out$StdErr, sqrt(c(mi = (P - 1) / (2 * P^2), mi_mj = 1 / P, nij = (P - 2) / (2 * P)) * var_m))
    }
  }
  out$RCBD <- cd$anova
  out
}

#-------------------------------------------------------------------------------------------------------------------
# Cockerham and Weir's split of the reciprocal line into maternal and non-maternal parts (Methods 1 and 3)
#-------------------------------------------------------------------------------------------------------------------
.da_reciprocal_split <- function(dec, P) {
  D      <- dec$R
  diag(D) <- 0
  m      <- rowSums(D) / P
  N      <- D - outer(m, m, `-`)
  diag(N) <- 0
  ss_m   <- 2 * P * sum(m^2)
  ss_r   <- dec$ss[["reciprocals"]]
  k      <- which(names(dec$ss) == "reciprocals")
  dec$ss <- c(dec$ss[-k], maternal = ss_m, `non-maternal` = ss_r - ss_m)
  dec$df <- c(dec$df[-k], maternal = P - 1, `non-maternal` = (P - 1) * (P - 2) / 2)
  dec$m  <- m
  dec$N  <- N
  dec
}
