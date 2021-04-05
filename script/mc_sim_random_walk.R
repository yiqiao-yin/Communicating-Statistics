# Library
library(animation)

# Define data
num.of.sim <- 50
num.of.days <- 200
data <- matrix(rnorm(num.of.sim*num.of.days,mean=0,sd=0.01),nrow=num.of.days)
data[1, ] = 0L

# Create GIF
setwd("C:/Users/eagle/OneDrive/Desktop/")
saveGIF({
  for (N in seq(10,num.of.days,10)) {
    select.data <- data[1:N, ]
    cumret <- select.data + 1L
    cumretpath <- apply(cbind(cumret), 2, cumprod)
    plot(x = 1:N, y = cumretpath[,1], type = "l", 
         main = paste0(
           "Simulated Path for $1 Investment\n Comment: X1, X2, ..., X", num.of.sim, 
           " drawn from N(0,0.01) assuming iid"),
         ylab = "Numbers in USD",
         xlab = paste0("Time from Day 1 to Day ", N), 
         xaxs = "i", yaxs = "i",
         col = 1, xlim = c(1, num.of.days), ylim = c(min(cumretpath), max(cumretpath)))
    for (i in 1:num.of.sim) { lines(x = 1:N, y = cumretpath[, i], type = "l", col = i) }
  }
}, movie.name = "mc-sim-random-walk.gif", interval = 1, nmax = 30,
# convert = "magick", 
ani.width = 600)
