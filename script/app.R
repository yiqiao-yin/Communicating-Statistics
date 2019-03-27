############################### BEGIN SCRIPT ##############################

#install.packages(c("NLP", "SnowballC", "slam", "tm", "wordcloud", "xml2",
#                   "quantmod", "shiny", "shinythemes", "corrplot", "forecast",
#                   "xts", "dygraphs", "ggplot2", "reshape2", "DT", "gtools",
#                   "rnn", "plot3D", "plotly", "parcoords"))
library('quantmod')
library('plotly')
library('shiny')
library('shinysky')
library('shinythemes')
library('corrplot')
library('forecast')
library('xts')
library('dygraphs')
library('ggplot2')
library('reshape2')
library('gtools')
library('DT')
library('rnn')
library("plot3D")
library("plotly")
library("parcoords")
library("quadprog")
library("pROC")
library("matrixcalc")
library("XML")
library("beepr")
library('data.table')
library('scales')
library('ggplot2')
library('fPortfolio')
library('finreportr')
library('knitr')
library('treemap')
library('tidyquant')
library('gridExtra')
library('animation')

######################## LOAD DATA ###################################

#load("E:/YINS CAPITAL, LLC/9. AppModule/V. Platform/CIP/data.RData") # Legion Laptop
#load("C:/Users/eagle/Desktop/CIP/app-update/data.RData") # Desktop
#save.image("E:/YINS CAPITAL, LLC/9. AppModule/V. Platform/CIP/data.RData")

######################## DEFINE: FUNCTIONS ################################

# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
  if (is.null(envir[[symbol]])) {
    envir[[symbol]] <- getSymbols(symbol,# src = "yahoo",
                                  auto.assign = FALSE#,
                                  #from = "2010-01-01"
    )
  }
  envir[[symbol]]
}

# Define overview plot function:
Overview.Plot <- function(x,r_day_plot,end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  chartSeries(data.all,
              theme = chartTheme("white"),
              name = "Candlestick Chart for Entered Ticker",
              TA = c(addEMA(12, col = 'green'),
                     addEMA(26, col = 'cyan'),
                     addEMA(50, col = 'yellow'),
                     addEMA(100, col = 'red'),
                     addEMA(200, col = 'purple'),
                     addVo(20)))
  addRSI(n = 28)#; addRSI(n = 50); addRSI(n = 75)
} # End of function

# Define basic plot function:
Basic.Plot <- function(x,r_day_plot,end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  #chartSeries(data,
  #            theme = chartTheme("black"),
  #            name = "Candlestick Chart for Entered Ticker",
  #            TA = c(addEMA(12, col = 'green'), addEMA(26, col = 'cyan'),
  #                   addEMA(50, col = 'yellow'),
  #                   addEMA(100, col = 'red'), addVo()))
  #addRSI(n = 28)
  
  # Advanced plot:
  dygraph(data.all,height="10%",width="80%") %>% dyCandlestick() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>% 
    dyRangeSelector()
} # End of function

# Define basic plot function:
Basic.Plot.Week <- function(x,r_day_plot,end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  name <- colnames(x)
  x <- to.weekly(x)
  colnames(x) <- name
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  #chartSeries(data,
  #            theme = chartTheme("black"),
  #            name = "Candlestick Chart for Entered Ticker",
  #            TA = c(addEMA(12, col = 'green'), addEMA(26, col = 'cyan'),
  #                   addEMA(50, col = 'yellow'),
  #                   addEMA(100, col = 'red'), addVo()))
  #addRSI(n = 28)
  
  # Advanced plot:
  dygraph(data.all,height="10%",width="80%") %>% dyCandlestick() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>% 
    dyRangeSelector()
} # End of function

# Define basic plot function:
Basic.Plot.Month <- function(x,r_day_plot,end_day_plot){
  #x <- AAPL; r_day_plot = .8; end_day_plot = 1
  name <- colnames(x)
  x <- to.monthly(x)
  colnames(x) <- name
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  data.all <- x[daily_initial_time_plot:daily_ending_time_plot,]
  data.all <- data.all[,-c(5:6)]
  #chartSeries(data,
  #            theme = chartTheme("black"),
  #            name = "Candlestick Chart for Entered Ticker",
  #            TA = c(addEMA(12, col = 'green'), addEMA(26, col = 'cyan'),
  #                   addEMA(50, col = 'yellow'),
  #                   addEMA(100, col = 'red'), addVo()))
  #addRSI(n = 28)
  
  # Advanced plot:
  dygraph(data.all,height="10%",width="80%") %>% dyCandlestick() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>% 
    dyRangeSelector()
} # End of function

