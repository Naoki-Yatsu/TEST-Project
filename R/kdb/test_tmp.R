
#
# 軸の変更
#
par(xaxt="n")
plot( dat[,c("DATE")],dat[,c("PRICE")],type="l")
par(xaxt="s")
axis.Date(1,at=seq(min(dat[,c("DATE")]),max(dat[,c("DATE")]),"months"),format="%m/%d")



"%Y-%m-%d %H:%M:%S"

format(Sys.time(), "%Y-%m-%d %H:%M:%OS3")
