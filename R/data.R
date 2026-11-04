#-------------------------------------------------------------------------------------------------------------------
# Documentation of the data sets
#-------------------------------------------------------------------------------------------------------------------

#' Complete diallel of eight parents (Griffing's Method 1)
#'
#' @description
#' Yield of an eight-parent diallel with parents, \eqn{F_1}{F1} and reciprocal \eqn{F_1}{F1} (all 64 crosses) in a
#' randomized complete block experiment with four replicates. The data for Griffing's Methods 2, 3 and 4
#' (\code{\link{GriffingData2}}, \code{\link{GriffingData3}}, \code{\link{GriffingData4}}) are subsets of these plots,
#' and \code{\link{HaymanData}} is the same data set.
#' @format A \code{data.frame} with 256 rows (64 crosses by 4 replicates) and 4 columns:
#' \describe{
#'   \item{\code{Cross1}}{female parent (factor, levels \code{1} to \code{8}).}
#'   \item{\code{Cross2}}{male parent (factor, levels \code{1} to \code{8}); \code{Cross1 == Cross2} for the parents.}
#'   \item{\code{Rep}}{replicate (factor, levels \code{1} to \code{4}).}
#'   \item{\code{Yield}}{yield (numeric).}
#' }
#' @source Example data of the package since its first version.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#'
#' Singh, R. K. and Chaudhary, B. D. (2004). \emph{Biometrical Methods in Quantitative Genetic Analysis}. Kalyani
#' Publishers, New Delhi.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}, \code{\link{Hayman}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(GriffingData1)
#' @examples
#' data(GriffingData1)
#' str(GriffingData1)
#' with(data = GriffingData1, expr = tapply(X = Yield, INDEX = list(Cross1, Cross2), FUN = mean))
"GriffingData1"

#' Parents and one set of crosses of eight parents (Griffing's Method 2)
#'
#' @description
#' The plots of \code{\link{GriffingData1}} with the parents and the crosses \eqn{i \times j}{i x j},
#' \eqn{i < j}{i < j} (36 cells).
#' @format A \code{data.frame} with 144 rows (36 cells by 4 replicates) and the columns of
#'   \code{\link{GriffingData1}}: \code{Cross1}, \code{Cross2}, \code{Rep}, \code{Yield}.
#' @source A subset of \code{\link{GriffingData1}}.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(GriffingData2)
#' @examples
#' data(GriffingData2)
#' str(GriffingData2)
"GriffingData2"

#' Crosses and reciprocals of eight parents without the parents (Griffing's Method 3)
#'
#' @description
#' The plots of \code{\link{GriffingData1}} without the parents (56 cells).
#' @format A \code{data.frame} with 224 rows (56 cells by 4 replicates) and the columns of
#'   \code{\link{GriffingData1}}: \code{Cross1}, \code{Cross2}, \code{Rep}, \code{Yield}.
#' @source A subset of \code{\link{GriffingData1}}.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(GriffingData3)
#' @examples
#' data(GriffingData3)
#' str(GriffingData3)
"GriffingData3"

#' One set of crosses of eight parents (Griffing's Method 4)
#'
#' @description
#' The plots of \code{\link{GriffingData1}} with the crosses \eqn{i \times j}{i x j}, \eqn{i < j}{i < j} only (28
#' cells).
#' @format A \code{data.frame} with 112 rows (28 cells by 4 replicates) and the columns of
#'   \code{\link{GriffingData1}}: \code{Cross1} (levels \code{1} to \code{7}), \code{Cross2} (levels \code{2} to
#'   \code{8}), \code{Rep}, \code{Yield}.
#' @source A subset of \code{\link{GriffingData1}}.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Griffing}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(GriffingData4)
#' @examples
#' data(GriffingData4)
#' str(GriffingData4)
"GriffingData4"

#' Complete diallel of eight parents for Hayman's analysis
#'
#' @description
#' The data of \code{\link{GriffingData1}} (parents, \eqn{F_1}{F1} and reciprocals of eight parents, four replicates),
#' used in the examples of \code{\link{Hayman}}.
#' @format A \code{data.frame} with 256 rows and 4 columns: \code{Cross1} (female parent), \code{Cross2} (male
#'   parent), \code{Rep} (replicate), \code{Yield}.
#' @source Identical to \code{\link{GriffingData1}}.
#' @references
#' Hayman, B. I. (1954). The theory and analysis of diallel crosses. \emph{Genetics}, \strong{39}(6), 789--809.
#' \doi{10.1093/genetics/39.6.789}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{Hayman}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(HaymanData)
#' @examples
#' data(HaymanData)
#' str(HaymanData)
"HaymanData"

#' Partial diallel: ten by four parents
#'
#' @description
#' A partial diallel in which each of ten parents of a first group (\code{1} to \code{10}) is crossed with each of four
#' parents of a second group (\code{11} to \code{14}), in a randomized complete block experiment with four
#' replicates.
#' @format A \code{data.frame} with 160 rows (40 crosses by 4 replicates) and 4 columns:
#' \describe{
#'   \item{\code{Cross1}}{parent of group I (integer \code{1} to \code{10}).}
#'   \item{\code{Cross2}}{parent of group II (integer \code{11} to \code{14}).}
#'   \item{\code{Rep}}{replicate (integer \code{1} to \code{4}).}
#'   \item{\code{y}}{response (numeric).}
#' }
#' @source Example data of the package, contributed by Pedro A. M. Barbosa.
#' @references
#' Kempthorne, O. and Curnow, R. N. (1961). The partial diallel cross. \emph{Biometrics}, \strong{17}(2), 229--250.
#' \doi{10.2307/2527989}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com}), Pedro A. M. Barbosa (\email{pedro.barbosa@@usp.br})
#' @seealso \code{\link{PartialDiallel}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(PartialDiallelData)
#' @examples
#' data(PartialDiallelData)
#' str(PartialDiallelData)
"PartialDiallelData"