# Buy signal function:
Buy<-function(x,r_day_plot,end_day_plot,c,height,test.new.price = 0){
  if (test.new.price == 0) {
    x = x
  } else {
    intra.day.test <- data.frame(matrix(c(0,0,0,test.new.price,0,0), nrow = 1))
    rownames(intra.day.test) <- as.character(Sys.Date())
    x = data.frame(rbind(x, intra.day.test))
  }
  Close<-x[,4] # Define Close as adjusted closing price
  # A new function needs redefine data from above:
  # Create SMA for multiple periods
  SMA10<-SMA(Close,n=10)
  SMA20<-SMA(Close,n=20)
  SMA30<-SMA(Close,n=30)
  SMA50<-SMA(Close,n=50)
  SMA200<-SMA(Close,n=200)
  SMA250<-SMA(Close,n=250)
  
  # Create RSI for multiple periods
  RSI10 <- (RSI(Close,n=10)-50)*height*5
  RSI20 <- (RSI(Close,n=20)-50)*height*5
  RSI30 <- (RSI(Close,n=30)-50)*height*5
  RSI50 <- (RSI(Close,n=50)-50)*height*5
  RSI200 <- (RSI(Close,n=200)-50)*height*5
  RSI250 <- (RSI(Close,n=250)-50)*height*5
  
  # Create computable dataset: Close/SMA_i-1
  ratio_10<-(Close/SMA10-1)
  ratio_20<-(Close/SMA20-1)
  ratio_30<-(Close/SMA30-1)
  ratio_50<-(Close/SMA50-1)
  ratio_200<-(Close/SMA200-1)
  ratio_250<-(Close/SMA250-1)
  all_data_ratio <- merge(
    ratio_10,
    ratio_20,
    ratio_30,
    ratio_50,
    ratio_200,
    ratio_250
  )
  # Here we want to create signal for each column
  # Then we add them all together
  all_data_ratio[is.na(all_data_ratio)] <- 0 # Get rid of NAs
  sd(all_data_ratio[,1])
  sd(all_data_ratio[,2])
  sd(all_data_ratio[,3])
  sd(all_data_ratio[,4])
  sd(all_data_ratio[,5])
  sd(all_data_ratio[,6])
  coef<-c
  m<-height*mean(Close)
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] <= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] <= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] <= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] <= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] <= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] <= coef*sd(all_data_ratio[,6]),
    m, "0")
  
  all_data_ratio$Signal<-(
    all_data_ratio[,7]
    +all_data_ratio[,8]
    +all_data_ratio[,9]
    +all_data_ratio[,10]
    +all_data_ratio[,11]
    +all_data_ratio[,12]
  )
  
  all_data_signal <- merge(Close, all_data_ratio$Signal)
  # return(all_data_signal)
  # return(ts.plot(all_data_signal,gpars= list(col=c("black","green")),main="Closing Price and Buy Signal Plot"))
  
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  plot(Close[daily_initial_time_plot:daily_ending_time_plot,],main="Closing Price with Buy Signal and SMA + RSI",
       ylim = c(-20,(max(Close)+3)))
  par(new=TRUE)
  lines(SMA10[daily_initial_time_plot:daily_ending_time_plot,], col = 5)
  lines(SMA20[daily_initial_time_plot:daily_ending_time_plot,], col = 6)
  lines(SMA30[daily_initial_time_plot:daily_ending_time_plot,], col = 7)
  lines(SMA50[daily_initial_time_plot:daily_ending_time_plot,], col = 8)
  lines(SMA200[daily_initial_time_plot:daily_ending_time_plot,], col = 2)
  lines(SMA250[daily_initial_time_plot:daily_ending_time_plot,], col = 3)
  lines(RSI10[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI20[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI30[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI50[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI200[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(RSI250[daily_initial_time_plot:daily_ending_time_plot,], col = 4)
  lines(all_data_ratio$Signal[daily_initial_time_plot:daily_ending_time_plot,],
        type = "h", col='green')
} # End of function # End of function # End of function
# End of function

#Buy(SPY,.8,1,-1.2,.1,0)
#Buy(SPY,.8,1,-1.2,.1,100)


# Buy table;
Buy.table<-function(x,r_day_plot,end_day_plot,c,height,past.n.days,test.new.price = 0){
  if (test.new.price == 0) {
    x = x
  } else {
    intra.day.test <- matrix(c(0,0,0,test.new.price,0,0), nrow = 1)
    rownames(intra.day.test) <- as.character(Sys.Date())
    x = data.frame(rbind(x, intra.day.test))
  }
  Close<-x[,4] # Define Close as adjusted closing price
  # A new function needs redefine data from above:
  # Create SMA for multiple periods
  SMA10<-SMA(Close,n=10)
  SMA20<-SMA(Close,n=20)
  SMA30<-SMA(Close,n=30)
  SMA50<-SMA(Close,n=50)
  SMA200<-SMA(Close,n=200)
  SMA250<-SMA(Close,n=250)
  
  # Create RSI for multiple periods
  RSI10 <- (RSI(Close,n=10)-50)*height*5
  RSI20 <- (RSI(Close,n=20)-50)*height*5
  RSI30 <- (RSI(Close,n=30)-50)*height*5
  RSI50 <- (RSI(Close,n=50)-50)*height*5
  RSI200 <- (RSI(Close,n=200)-50)*height*5
  RSI250 <- (RSI(Close,n=250)-50)*height*5
  
  # Create computable dataset: Close/SMA_i-1
  ratio_10<-(Close/SMA10-1)
  ratio_20<-(Close/SMA20-1)
  ratio_30<-(Close/SMA30-1)
  ratio_50<-(Close/SMA50-1)
  ratio_200<-(Close/SMA200-1)
  ratio_250<-(Close/SMA250-1)
  all_data_ratio <- cbind.data.frame(
    ratio_10,
    ratio_20,
    ratio_30,
    ratio_50,
    ratio_200,
    ratio_250
  )
  # Here we want to create signal for each column
  # Then we add them all together
  all_data_ratio[is.na(all_data_ratio)] <- 0 # Get rid of NAs
  sd(all_data_ratio[,1])
  sd(all_data_ratio[,2])
  sd(all_data_ratio[,3])
  sd(all_data_ratio[,4])
  sd(all_data_ratio[,5])
  sd(all_data_ratio[,6])
  coef<-c
  m<-height*mean(Close)
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] <= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] <= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] <= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] <= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] <= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] <= coef*sd(all_data_ratio[,6]),
    m, "0")
  
  all_data_ratio$Signal <- (
    as.numeric(all_data_ratio[,7])
    + as.numeric(all_data_ratio[,8])
    + as.numeric(all_data_ratio[,9])
    + as.numeric(all_data_ratio[,10])
    + as.numeric(all_data_ratio[,11])
    + as.numeric(all_data_ratio[,12])
  )
  
  all_data_signal <- cbind.data.frame(Close, all_data_ratio$Signal)
  
  return(
    #tail(all_data_signal)
    all_data_signal[(nrow(all_data_signal)-past.n.days):nrow(all_data_signal),]
  )
} # End of function # End of function # End of function
# End of function

