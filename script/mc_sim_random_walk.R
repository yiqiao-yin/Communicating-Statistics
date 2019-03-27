
# Library
library(animation)

# Define data
num.of.sim <- 100
num.of.days <- 100
data <- matrix(rnorm(num.of.sim*num.of.days,mean=0,sd=0.01),nrow=num.of.days)

# Create GIF
saveGIF({
  for (N in seq(10,100,10)) {
    select.data <- data[1:N, ]
    cumret <- select.data + 1L
    cumretpath <- apply(cbind(cumret), 2, cumprod)
    plot(x = 1:N, y = cumretpath[,1], type = "l", 
         ylab = "Simulated Path for $1 Investment",
         xlab = paste0("Time from Day 1 to Day ", N), 
         col = 1, ylim = c(min(cumretpath), max(cumretpath)))
    for (i in 1:num.of.sim) { lines(x = 1:N, y = cumretpath[, i], type = "l", col = i) }
  }
}, movie.name = "mc-sim-random-walk.gif", interval = 0.3, nmax = 30, 
ani.width = 480)

