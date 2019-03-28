# Library
library(animation)

## Define a function to output a plot of pi
piR.plot <- function(N) {
  x <- runif(N)
  y <- runif(N)
  d <- sqrt(x^2 + y^2)
  label <- ifelse(d < 1, 1, 0)
  plot(x,y,col=label+1,
       main=paste0("Simulation of Pi: N=",N,
                   "; Simulated value=",
                   round(4*plyr::count(label)[2,2]/N,3)),
       pch = 20, cex = 1)
}

## Plot Monte Carlo Simulation of Pi
saveGIF({
  for (i in c(10,1e2,1e3,1e4,1e5,1e6)) {piR.plot(i)}
}, movie.name = "mc-sim-pi.gif", interval = 0.8, nmax = 30, 
ani.width = 480)
