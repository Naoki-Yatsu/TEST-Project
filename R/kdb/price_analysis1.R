

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




# ========================================================
#    分析
# ========================================================

# Continue Up 3 periods











