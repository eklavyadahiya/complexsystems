set.seed(29)

# Loading packages --------------------------------------------------------

library(ggplot2)
library(randtests)
library(tseries)
library(ecp)

# Loading dataset ---------------------------------------------------------

#Loading dataset produced by NetLogo and selecting right timeframe
df <- read.csv('wolf_sheep_grass_unstable.csv', skip = 23, col.names = c('', 'time', 'sheep', 'wolves', 'grass'))
df[,1] <- NULL
df <- df[23000:28000,]

#Plotting the selected timeframe in the dataset
ggplot(data = df, aes(x = time)) + 
  scale_colour_hue() +
  geom_line(aes(y = sheep, color = 'Sheep')) +
  geom_line(aes(y = wolves, color = 'Wolves')) +
  geom_line(aes(y = grass, color = 'Grass')) +
  xlab('Time') +
  ylab('Count') +
  ggtitle('Regime shift in predator-prey dataset')


# Memory ------------------------------------------------------------------

#Performing Bartels-Rank tests against non-randomness
sheep_bartels_rank <- bartels.rank.test(df$sheep, alternative = "two.sided")
wolves_bartels_rank <- bartels.rank.test(df$wolves, alternative = "two.sided")
grass_bartels_rank <- bartels.rank.test(df$grass, alternative = "two.sided")

#Calculate Partial Autocorrelation & length of timeseries
sheep_pacf <- pacf(df$sheep, lag.max = 900, main = 'Sheep Partial Autocorrelation Plot')
N <-length(df$sheep)  
#Number of values passing two-tailed Z-test treshold
sheep_memory_values <- length(which(abs(sheep_pacf$acf) > (2 / sqrt(N))))
#Max lag for long-term memory
sheep_max_lag <- max(which(abs(sheep_pacf$acf) > (2 / sqrt(N))))

#Show number of lags & maximum lag
sheep_memory_values
sheep_max_lag

#Repeat process
wolves_pacf <- pacf(df$wolves, lag.max = 900, main = 'Wolves Partial Autocorrelation Plot')
N <-length(df$wolves)  
wolves_memory_values <- length(which(abs(wolves_pacf$acf) > (2 / sqrt(N))))
wolves_max_lag <- max(which(abs(wolves_pacf$acf) > (2 / sqrt(N))))

wolves_memory_values
wolves_max_lag

grass_pacf <- pacf(df$grass, lag.max = 900, main = 'Grass Partial Autocorrelation Plot')
N <-length(df$grass)  
grass_memory_values <- length(which(abs(grass_pacf$acf) > (2 / sqrt(N))))
grass_max_lag <- max(which(abs(grass_pacf$acf) > (2 / sqrt(N))))

grass_memory_values
grass_max_lag


# Regime shift ------------------------------------------------------------

#KPSS test for trend stationarity -> shows non-stationarity
sheep_kpss <- kpss.test(df$sheep, null = 'Trend')
wolves_kpss <- kpss.test(df$wolves, null = 'Trend')
grass_kpss <- kpss.test(df$grass, null = 'Trend')

#Detrending time-series
df_2 <- data.frame(rep(NA, 4999))
df_2$detrend_sheep <- NA
df_2$detrend_wolves <- NA
df_2$detrend_grass <- NA
df_2[,1] <- NULL

df_2$detrend_sheep <- diff(x = df$sheep, lag = 1, differences = 2)
df_2$detrend_wolves <- diff(x = df$wolves, lag = 1, differences = 2)
df_2$detrend_grass <- diff(x = df$grass, lag = 1, differences = 2)
colnames(df_2) <- c('Detrended Sheep Values', 'Detrended Wolves Values', 'Detrended Grass Values')


# Change Point Analysis (CPA) ---------------------------------------------

#Creation variables for change point analysis (CPA)
list <- c('sheep', 'wolves', 'grass')
e.out <- list()
df.e <- df_2[1,]
df.e[1,] <- rep(NA, 3)

#Running CPA on 3 timeseries
for (k in 1:3){
  ts <- matrix(na.exclude(df_2[,k]))
  e.out[[k]] <- e.divisive(ts, R=500, sig.lvl = 0.05)
  df.e[,k] <- length(which(e.out[[k]]$p.values < 0.05))
}

#Plots
for(cl in (1:length(e.out))){
  plot(as.ts(df_2[,cl]), main=(colnames(df_2)[cl]), ylab = 'Value')
  abline(v=e.out[[cl]]$estimates,col="blue")  
}

#Change Point Estimates
for (i in 1:3){
  print(colnames(df_2)[i])
  print(e.out[[i]]$estimates)
}
