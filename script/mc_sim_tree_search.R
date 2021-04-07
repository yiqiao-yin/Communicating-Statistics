# Library
library(animation)

# Data
tickers = "AAPL"
quantmod::getSymbols(tickers)
closePrices <- do.call(merge, lapply(tickers, function(x) get(x)[,4]))
closeReturns <- quantmod::dailyReturn(closePrices)
simulatedReturns = closeReturns
correctPath = cumprod(closeReturns + 1)
plot(correctPath, main = paste0("Entered Ticker: ", tickers, " (starting from $1)"))
L = length(closeReturns)
plot(closePrices, main = paste0("Entered Ticker: ", tickers, " (daily closing price)"))

# Define data
mu = 0
s = 0.005
num.of.sim <- 3e3
num.of.days <- 25
data <- matrix(rnorm(num.of.sim*num.of.days,mean=mu,sd=s),nrow=num.of.days); data[1, ] = 0L
updatedPath <- data
takeBearIntoConsideration = FALSE

# Create GIF
setwd("C:/Users/eagle/OneDrive/Desktop/")
saveGIF({
  for (d in 1:length(c(seq(1, L-num.of.days, num.of.days)[-length(seq(1, L-num.of.days, num.of.days))], L - num.of.days))) {
    # Setup
    currGenIdx = d
    d = seq(1, L, num.of.days)[d]
    
    # Start New Generation of MC Simulation
    par(mfrow=c(2, 1))
    if (d > 1) {
      mu = mean(data[, currIdx])
      s = sd(data[, currIdx])
    } # update parameter of prior distribution
    if (takeBearIntoConsideration) {
      data1 <- matrix(rnorm((.5*num.of.sim)*num.of.days,mean=mu,sd=s),nrow=num.of.days); data1[1, ] = 0L
      data2 <- matrix(rnorm((.5*num.of.sim)*num.of.days,mean=mu,sd=s)*(-1),nrow=num.of.days); data2[1, ] = 0L
      data <- cbind(data1, data2)
    } else {
      data <- matrix(rnorm(num.of.sim*num.of.days,mean=mu,sd=s),nrow=num.of.days); data[1, ] = 0L
    }
    for (N in seq(10,num.of.days,10)) {
      select.data <- data[1:N, ]
      cumret <- select.data + 1L
      cumretpath <- apply(cbind(cumret), 2, cumprod)
      # plot(x = 1:N, y = cumretpath[,1], type = "l", 
      #      main = paste0(
      #        "Simulated Path for $1 Investment\n Comment: X1, X2, ..., X", num.of.sim, 
      #        " drawn from N(",mu,",",s,") assuming iid"),
      #      ylab = "Numbers in USD",
      #      xlab = paste0("Time from Day 1 to Day ", N), 
      #      xaxs = "i", yaxs = "i",
      #      col = 1, xlim = c(1, num.of.days), ylim = c(min(cumretpath), max(cumretpath)))
      # for (i in 1:num.of.sim) { lines(x = 1:N, y = cumretpath[, i], type = "l", col = i) }
    } # end of current generation
    
    # Tree Search Current Generation for Least Errors
    currIdx = which.min(apply(cumretpath, 2, function(c) {mean((c - cumprod(closeReturns + 1)[1:num.of.days])^2)}))
    currMSE = mean((cumretpath[, currIdx] - cumprod(closeReturns + 1)[1:num.of.days])^2)
    
    # Store
    closeReturns[1:num.of.days]
    simulatedReturns[d:(d+num.of.days-1)] = data[, currIdx]
    
    # Visualization
    plot(x = 1:(d+num.of.days), y = correctPath[1:(d+num.of.days)],
         main = paste0("Real Path for Ticker: ", tickers, " (starting from $1)"),
         type = "l",
         ylab = "Numbers in USD",
         xlab = paste0("Time from Day 1 to Day ", d+num.of.days), 
         xaxs = "i", yaxs = "i",
         col = 1, xlim = c(1, L))
    simulatedPath = cumprod(simulatedReturns + 1)
    plot(x = 1:(d+num.of.days), y = simulatedPath[1:(d+num.of.days)],
         main = paste0(
           "Simulated Path Up to ", currGenIdx, "th Gen (starting from $1)\nRMSE for Current Gen is ", round(sqrt(currMSE), 4)),
         type = "l",
         ylab = "Numbers in USD",
         xlab = paste0("Time from Day 1 to Day ", d+num.of.days), 
         xaxs = "i", yaxs = "i",
         col = 1, xlim = c(1, L))
    
    # Checkpoint
    print(paste0("Finished ", currGenIdx, "/", length(seq(1, L, num.of.days))))
  } # end of all generations
}, movie.name = "mc-sim-random-walk-adv.gif", interval = .5, nmax = 30,
ani.width = 800, ani.height = 600)
