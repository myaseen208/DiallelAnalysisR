# Simulated example data for LineTester() and NCDesign(); run from the package root.
set.seed(20261103)
blocks <- function(n_rep, cells) {
  d <- cells[rep(seq_len(nrow(cells)), times = n_rep), , drop = FALSE]
  d$Rep <- factor(rep(seq_len(n_rep), each = nrow(cells)))
  d
}
#--------------------------------------------------------------- line x tester: 8 lines, 3 testers, 3 replicates
L <- 8; Tn <- 3; B <- 3
cells <- expand.grid(Line = paste0("L", 1:L), Tester = paste0("T", 1:Tn), stringsAsFactors = TRUE)
gl <- rnorm(L, 0, 6); gt <- rnorm(Tn, 0, 5); s <- matrix(rnorm(L * Tn, 0, 4), L, Tn)
d <- blocks(B, cells)
r <- rnorm(B, 0, 3)
d$Yield <- round(80 + gl[d$Line] + gt[d$Tester] + s[cbind(as.integer(d$Line), as.integer(d$Tester))] +
                   r[d$Rep] + rnorm(nrow(d), 0, 4), 1)
LineTesterData <- d[, c("Line", "Tester", "Rep", "Yield")]
#--------------------------------------------------------------- North Carolina designs
nc <- list()
# Design I: 6 males, 4 females per male, 3 replicates
c1 <- data.frame(Male = factor(rep(paste0("M", 1:6), each = 4)), Female = factor(paste0("F", 1:24)))
m <- rnorm(6, 0, 3); f <- rnorm(24, 0, 4)
d <- blocks(3, c1)
d$Yield <- round(60 + m[as.integer(d$Male)] + f[as.integer(d$Female)] + rnorm(3, 0, 2)[d$Rep] + rnorm(nrow(d), 0, 3), 1)
d$Design <- 1L
nc[[1]] <- d
# Design II: 5 males by 4 females, 3 replicates
c2 <- expand.grid(Male = factor(paste0("M", 1:5)), Female = factor(paste0("F", 1:4)))
m <- rnorm(5, 0, 3); f <- rnorm(4, 0, 3); mf <- matrix(rnorm(20, 0, 2.5), 5, 4)
d <- blocks(3, c2)
d$Yield <- round(60 + m[as.integer(d$Male)] + f[as.integer(d$Female)] + mf[cbind(as.integer(d$Male),
                 as.integer(d$Female))] + rnorm(3, 0, 2)[d$Rep] + rnorm(nrow(d), 0, 3), 1)
d$Design <- 2L
nc[[2]] <- d
# Design III: 12 F2 males backcrossed to both parents P1 and P2, 3 replicates
c3 <- expand.grid(Male = factor(sprintf("M%02d", 1:12)), Female = factor(c("P1", "P2")))
m <- rnorm(12, 0, 3); mt <- matrix(rnorm(24, 0, 2.5), 12, 2)
d <- blocks(3, c3)
d$Yield <- round(60 + c(2, -2)[as.integer(d$Female)] + m[as.integer(d$Male)] + mt[cbind(as.integer(d$Male),
                 as.integer(d$Female))] + rnorm(3, 0, 2)[d$Rep] + rnorm(nrow(d), 0, 3), 1)
d$Design <- 3L
nc[[3]] <- d
NCData <- do.call(rbind, lapply(nc, function(z) {
  z$Male <- as.character(z$Male); z$Female <- as.character(z$Female); z[, c("Design", "Male", "Female", "Rep", "Yield")]
}))
rownames(NCData) <- NULL
save(LineTesterData, file = "data/LineTesterData.rda", compress = "xz")
save(NCData, file = "data/NCData.rda", compress = "xz")