#x=SPY; r_day_plot=.8; end_day_plot=1; c=-1.2; height=.1; past.n.days=2; test.new.price=0
#Buy.table(SPY,.8,1,-1.2,.1,2,0)

# Sell table;
Sell.table<-function(x,r_day_plot,end_day_plot,c,height,past.n.days,test.new.price = 0){
  if (test.new.price == 0) {
    x = x
  } else {
    intra.day.test <- matrix(c(0,0,0,test.new.price,0,0), nrow = 1)
    rownames(intra.day.test) <- as.character(Sys.Date())
    x = data.frame(rbind(x, intra.day.test))
  }
  Close<-x[,4] # Define Close as adjusted closing price
  # A new function needs redefine data from above:
  # Create SMA for multiple periods
  SMA10<-SMA(Close,n=10)
  SMA20<-SMA(Close,n=20)
  SMA30<-SMA(Close,n=30)
  SMA50<-SMA(Close,n=50)
  SMA200<-SMA(Close,n=200)
  SMA250<-SMA(Close,n=250)
  
  # Create RSI for multiple periods
  RSI10 <- (RSI(Close,n=10)-50)*height*5
  RSI20 <- (RSI(Close,n=20)-50)*height*5
  RSI30 <- (RSI(Close,n=30)-50)*height*5
  RSI50 <- (RSI(Close,n=50)-50)*height*5
  RSI200 <- (RSI(Close,n=200)-50)*height*5
  RSI250 <- (RSI(Close,n=250)-50)*height*5
  
  # Create computable dataset: Close/SMA_i-1
  ratio_10<-(Close/SMA10-1)
  ratio_20<-(Close/SMA20-1)
  ratio_30<-(Close/SMA30-1)
  ratio_50<-(Close/SMA50-1)
  ratio_200<-(Close/SMA200-1)
  ratio_250<-(Close/SMA250-1)
  all_data_ratio <- cbind.data.frame(
    ratio_10,
    ratio_20,
    ratio_30,
    ratio_50,
    ratio_200,
    ratio_250
  )
  # Here we want to create signal for each column
  # Then we add them all together
  all_data_ratio[is.na(all_data_ratio)] <- 0 # Get rid of NAs
  sd(all_data_ratio[,1])
  sd(all_data_ratio[,2])
  sd(all_data_ratio[,3])
  sd(all_data_ratio[,4])
  sd(all_data_ratio[,5])
  sd(all_data_ratio[,6])
  coef<-c
  m<-height*mean(Close)
  all_data_ratio$Sig1<-ifelse(
    all_data_ratio[,1] >= coef*sd(all_data_ratio[,1]),
    m, "0")
  all_data_ratio$Sig2<-ifelse(
    all_data_ratio[,2] >= coef*sd(all_data_ratio[,2]),
    m, "0")
  all_data_ratio$Sig3<-ifelse(
    all_data_ratio[,3] >= coef*sd(all_data_ratio[,3]),
    m, "0")
  all_data_ratio$Sig4<-ifelse(
    all_data_ratio[,4] >= coef*sd(all_data_ratio[,4]),
    m, "0")
  all_data_ratio$Sig5<-ifelse(
    all_data_ratio[,5] >= coef*sd(all_data_ratio[,5]),
    m, "0")
  all_data_ratio$Sig6<-ifelse(
    all_data_ratio[,6] >= coef*sd(all_data_ratio[,6]),
    m, "0")
  
  all_data_ratio$Signal <- (
    as.numeric(all_data_ratio[,7])
    + as.numeric(all_data_ratio[,8])
    + as.numeric(all_data_ratio[,9])
    + as.numeric(all_data_ratio[,10])
    + as.numeric(all_data_ratio[,11])
    + as.numeric(all_data_ratio[,12])
  )
  
  all_data_signal <- cbind.data.frame(Close, all_data_ratio$Signal)
  
  return(
    #tail(all_data_signal)
    all_data_signal[(nrow(all_data_signal)-past.n.days):nrow(all_data_signal),]
  )
} # End of function # End of function # End of function
# End of function