#' Griffing's (1956) maize diallel: cross means of nine inbred lines
#'
#' @description
#' The \eqn{F_1}{F1} means of the 36 crosses among nine inbred lines of maize (Griffing's Method 4) used in the
#' numerical example of Griffing (1956), from data of Griffing and Lindstrom (1954): six randomized blocks with 13
#' plants per plot. The error mean squares of the experiment (Griffing 1956, Table 7) are, per plant: within plots
#' 1642.48 (total yield), 46.61 (cob weight), 1247.39 (shelled corn) on 2558 degrees of freedom; varieties by blocks
#' 11803.61, 235.82, 9056.45 on 175 degrees of freedom. Divided by the 78 plants of a cross mean they give the error
#' of \code{\link{GriffingMeans}} for Model 1 and Model 2.
#' @format A \code{data.frame} with 36 rows and 5 columns:
#' \describe{
#'   \item{\code{Cross1}, \code{Cross2}}{the two parents of the cross (factors, levels \code{1} to \code{9};
#'     \code{Cross1 < Cross2}).}
#'   \item{\code{TotalYield}}{\eqn{X_1}{X1}, total yield (the sum of the next two).}
#'   \item{\code{CobWeight}}{\eqn{X_2}{X2}, cob weight.}
#'   \item{\code{ShelledCorn}}{\eqn{X_3}{X3}, shelled corn weight.}
#' }
#' @source Griffing (1956), Table 6, page 482.
#' @references
#' Griffing, B. (1956). Concept of general and specific combining ability in relation to diallel crossing systems.
#' \emph{Australian Journal of Biological Sciences}, \strong{9}(4), 463--493. \doi{10.1071/BI9560463}
#'
#' Griffing, B. and Lindstrom, E. W. (1954). A study of the combining abilities of corn inbreds having varying
#' proportions of corn belt and non-corn belt germ plasm. \emph{Agronomy Journal}, \strong{46}, 545--552.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{GriffingMeans}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(Griffing56)
#' @examples
#' data(Griffing56)
#' head(Griffing56)
"Griffing56"

#' Line by tester example: eight lines crossed with three testers
#'
#' @description
#' Simulated yields of the 24 crosses of eight lines with three testers in a randomized complete block experiment
#' with three replicates, drawn from a model with line, tester and line by tester effects. The data illustrate
#' \code{\link{LineTester}}.
#' @format A \code{data.frame} with 72 rows and 4 columns:
#' \describe{
#'   \item{\code{Line}}{line (factor, \code{L1} to \code{L8}).}
#'   \item{\code{Tester}}{tester (factor, \code{T1} to \code{T3}).}
#'   \item{\code{Rep}}{replicate (factor, \code{1} to \code{3}).}
#'   \item{\code{Yield}}{yield (numeric).}
#' }
#' @source Simulated; the script is \code{data-raw/LineTesterNC.R} of the package sources.
#' @references
#' Kempthorne, O. (1957). \emph{An Introduction to Genetic Statistics}. John Wiley and Sons, New York.
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{LineTester}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(LineTesterData)
#' @examples
#' data(LineTesterData)
#' with(data = LineTesterData, expr = tapply(X = Yield, INDEX = list(Line, Tester), FUN = mean))
"LineTesterData"

#' North Carolina designs I, II and III: example data
#'
#' @description
#' Simulated yields for the three North Carolina designs, each in a randomized complete block experiment with three
#' replicates: Design I with six males each mated to four different females, Design II with five males crossed with
#' four females, and Design III with twelve \eqn{F_2}{F2} males backcrossed to the two inbred parents \code{P1} and
#' \code{P2}. The data illustrate \code{\link{NCDesign}}.
#' @format A \code{data.frame} with 204 rows and 5 columns:
#' \describe{
#'   \item{\code{Design}}{design, \code{1}, \code{2} or \code{3} (integer).}
#'   \item{\code{Male}}{male parent (character).}
#'   \item{\code{Female}}{female parent (character; Design III: \code{P1} or \code{P2}).}
#'   \item{\code{Rep}}{replicate (factor, \code{1} to \code{3}).}
#'   \item{\code{Yield}}{yield (numeric).}
#' }
#' @source Simulated; the script is \code{data-raw/LineTesterNC.R} of the package sources.
#' @references
#' Comstock, R. E. and Robinson, H. F. (1948). The components of genetic variance in populations of biparental
#' progenies and their use in estimating the average degree of dominance. \emph{Biometrics}, \strong{4}(4),
#' 254--266. \doi{10.2307/3001412}
#' @author Muhammad Yaseen (\email{myaseen208@@gmail.com})
#' @seealso \code{\link{NCDesign}}
#' @family DiallelAnalysisR data
#' @docType data
#' @keywords datasets
#' @usage data(NCData)
#' @examples
#' data(NCData)
#' table(NCData$Design)
"NCData"
