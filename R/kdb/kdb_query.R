
# load q server
source("c:/r/qServer.R")
Sys.setenv(TZ="GMT")

# milisec
options(digits.secs=3)

# Open connection
hostip <- "192.168.10.212"

# Open
h5011 <- open_connection(hostip,5011,":")
h5012 <- open_connection(hostip,5012,":")
h5013 <- open_connection(hostip,5013,":")
h     <- open_connection(hostip,5015,":")

# Close
close_connection(h)

# Query
execute(h, "tables[]")
execute(h, "100#select from MarketData where date=2014.01.02")

res <- 

query <- "`time xasc select time:`timestamp$marketDateTime, price:bid from MarketData where date=2014.01.10, sym=`USDJPY"
query <- "getOHLCTick[dates; symbol; 100]"

fxdata <- execute(h, query)

require(quantmod)

fxdata.xts <-xts(fxdata[,-1], order.by=fxdata[,'time'])
candlecolors <- ifelse(fxdata.xts[,'close'] > fxdata.xts[,'open'], 'GREEN', 'RED')
plot.xts(fxdata.xts, type='candles', width=100,candle.col=candlecolors,bar.col ='BLACK',xlab="time",ylab="price",main="TEST")

par(xaxt="n")
plot.xts(fxdata.xts, type='candles', width=100,candle.col=candlecolors,bar.col ='BLACK',xlab="time",ylab="price",main="TEST")
par(xaxt="s")
axis.POSIXct(side=1, x=index(fxdata.xts), format="%Y-%m-%d %H:%M")
axis.POSIXct(side=1, x=index(fxdata.xts), format="%H:%M")

chartSeries(fxdata.xts)


# ========================================================
#    xts でグラフを書く
# ========================================================

require(quantmod)

# extract the HLOC buckets in 5 minute intervals
res <- execute(h, "getOHLC[dates; symbol]")
res <- execute(h, "getOHLCTick[2014.05.01 2014.05.02; symbol; 100]")


￼# create an xts object from the returned data frame
# order on the time column
res.xts <-xts(res[,-1], order.by=res[,'time'])

￼# create a vector of colours for the graph
# based on the relative open and close prices
candlecolors <- ifelse(res.xts[,'close'] > res.xts[,'open'], 'GREEN', 'RED')

￼￼￼￼￼# display the candle graph with approrpiate labels
plot.xts(res.xts,type='candles',width=100,candle.col=candlecolors,bar.col ='BLACK',xlab="time",ylab="price",main="TEST")


# Change X Axis
par(xaxt="n")
plot.xts(res.xts,type='candles',width=100,candle.col=candlecolors,bar.col ='BLACK',xlab="time",ylab="price",main="TEST")
par(xaxt="s")
axis.POSIXct(side=1, x=index(res.xts), format="%Y-%m-%d %H:%M")



# ========================================================
#    quantmod でグラフを書く
# ========================================================

library(quantmod)

# extract the last closing price in 30 second buckets
res<-execute(h,"select close:last price by time:0D00:00:30 xbar date+time from trade where date=2014.01.14,sym=`GOOG,time within 09:30 16:00")

# create the closing price xts object
closes <-xts(res[,-1], order.by=res[,'time'])

# create xts object
resxts <- XXX

# chart it. Add Bollinger Bands to the main graph
# add additional Relative Strength Indicator and Rate Of Change graphs
chartSeries(resxts)
addSMA(100)
addEMA(20, col="blue")

zooom()
zoomChart()


chartSeries(closes,theme=chartTheme("white"),TA=c(addBBands(),addTA(RSI( closes)),addTA(ROC(closes))))


# ========================================================
#    knitr
# ========================================================

(s = system.file("examples", "knitr-spin.R", package = "knitr"))
spin(s)

res <- execute(h, "plReport[]")

ggplot(res, aes(x=timestamp, y=midPrice)) + geom_line()

ggplot(res, aes(x=timestamp, y=plJpy)) + geom_line()








