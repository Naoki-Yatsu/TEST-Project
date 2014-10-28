#
# ========================================================
#    相関計算
# ========================================================


# 月ごとの平均を計算



USDJPY["2014-01::"]

ccf(USDJPY, EURUSD)


USDJPY["USD.JPY"]
EURUSD

cl(USDJPY)

ccf(drop(USDJPY), drop(EURUSD))

ccf(drop(USDJPY), drop(Cl(N225)))
ccf(drop(Cl(DOW)), drop(Cl(N225)))


acf(drop(USDJPY))
ccf(drop(USDJPY), drop(USDJPY), plot=FALSE)

acf(drop(USDJPY))
acf(drop(fxdata.xts))

# Endpoint
endpoints(fxdata.xts, on ="seconds" )

# 一定期間ごとに集計
fxdata.xts.sec <- period.apply(fxdata.xts, INDEX = endpoints(fxdata.xts, on ="seconds" ), FUN = last)
fxdata.xts.min <- period.apply(fxdata.xts, INDEX = endpoints(fxdata.xts, on ="minutes" ), FUN = last)

acf(drop(fxdata.xts.min))


head(to.minutes(fxdata.xts))

head(fxdata["time"], 5)
head(fxdata.xts)





last(c(1,2,3,2))



Cl(N225)


library(quantmod)
getSymbols("SPY;IEF")
ccf(Cl(SPY),Cl(IEF))  # error
ccf(drop(Cl(SPY)),drop(Cl(IEF)))
