# Library
library(animation)

## Define a function to output a plot of pi
nRange <- seq(1e2, 1e4, 1e2)
pi_hat_vec <- rep(NA, length(nRange))
for (N in nRange) {
  x <- runif(N)
  y <- runif(N)
  d <- sqrt(x^2 + y^2)
  label <- ifelse(d < 1, 1, 0)
  pi_hat <- round(4*plyr::count(label)[2,2]/N,3)
  pi_hat_vec[which(N == nRange)] <- pi_hat
  par(mfrow=c(1,2))
  plot(
    x, y,
    col = label+1,
    main = paste0(
      "Simulation of Pi: N=", N,
      "; \nApprox. Value of Pi=", pi_hat),
    pch = 20, cex = 1)
  plot(
    nRange, pi_hat_vec, type = "both",
    main = paste0(
      "Path for the Simulation: ",
      "; \nApprox. Value of Pi=", pi_hat)); 
  lines(nRange, y = rep(pi, length(nRange)))
}


## Plot Monte Carlo Simulation of Pi
saveGIF({
  ## Define a function to output a plot of pi
  nRange <- seq(1e2, 1e4, 1e2)
  pi_hat_vec <- rep(NA, length(nRange))
  for (N in nRange) {
    x <- runif(N)
    y <- runif(N)
    d <- sqrt(x^2 + y^2)
    label <- ifelse(d < 1, 1, 0)
    pi_hat <- round(4*plyr::count(label)[2,2]/N,3)
    pi_hat_vec[which(N == nRange)] <- pi_hat
    par(mfrow=c(1,2))
    plot(
      x, y,
      col = label+1,
      xaxs = "i", yaxs = "i",
      main = paste0(
        "Simulation of Pi: N=", N,
        "\nApprox. Value of Pi=", pi_hat),
      pch = 20, cex = 1)
    plot(
      nRange, pi_hat_vec, type = "both",
      xaxs = "i", yaxs = "i",
      ylim = c(pi-.25, pi+.25),
      main = paste0(
        "Path for the Simulation: ",
        "; \nApprox. Value of Pi=", pi_hat)); 
    lines(nRange, y = rep(pi, length(nRange)))
  }
}, movie.name = "C:/Users/eagle/Desktop/mc-sim-pi-adv.gif", interval = 0.8, nmax = 30, 
ani.width = 800)