# Buy/Sell Algorithm:
BS.Algo <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,past.n.days,test.new.price=0) {
  buy.sell.table <- data.frame(cbind(
    rownames(Buy.table(x,r_day_plot,end_day_plot,c.buy,height,past.n.days)),
    Buy.table(x,r_day_plot,end_day_plot,c.buy,height,past.n.days,test.new.price)[,1:2],
    Sell.table(x,r_day_plot,end_day_plot,c.sell,height,past.n.days,test.new.price)[,2]
  ))
  colnames(buy.sell.table) <- c("Date", "Ticker", "Buy.Signal", "Sell.Signal")
  buy.sell.table
} # End of function

# Buy/Sell Signal Chart:
BS.Algo.Chart <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,past.n.days,test.new.price=0) {
  daily_initial_time_plot <- r_day_plot*nrow(x)
  daily_ending_time_plot <- end_day_plot*nrow(x)
  past.n.days <- round(daily_ending_time_plot - daily_initial_time_plot)
  data <- BS.Algo(x,r_day_plot,end_day_plot,c.buy,c.sell,height,
                  past.n.days,test.new.price=0)[, c(3,4)]
  dygraph(data,height="10%",width="80%") %>%
    dyBarChart() %>%
    dyLegend(show = "onmouseover", hideOnMouseOut = FALSE) %>% 
    dyRangeSelector()
}

#BS.Algo.Chart(AAPL, .5, 1, -1, 1.5, .1, 500, 0)

