############################## FIRST PLOT #############################################################
#The first plot with the null value and the proposed true value
x <- seq(-35,35,.001) #set up for plotting the curve
y <- dnorm(x,0,8.1) #y values for plotting curve
plot(x=x,y=y, main="Type-S and Type-M error example", xlab="Estimated effect size", 
     ylab="Relative frequency", type="l", cex.lab=1.5, axes=F, col="white")
axis(1,at=seq(-30,30,10),pos=0) #make the axis nice
axis(2,at=seq(0,.05,.01),pos=-35,las=1) #make the axis nice
lines(c(0,0),c(0,.05),col="red",lwd=3) ##Add line at null value
lines(c(2,2),c(0,.05),col="blue",lwd=3) ##Add line at population mean
points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##Add sample mean

############################# SECOND AND THIRD PLOT ####################################################
##The second and third plots with the null sampling distribution and significance areas under the curve
x <- seq(-35,35,.001) #set up for plotting the curve
y <- dnorm(x,0,8.1) #y values for plotting curve
plot(x,y, main="Type-S and Type-M error example", xlab="Estimated effect size",
     ylab= "Relative frequency", type="l",cex.lab=1.5, las=1, lwd=3, axes = F)
axis(1,at=seq(-30,30,10),pos=0) #make the x axis nice
axis(2,at=seq(0,.05,.01),pos=-35,las=1) #make the y axis nice

lines(c(0,0),c(0,dnorm(0,0,8.1)),col="red",lwd=3) ##adds null line
lines(c(2,2),c(0,dnorm(2,0,8.1)),col="blue",lwd=3) ##adds true pop mean line
points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##adds sample mean

##Adds shaded area
cord.x <- c(-35, seq(-35,-15.9,.01),-15.9) ##set up for shading
cord.y <- c(0,dnorm(seq(-35,-15.9,.01),0,8.1),0) ##set up for shading
polygon(cord.x,cord.y,col='red') ##shade left tail
cord.xx <- c(35, seq(35,15.9,-.01),15.9) 
cord.yy <- c(0,dnorm(seq(35,15.9,-.01),0,8.1),0)
polygon(cord.xx,cord.yy,col='red') ##shade right tail
points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##replots the sample mean over the shading

########################## FOURTH PLOT ##############################################################
##The fourth plot with the alternative sampling distribution and significance areas under the curve
x <- seq(-35,35,.001) #set up for plotting the curve
y <- dnorm(x,2,8.1) #y values for plotting curve
plot(x,y, main="Type-S and Type-M error example", xlab="Estimated effect size",
     ylab= "Relative frequency", type="l", cex.lab=1.5, las=1, lwd=3, axes = F)
axis(1,at=seq(-30,30,10),pos=0) #make the x axis nice
axis(2,at=seq(0,.05,.01),pos=-35, las=1) #make the y axis nice

lines(c(0,0),c(0,dnorm(0,2,8.1)),col="red",lwd=3) ##add vertical line at null value
lines(c(2,2),c(0,dnorm(2,2,8.1)),col="blue",lwd=3) ##add vertical line at population mean

cord.x <- c(-35, seq(-35,-15.9,.01),-15.9) ##set up for shading
cord.y <- c(0,dnorm(seq(-35,-15.9,.01),2,8.1),0) ##set up for shading
polygon(cord.x,cord.y,col='red') ##shade left tail
cord.xx <- c(35, seq(35,15.9,-.01),15.9) 
cord.yy <- c(0,dnorm(seq(35,15.9,-.01),2,8.1),0)
polygon(cord.xx,cord.yy,col='red') ##shade right tail
points(17, .001, pch=23, bg="grey",col="black", cex=1.5) ##replots sample mean over shading



######################## GIF ###############################################################

# Library
library(animation)

## Plot Monte Carlo Simulation of Pi
saveGIF({
  #The first plot with the null value and the proposed true value
  x <- seq(-35,35,.001) #set up for plotting the curve
  y <- dnorm(x,0,8.1) #y values for plotting curve
  plot(x=x,y=y, main="Type-S and Type-M error example", xlab="Estimated effect size", 
       ylab="Relative frequency", type="l", cex.lab=1.5, axes=F, col="white")
  axis(1,at=seq(-30,30,10),pos=0) #make the axis nice
  axis(2,at=seq(0,.05,.01),pos=-35,las=1) #make the axis nice
  lines(c(0,0),c(0,.05),col="red",lwd=3) ##Add line at null value
  lines(c(2,2),c(0,.05),col="blue",lwd=3) ##Add line at population mean
  points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##Add sample mean
  
  ##The second and third plots with the null sampling distribution and significance areas under the curve
  x <- seq(-35,35,.001) #set up for plotting the curve
  y <- dnorm(x,0,8.1) #y values for plotting curve
  plot(x,y, main="Type-S and Type-M error example", xlab="Estimated effect size",
       ylab= "Relative frequency", type="l",cex.lab=1.5, las=1, lwd=3, axes = F)
  axis(1,at=seq(-30,30,10),pos=0) #make the x axis nice
  axis(2,at=seq(0,.05,.01),pos=-35,las=1) #make the y axis nice
  
  lines(c(0,0),c(0,dnorm(0,0,8.1)),col="red",lwd=3) ##adds null line
  lines(c(2,2),c(0,dnorm(2,0,8.1)),col="blue",lwd=3) ##adds true pop mean line
  points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##adds sample mean
  
  ##Adds shaded area
  cord.x <- c(-35, seq(-35,-15.9,.01),-15.9) ##set up for shading
  cord.y <- c(0,dnorm(seq(-35,-15.9,.01),0,8.1),0) ##set up for shading
  polygon(cord.x,cord.y,col='red') ##shade left tail
  cord.xx <- c(35, seq(35,15.9,-.01),15.9) 
  cord.yy <- c(0,dnorm(seq(35,15.9,-.01),0,8.1),0)
  polygon(cord.xx,cord.yy,col='red') ##shade right tail
  points(17, .001, pch=23, bg="grey",col="black",cex=1.5) ##replots the sample mean over the shading
  
  ##The fourth plot with the alternative sampling distribution and significance areas under the curve
  x <- seq(-35,35,.001) #set up for plotting the curve
  y <- dnorm(x,2,8.1) #y values for plotting curve
  plot(x,y, main="Type-S and Type-M error example", xlab="Estimated effect size",
       ylab= "Relative frequency", type="l", cex.lab=1.5, las=1, lwd=3, axes = F)
  axis(1,at=seq(-30,30,10),pos=0) #make the x axis nice
  axis(2,at=seq(0,.05,.01),pos=-35, las=1) #make the y axis nice
  
  lines(c(0,0),c(0,dnorm(0,2,8.1)),col="red",lwd=3) ##add vertical line at null value
  lines(c(2,2),c(0,dnorm(2,2,8.1)),col="blue",lwd=3) ##add vertical line at population mean
  
  cord.x <- c(-35, seq(-35,-15.9,.01),-15.9) ##set up for shading
  cord.y <- c(0,dnorm(seq(-35,-15.9,.01),2,8.1),0) ##set up for shading
  polygon(cord.x,cord.y,col='red') ##shade left tail
  cord.xx <- c(35, seq(35,15.9,-.01),15.9) 
  cord.yy <- c(0,dnorm(seq(35,15.9,-.01),2,8.1),0)
  polygon(cord.xx,cord.yy,col='red') ##shade right tail
  points(17, .001, pch=23, bg="grey",col="black", cex=1.5) ##replots sample mean over shading
}, movie.name = "type-m-type-s.gif", interval = 0.8, nmax = 30, 
ani.width = 480)
