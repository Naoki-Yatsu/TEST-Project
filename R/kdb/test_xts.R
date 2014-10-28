#
# ========================================================
#    xtsテスト
# ========================================================

library(xts)
data(sample_matrix)
#その名の通り行列形式でデータが入っている
head(sample_matrix)

#xtsオブジェクトへ！
sample.xts <- as.xts(sample_matrix, descr='テストデータです')
#zooパッケージのクラスとxtsクラスの属性を持っているようだ
class(sample.xts)
str(sample.xts)

#headを使うとdescrの属性の値は見えないので、無理やりだしてみる。
head(sample.xts) 
attr(sample.xts,'descr')

#いろいろなデータの抜き方
#2007年全部（このデータだともともと2007年のデータしかないが・・・
sample.xts['2007']
#2007年3月1日以降のデータ
sample.xts['2007-03::']
#2007年3月1日～2007年4月30日までのデータ（ちょっと不思議な挙動）
sample.xts['2007-03::2007-04']
#こう書くと2007年3月1日～2007年4月1日までのデータ
sample.xts['2007-03::2007-04-01']
#データの最初っから2007年1月31日まで
sample.xts['::2007-01-31'] 
#2007年1月3日のデータだけ
sample.xts['2007-01-03']




#月末がどのインデックスになるのか？を抜いてくる関数。超便利。
#'on'オプションで指定すれば年、週、日、秒等等もいける。
index.monthlast <- endpoints(sample.xts)
#月末だけのデータを取得
sample.xts[index.monthlast]

#period.～関数群。↑のendpoints関数とあわせて使うと強力
#期間を指定して、その範囲内でmax,min,sum,などを計算する。period.applyを使えば自作関数も。
#各月ごとの1列目の値の和
period.sum(sample.xts[,1],endpoints(sample.xts))
#各月ごとの1列目の値の最大値
period.max(sample.xts[,1],endpoints(sample.xts))
#period.applyで上と同じ動作を
period.apply(sample.xts[,1],endpoints(sample.xts),function(x_){max(x_)})

#さらに、各日・月・週・四半期・年ごとに処理をapplyしちゃう関数群もある。
#要するに上の関数をさらにendpointsなしに圧縮して書くことができる。
#各月ごとの１列目の最大値
apply.monthly(sample.xts[,1],max)
#各週ごとの１列目の平均値
apply.weekly(sample.xts[,1],mean)

#Rにデフォルトで入っていてもよさそうな、データの初めの要素と終わりの要素を抜く関数もあった
#いちいちhead(x,1)みたいに書くのめんどいよね。
first(sample.xts)
last(sample.xts)

#データが何日・年・四半期分あるか。
ndays(sample.xts)
nyears(sample.xts)
nquarters(sample.xts)


# ========================================================
#    xtsテスト2
# ========================================================

library(xts)
#前回同様、サンプル行列で試す
data(sample_matrix)
sample.xts <- as.xts(sample_matrix)

#lag関数を使えば日付を１日ずらすことができる。
lag(sample.xts)
#例えばリターンを計算したいなら以下のようにすればOK
sample.xts/lag(sample.xts)-1

#↓記事１では以下のように月末時のデータを抜いたが、もうちょっと汎用的な関数があった
#index.monthlast <- endpoints(sample.xts)
#sample.xts[index.monthlast]
#月末だけのデータを取得。
#ここで注意したいのがOLHC（Open,Low,High,Close)データだと、月単位でOHLCを計算してくれること
to.monthly(sample.xts)
#週次も同様で週ごとでOLHCしてくれる
to.weekly(sample.xts)
to.period(sample.xts,period="weeks")

#日付型を作る関数firstof lastof.
#2000年初日を作成
firstof(2000)
#2007年10月末を作成
lastof(2007,10)

#データの日時のみを抽出するにはindex関数を使う.この状態で日次の変更もできる
index(sample.xts)
index(sample.xts)[1] <- as.POSIXct("2010-01-01 11:11:11")
head(sample.xts)
#日時の型を調べる
indexClass(sample.xts)