# Buy/sell Signal Distribution:
BS.Dist <- function(x,r_day_plot,end_day_plot,c.buy,c.sell,height,test.new.price=0) {
  # x <- SPY; r_day_plot = .8; end_day_plot = 1; c.buy = -.5; c.sell = .5; height = 1
  past.n.days <- nrow(x)
  buy.sell.table <- BS.Algo(x,
                            r_day_plot,end_day_plot,
                            c.buy,c.sell,height,
                            past.n.days,test.new.price=0)
  
  bs.dist <- matrix(NA,nrow=4,ncol=2)
  bs.dist[1,1] <- round(mean(buy.sell.table[,3]),4)
  bs.dist[2,1] <- round(sd(buy.sell.table[,3]),4)
  bs.dist[3,1] <- round(max(buy.sell.table[,3]),4)
  bs.dist[4,1] <- plyr::count(buy.sell.table[,3] > 0)[2,2]/sum(plyr::count(buy.sell.table[,3] > 0)[1,2], plyr::count(buy.sell.table[,3] > 0)[2,2])
  bs.dist[4,1] <- round(bs.dist[4,1],4)
  bs.dist[1,2] <- round(mean(buy.sell.table[,4]),4)
  bs.dist[2,2] <- round(sd(buy.sell.table[,4]),4)
  bs.dist[3,2] <- round(max(buy.sell.table[,4]),4)
  bs.dist[4,2] <- plyr::count(buy.sell.table[,4] > 0)[2,2]/sum(plyr::count(buy.sell.table[,4] > 0)[1,2], plyr::count(buy.sell.table[,4] > 0)[2,2])
  bs.dist[4,2] <- round(bs.dist[4,2],4)
  bs.dist <- data.frame(cbind(
    c("Mean", "STD", "MAX", "Freq"),bs.dist,
    c("Ave. buy/sell signals including zeros",
      "Alpha:>=1STD; Beta:>0; Exit:<80% D/W low",
      "Maximum buy/sell signal ever happened",
      "Execution occurences x% of the time (you want to be as little as possible)")
  ))
  colnames(bs.dist) <- c("Summary", "Buy.Sig.Dist", "Sell.Sig.Dist", "Indicated Game Plan")
  bs.dist
} # End of function

# Example:
#x,r_day_plot,end_day_plot,c.buy,c.sell,height,past.n.days
#BS.Algo(AAPL, 08, 1, -.5, +.5, 1, 100)
#BS.Dist(AAPL, 08, 1, -1.9, +1.9, 1, 200)

#x <- getSymbols('AAPL')
#Close <- x[,4]
#Return <- Close/lag(Close)-1
#hist(Return)

# Benchmark with market
# Define function
price.to.market.algo <- function(x, #r_day_plot, end_day_plot, c, height,
                                 past.n.buy=3,
                                 past.n.days=300){
  # Get data
  getSymbols("SPY")
  Close<-x[,4] # Define Close as adjusted closing price
  
  # Extract recent data
  #past.n.days = 500
  Close <- Close[(nrow(Close) - past.n.days):nrow(Close),]
  SPY <- SPY[(nrow(SPY) - past.n.days):nrow(SPY),]
  
  # Compute
  price.to.market <- Close/SPY[,4]
  minimum <- min(price.to.market); minimum <- round(minimum, 4)
  maximum <- max(price.to.market); maximum <- round(maximum, 4)
  average <- mean(price.to.market); average <- round(average, 4)
  SD <- sd(price.to.market); SD <- round(SD, 4)
  
  # Compute return beta
  Y = (Close/lag(Close)-1)*100; X = (SPY[,4]/lag(SPY[,4])-1)*100
  LM <- lm(Y ~ X)
  beta = LM$coefficients[2]; beta <- round(beta, 4)
  
  # Main Table Output
  Date <- rownames(data.frame(price.to.market))
  Result <- data.frame(cbind(
    data.frame(Date),
    data.frame(round(price.to.market, 4))
  )); colnames(Result) <- c("Date", "Price-to-Market")
  # Result
  
  # Stats
  statistics <- rbind(
    c("Min P/M = ", minimum, "Heavy buy if exposed to market normality."),
    c("Average P/M = ", average, "Do nothing."),
    c("SD of P/M = ", SD, "Consider buy/sell two SD below/above average level."),
    c("Max P/M = ", maximum, "Recommended sell if exposed to market normality."),
    c("Beta (Ret ~ MKT) = ", beta, "Volatility, behavior of stock price relative to market price."))
  colnames(statistics) <- c("Name", "P/M Distribution", "Indicated Game Plan")
  
  # Output
  return(list(
    Table = Result[(nrow(Result) - past.n.buy):nrow(Result),],
    Stats = statistics
  ))
} # End of function