#mergeでデータ合体できる
x <- xts(4:10, Sys.Date()+4:10)
y <- xts(1:6, Sys.Date()+1:6)
#SQLでいうインナージョインやレフト・ライトジョインも可能
merge(x,y)
merge(x,y, join='inner')
merge(x,y, join='left')
merge(x,y, join='right')
#mergeは列で結合するが、rbindだと行ごとに結合
rbind(x,y)

#欠損値を補間する関数もある。zooパッケージの関数na.locfをさらにgenericに。
#以下マニュアルより。
x <- xts(1:10, Sys.Date()+1:10)
x[c(1,2,5,9,10)] <- NA
x
#時系列的な意味でその値の直近値で値を補間
na.locf(x)
#↑の逆。次の日の値で今日の値を置くイメージ
na.locf(x, fromLast=TRUE)#


# ========================================================
#    ggplot version of charts.PerformanceSummary
# ========================================================
# http://stackoverflow.com/questions/14817006/ggplot-version-of-charts-performancesummary

# Before
require(xts)
X.stock.rtns <- xts(rnorm(1000,0.00001,0.0003), Sys.Date()-(1000:1))
Y.stock.rtns <- xts(rnorm(1000,0.00003,0.0004), Sys.Date()-(1000:1))
Z.stock.rtns <- xts(rnorm(1000,0.00005,0.0005), Sys.Date()-(1000:1))
rtn.obj <- merge(X.stock.rtns , Y.stock.rtns, Z.stock.rtns)
colnames(rtn.obj) <- c("x.stock.rtns","y.stock.rtns","z.stock.rtns")

require(PerformanceAnalytics)
charts.PerformanceSummary(rtn.obj, geometric=TRUE)


#
# first try
#
require(xts)

X.stock.rtns <- xts(rnorm(1000,0.00001,0.0003), Sys.Date()-(1000:1))
Y.stock.rtns <- xts(rnorm(1000,0.00003,0.0004), Sys.Date()-(1000:1))
Z.stock.rtns <- xts(rnorm(1000,0.00005,0.0005), Sys.Date()-(1000:1))
rtn.obj <- merge(X.stock.rtns , Y.stock.rtns, Z.stock.rtns)
colnames(rtn.obj) <- c("x","y","z")

# advanced charts.PerforanceSummary based on ggplot
gg.charts.PerformanceSummary <- function(rtn.obj, geometric = TRUE, main = "", plot = TRUE)
{
    
    # load libraries
    suppressPackageStartupMessages(require(ggplot2))
    suppressPackageStartupMessages(require(scales))
    suppressPackageStartupMessages(require(reshape))
    suppressPackageStartupMessages(require(PerformanceAnalytics))
    
    # create function to clean returns if having NAs in data
    clean.rtn.xts <- function(univ.rtn.xts.obj,na.replace=0){
        univ.rtn.xts.obj[is.na(univ.rtn.xts.obj)]<- na.replace
        univ.rtn.xts.obj  
    }
    
    # Create cumulative return function
    cum.rtn <- function(clean.xts.obj, g = TRUE)
    {
        x <- clean.xts.obj
        if(g == TRUE){y <- cumprod(x+1)-1} else {y <- cumsum(x)}
        y
    }
    
    # Create function to calculate drawdowns
    dd.xts <- function(clean.xts.obj, g = TRUE)
    {
        x <- clean.xts.obj
        if(g == TRUE){y <- Drawdowns(x)} else {y <- Drawdowns(x,geometric = FALSE)}
        y
    }
    
    # create a function to create a dataframe to be usable in ggplot to replicate charts.PerformanceSummary
    cps.df <- function(xts.obj,geometric)
    {
        x <- clean.rtn.xts(xts.obj)
        series.name <- colnames(xts.obj)[1]
        tmp <- cum.rtn(x,geometric)
        tmp$rtn <- x
        tmp$dd <- dd.xts(x,geometric)
        colnames(tmp) <- c("Index","Return","Drawdown") # names with space
        tmp.df <- as.data.frame(coredata(tmp))
        tmp.df$Date <- as.POSIXct(index(tmp))
        tmp.df.long <- melt(tmp.df,id.var="Date")
        tmp.df.long$asset <- rep(series.name,nrow(tmp.df.long))
        tmp.df.long
    }
    
    # A conditional statement altering the plot according to the number of assets
    if(ncol(rtn.obj)==1)
    {
        # using the cps.df function
        df <- cps.df(rtn.obj,geometric)
        # adding in a title string if need be
        if(main == ""){
            title.string <- paste("Asset Performance")
        } else {
            title.string <- main
        }
        
        gg.xts <- ggplot(df, aes_string( x = "Date", y = "value", group = "variable" )) +
            facet_grid(variable ~ ., scales = "free_y", space = "fixed") +
            geom_line(data = subset(df, variable == "Index")) +
            geom_bar(data = subset(df, variable == "Return"), stat = "identity") +
            geom_line(data = subset(df, variable == "Drawdown")) +
            geom_hline(yintercept = 0, size = 0.5, colour = "black") +
            ggtitle(title.string) +
            theme(axis.text.x = element_text(angle = 0, hjust = 1)) +
            scale_x_datetime(breaks = date_breaks("6 months"), labels = date_format("%m/%Y")) +
            ylab("") +
            xlab("")
        
    } 
    else 
    {
        # a few extra bits to deal with the added rtn columns
        no.of.assets <- ncol(rtn.obj)
        asset.names <- colnames(rtn.obj)
        df <- do.call(rbind,lapply(1:no.of.assets, function(x){cps.df(rtn.obj[,x],geometric)}))
        df$asset <- ordered(df$asset, levels=asset.names)
        if(main == ""){
            title.string <- paste("Asset",asset.names[1],asset.names[2],asset.names[3],"Performance")
        } else {
            title.string <- main
        }
        
        if(no.of.assets>5){legend.rows <- 5} else {legend.rows <- no.of.assets}
        
        gg.xts <- ggplot(df, aes_string(x = "Date", y = "value" )) +
            
            # panel layout
            facet_grid(variable~., scales = "free_y", space = "fixed", shrink = TRUE, drop = TRUE, margin = 
                           , labeller = label_value) + # label_value is default
            
            # display points for Index and Drawdown, but not for Return
            geom_point(data = subset(df, variable == c("Index","Drawdown"))
                       , aes(colour = factor(asset), shape = factor(asset)), size = 1.2, show_guide = TRUE) + 
            
            # manually select shape of geom_point
            scale_shape_manual(values = c(1,2,3)) + 
            
            # line colours for the Index
            geom_line(data = subset(df, variable == "Index"), aes(colour = factor(asset)), show_guide = FALSE) +
            
            # bar colours for the Return
            geom_bar(data = subset(df,variable == "Return"), stat = "identity"
                     , aes(fill = factor(asset), colour = factor(asset)), position = "dodge", show_guide = FALSE) +
            
            # line colours for the Drawdown
            geom_line(data = subset(df, variable == "Drawdown"), aes(colour = factor(asset)), show_guide = FALSE) +
            
            # horizontal line to indicate zero values
            geom_hline(yintercept = 0, size = 0.5, colour = "black") +
            
            # horizontal ticks
            scale_x_datetime(breaks = date_breaks("6 months"), labels = date_format("%m/%Y")) +
            
            # main y-axis title
            ylab("") +
            
            # main x-axis title
            xlab("") +
            
            # main chart title
            ggtitle(title.string)
        
        # legend 
        
        gglegend <- guide_legend(override.aes = list(size = 3))
        
        gg.xts <- gg.xts + guides(colour = gglegend, size = "none") +
            
            # gglegend <- guide_legend(override.aes = list(size = 3), direction = "horizontal") # direction overwritten by legend.box?
            # gg.xts <- gg.xts + guides(colour = gglegend, size = "none", shape = gglegend) + # Warning: "Duplicated override.aes is ignored"
            
            theme( legend.title = element_blank()
                   , legend.position = c(0,1)
                   , legend.justification = c(0,1)
                   , legend.background = element_rect()
                   , legend.box = "horizontal" # not working?
                   , axis.text.x = element_text(angle = 0, hjust = 1)
            )
        
    }
    
    assign("gg.xts", gg.xts,envir=.GlobalEnv)
    if(plot == TRUE){
        plot(gg.xts)
    } else {}
    
}

# display chart
gg.charts.PerformanceSummary(rtn.obj, geometric = TRUE)