# Correlation:
Buy.table.corr<-function(x,r_day_plot,end_day_plot,c,height,past.n.days){
  # x <- AAPL
  getSymbols(c('SPY','QQQ','DIA','IWM','GLD','FEZ','FXI'))
  M <- data.frame(
    Buy.table(x,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(SPY,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(QQQ,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(DIA,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(IWM,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(GLD,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(FEZ,r_day_plot,end_day_plot,c,height,past.n.days)[,1],
    Buy.table(FXI,r_day_plot,end_day_plot,c,height,past.n.days)[,1]
  )
  M.update <- cor(M)
  colnames(M.update) = c("Entered.Stock","SPY","QQQ","DIA","IWM","GLD","FEZ","FXI")
  rownames(M.update) = c("Entered.Stock","SPY","QQQ","DIA","IWM","GLD","FEZ","FXI")
  return(data.frame(M.update))
  #corrplot(M.update, method = "number", type = "upper")
} # End of function:

#Buy.table.corr(AAPL,.8, 1,-.5,1.2,10)

# Define a function that calculates returns
All.Indice.3D.Enter <- function(
  a,b,c,d
) {
  # Data
  data.list <- list(
    a,b,c,d
  )
  all <- matrix(NA, nrow = 4, ncol = 4)
  
  # Update Momentum:
  for (i in c(1:nrow(all))){all[i,1] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-5),4])-1}
  for (i in c(1:nrow(all))){all[i,2] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25),4])-1}
  for (i in c(1:nrow(all))){all[i,3] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-25*3),4])-1}
  for (i in c(1:nrow(all))){all[i,4] <- (data.frame(data.list[i])[nrow(data.frame(data.list[i])),4])/(data.frame(data.list[i])[(nrow(data.frame(data.list[i]))-252),4])-1}
  
  # Update column names:
  colnames(all) <- c("Pre 5-Days",
                     "Pre 30-Days", 
                     "Pre Quarter",
                     "Pre Year")
  df <- data.frame(all)
  df
} # End of function

## Define a function to output a plot of pi
piR.plot <- function(N) {
  x <- runif(N)
  y <- runif(N)
  d <- sqrt(x^2 + y^2)
  label <- ifelse(d < 1, 1, 0)
  plot(x,y,col=label+1,main=paste0("Simulation of Pi Using N=",N),
       pch = 20, cex = 1)
}

## Plot Monte Carlo Simulation of Pi
#saveGIF({
#  for (i in c(100,200,500,1000,2000,5000,10000,15000,20000)) {piR.plot(i)}
#}, movie.name = "mc-sim-pi.gif", interval = 0.3, nmax = 30, 
#ani.width = 480)

####################### DESIGN SHINY ###################################

shinyApp(
  ####################### DEFINE: UI ##############################
  ui = tagList(
    shinythemes::themeSelector(),
    navbarPage(
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      "APP: Class9a",
      fluid = TRUE,
      ####################### NAVBAR 1 #############################
      tabPanel("Navbar 1: TIMING THE MARKET",
               sidebarPanel(
                 h4("--------- MAIN ---------"),
                 textInput(inputId = "stock_enter_1", label = "Enter Ticker", value = "AAPL", width="100%"),
                 sliderInput(inputId = "time.set", "Set Time", min = 1, max = 12, value = 1, step = 1),
                 sliderInput(inputId = "percentage", label = "Data: from the x% to y%", min = 0.05, max = 1, value = c(0.6, 1), step = 0.01),
                 sliderInput(inputId = "constant", label = "Frequency (How often to buy/sell)", min = -4, max = 4, value = c(-2.5, +2.5), step = 0.01),
                 sliderInput(inputId = "past.n.days", label = "Past n-day Buy/Sell Signal", min = 1, max = 30, value = 3, step = 1),
                 textInput(inputId = "test.new.price", label = "Intraday: Test New Price", value = 0)#,
                 #submitButton("Run Script", width = "100%")
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Tab1: Basic Comparison",
                            fluidPage(
                              fluidRow(
                                column(5, 
                                       h4("Brownian Motion Movement"),
                                       plotOutput("BM")),
                                column(5, 
                                       h4("Stocks Movement"),
                                       plotOutput("Mkt"))
                              )
                            )),
                   tabPanel("Tab2: Timing Effect in Application",
                            fluidPage(
                              fluidRow(
                                column(12,
                                       h4("Overview of Entered Stock"),
                                       plotlyOutput("overview.stock")
                                )
                              ),
                              br(),br(),br(),br(),br(),br(),
                              br(),br(),br(),br(),br(),br(),
                              fluidRow(
                                column(6,
                                       h4("Daily Chart"),
                                       dygraphOutput("dygraph")
                                ),
                                column(6,
                                       h4("Weekly Chart"),
                                       dygraphOutput("dygraph.week")
                                )
                              ),
                              fluidRow(
                                column(6,
                                       h4("Buy/Sell Signal"),
                                       dygraphOutput("dygraph.signal")
                                ),
                                column(6,
                                       h4("Monthly Chart"),
                                       dygraphOutput("dygraph.month")
                                )
                              )
                            ),
                            fluidRow(
                              column(6,
                                     h4("Buy Sell Action: Recent Data"),
                                     tableOutput(outputId = "table_enter_1")),
                              column(6,
                                     h4("Buy Sell Action: Distribution (from all data)"),
                                     tableOutput(outputId = "table_enter_1_BS_Dist"))
                              )
                            ),
                 tags$head(
                   conditionalPanel(condition="input.goButton > 0 | $('html').hasClass('shiny-busy')",
                                    tags$div(
                                      c("Calculating... Please wait... Patience is the key to success.",
                                        "Calculating... Please wait... Patience is not simply the ability to wait - it's how we behave while we're waiting",
                                        "Calculating... Please wait... The two most powerful warriors are patience and time."
                                      )[sample(3,3)[1]]))))
                 )
               ),
      ####################### NAVBAR 2 #############################
      tabPanel("Navbar 2: FUN SIMULATION",
               sidebarPanel(
                 h4("--------- MAIN ---------"),
                 sliderInput(inputId = "n.sim", label = "Number of Monte Carlo Simulation", min = 100, value = 100, step = 100, max = 2e4)
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel(
                     "Tab1: Monte Carlo Simulation of Pi",
                     fluidPage(
                       fluidRow(
                         column(4,
                                h4("Monte Carlo Simulation of Pi"),
                                plotOutput("pi.sim.plot"))
                       )
                     )
                   )
                 )
               ))
      )
    ),
  
  ####################### DEFINE: SERVER ##############################
  server = function(input, output, session) {
    # NAVBAR 1
    # Plot: Brownian Motion
    output$BM <- renderPlot({
      set.seed(input$time.set)
      brownian.motion(n = 4, pch = 21, cex = 5, col = "red", bg = "yellow")
    })
    
    # Plot: Stock Movement
    output$Mkt <- renderPlot({
      month <- input$time.set
      getSymbols(c("AAPL", "MSFT", "GOOGL", "NVDA"),
                 to = paste0("2018-",month,"-01"))
      data <- All.Indice.3D.Enter(AAPL, MSFT, GOOGL, NVDA)
      rownames(data) <- c("AAPL", "MSFT", "GOOGL", "NVDA"); data
      plot(data$Pre.5.Days~data$Pre.30.Days,
           xlim = c(-0.5,0.5), ylim = c(-0.5,0.5),
           main = paste0("Week/Month Returns Using Data Up to 2018-",month,"-01"),
           xlab = "Last Month Returns", ylab = "Last Week Returns",
           data = data[,c(1,2)], pch = 2)
      with(data[,c(1,2)], text(data$Pre.5.Days~data$Pre.30.Days, cex = 1.2,
                               labels = row.names(data[, c(1,2)]), pos = 4))
    })
    # Create an environment for storing data
    symbol_env <- new.env()
    # Make a chart for a symbol, with the settings from the inputs
    make_chart <- function(symbol) {
      symbol_data <- require_symbol(symbol, symbol_env)
      chartSeries(symbol_data,
                  name      = symbol,
                  type      = input$chart_type,
                  subset    = paste(input$daterange, collapse = "::"),
                  log.scale = input$log_y,
                  theme     = "white")
    }
    output$overview.stock <- renderPlotly({
      #Overview.Plot(
      #  x = require_symbol(input$stock_enter_1),
      #  r_day_plot = input$percentage[1],
      #  end_day_plot = input$percentage[2]
      #)
      
      # Get data
      stock <- require_symbol(input$stock_enter_1)
      dts <- index(stock)
      df <- data.frame(stock, row.names = NULL)
      df$dates <- dts
      names(df) <- c("Open", "High", "Low", "Close", "Volume", "Adjusted", "dates")
      
      # Subset to after Jan 2016
      df <- subset(df, dates > "2012-01-01")
      
      # Color or volume bars
      barcols <- c()
      for (i in 1:length(df$dates)) {
        if (i == 1) {barcols[i] <- "#F95959"}
        if (i > 1) {
          x <- ifelse(df$Close[i] > df$Close[i - 1], "#455D7A", "#F95959")
          barcols[i] <- x
        }
      }
      
      # Moving Avg line
      MA <- runMean(df$Close)
      
      # Range selector
      rangeselectorlist = list(
        x = 0, y = 0.9,
        bgcolor = "#0099cc",
        font = list(color = "white"),
        
        buttons = list(
          list(count = 1, label = "reset", step = "all"),
          list(count = 1, label = "1yr", step = "year", stepmode = "backward"),
          list(count = 3, label = "3 mo", step = "month", stepmode = "backward"),
          list(count = 1, label = "1 mo", step = "month", stepmode = "backward"),
          list(step = "all")
        )
      )
      
      # BASE CANDLESTICK CHART WITH MACD
      macd <- data.frame(TTR::MACD(df$Close, 12, 26, 9))
      macd$diff <- macd$macd - macd$signal
      BB <- as.data.frame(BBands(df$Close))
      
      plot_ly(df, type = "candlestick",
              x = ~dates,
              open = ~Open, high = ~High, low = ~Low, close = ~Close,
              yaxis = "y",
              increasing = list(line = list(color = "#455D7A")),
              decreasing = list(line = list(color = "#F95959")),
              name = "Price", height = 600 # height = 600, width = 1024
      ) %>%
        
        # MA
        add_lines(x = df$dates, y = BB$mavg,
                  line = list(width = 3, dash = "5px", color = "#33bbff"),
                  inherit = F, name = "Mov Avg") %>%
        
        # MACD
        add_lines(x = df$dates, y = macd$macd,
                  yaxis = "y2",
                  line = list(width = 1, color = "#8c8c8c"),
                  inherit = FALSE) %>%
        
        add_lines(x = df$dates, y = macd$signal,
                  yaxis = "y2",
                  line = list(width = 1, color = "#ff6666"),
                  inherit = FALSE) %>%
        
        add_bars(x = df$dates, y = macd$diff,
                 marker = list(color = "#bfbfbf"),
                 yaxis = "y2",
                 inherit = FALSE) %>%
        
        layout(
          plot_bgcolor = "rgb(250,250,250)",
          xaxis = list(title = "", domain = c(0,0.95),
                       rangeslider = list(visible = F),
                       rangeselector = rangeselectorlist),
          yaxis = list(domain = c(0.22, 0.9)),
          yaxis2 = list(domain = c(0, 0.18), side = "right"),
          showlegend = F,
          
          annotations = list(
            list(x = 0, y = 1, xanchor = "left", yanchor = "top",
                 xref = "paper", yref = "paper",
                 text = paste0("<b>", input$stock_enter_1, "</b>"),
                 font = list(size = 30, family = "serif"),
                 showarrow = FALSE),
            
            list(x = 0.8, y = 0.95, xanchor = "left", yanchor = "top",
                 xref = "paper", yref = "paper",
                 text = paste0("[", paste(range(df$dates),collapse = " / "), "]"),
                 font = list(size = 15, family = "serif"),
                 showarrow = FALSE),
            
            list(x = 0, y = 0.18, xanchor = "left", yanchor = "top",
                 xref = "paper", yref = "paper",
                 text = paste0("<b>MACD (12, 26, 9)</b>"),
                 font = list(size = 15, family = "serif"),
                 showarrow = FALSE)
          )
        )
    })
    output$dygraph <- renderDygraph({
      Basic.Plot(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2]
      )
    })
    output$dygraph.week <- renderDygraph({
      Basic.Plot.Week(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2]
      )
    })
    output$dygraph.month <- renderDygraph({
      Basic.Plot.Month(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2]
      )
    })
    output$dygraph.signal <- renderDygraph({
      BS.Algo.Chart(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2],
        c.buy = input$constant[1],
        c.sell = input$constant[2],
        height = 0.005, #input$signal.height,
        past.n.days = input$past.n.days+300,
        test.new.price = input$test.new.price)
    })
    output$table_enter_1 <- renderTable({
      BS.Algo(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2],
        c.buy = input$constant[1],
        c.sell = input$constant[2],
        height = 0.005, #input$signal.height,
        past.n.days = input$past.n.days-1,
        test.new.price = input$test.new.price)
    })
    output$table_enter_1_BS_Dist <- renderTable({
      BS.Dist(
        x = require_symbol(input$stock_enter_1),
        r_day_plot = input$percentage[1],
        end_day_plot = input$percentage[2],
        c.buy = input$constant[1],
        c.sell = input$constant[2],
        height = 0.005, #input$signal.height,
        test.new.price = 0)
      })
    output$pi.sim.plot <- renderPlot({
      piR.plot(input$n.sim)
    })
    }
)

############################## END SCRIPT ###############################
