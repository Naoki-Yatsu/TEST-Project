#
# ========================================================
#    オブジェクトテスト
# ========================================================

##########################################
############# iris（アヤメ）データはS3 ############
##########################################
#irisデータを読み込む
data(iris)

#irisデータはどんなクラスに属している?
class(iris)

#irisデータの構造を見てみる
str(iris)

#クラス属性
attributes(iris)

#各クラス属性にアクセス
attr(iris,"names")

#クラス属性を取り除いて、中身を全て見てみる
unclass(iris)

#S3からデータを取り出す時は"$"を使う
iris$Sepal.Length


#####################################################
##  graphパッケージのテストデータであるapopGraphはS4　##
#####################################################
#apopGraphデータを読み込む
library(graph)
data(apopGraph)

#apopGraphデータはどんなクラスに属している?
class(apopGraph)

#apopGraphデータの構造を見てみる
str(apopGraph)

#クラス属性
attributes(apopGraph)

#各クラス属性にアクセス
attr(apopGraph,"class")

#クラス属性を取り除いて、中身を全て見てみる
unclass(apopGraph)

#S4から各要素を取り出す時は"@"を使う
apopGraph@nodes

#$だとエラー（$はS3だから）
apopGraph$nodes

#################################################
## AnntationDbiパッケージのloadDb関数に読み込まれた ###
## データはR5になる ###########################
##########################################

#ライブラリ読み込み
library("AnnotationDbi")
library("RSQLite")

#試しにGO.dbのデータを読み込んでみる
data <- loadDb(
    system.file(
        "extdata",
        "GO.sqlite",
        package="GO.db",
        lib.loc="/Library/Frameworks/R.framework/Versions/2.15/Resources/library/"
    ),
    packageName="GO.db"
)

# Windowsの場合
data <- loadDb(
    system.file(
        "extdata",
        "GO.sqlite",
        package="GO.db",
        lib.loc="C:/Users/ユーザー名/Documents/R/win-library/2.15/"
    ),
    packageName="GO.db"
)

#dataはどんなクラスに属している?
class(data)

#dataの構造を見てみる
str(data)

#クラス属性
attributes(data)

#各クラス属性にアクセス
attr(data,"class")

#クラス属性を取り除いて、中身を全て見てみる
#R5はこの時に<S4 Type Object>って出てくるやつ
unclass(data)

#R5から各要素を取り出す時は"$"を使う
data$conn


#
#
# STEP2 簡単なクラスを作って、継承したオブジェクトを生成してみる
#
#

##########################################
################## S3の場合 #################
##########################################

#3つのオブジェクトをリストで定義
taro <- list(name="Taro",grade=4,sex="Male", programming=T)
jiro <- list(name="Jiro",grade=3,sex="Male", programming=F)
hanako <- list(name="Hanako",grade=1,sex="Female", programming=T)


#studentというクラスに属しているという事を後付けで定義（ここがS3が駄目だと言われているところ）
class(taro) <- "student"
class(jiro) <- "student"
class(hanako) <- "student"

#これから使うprintは汎用関数printを使ったものだと宣言
#この行は無くても走る
print <- function(object){
    UseMethod("print")
}

#出力メソッドを定義（S3の場合はprint関数）
print.student <- function(object){
    cat("This Student's name is",object$name,"\n",
        object$name,"'s grade is",object$grade,"\n",
        object$name,"'s sex is",object$sex,"\n")
    if(object$programming){
        cat(object$name,"loves programming!!!\n")
    }else{
        cat(object$name,"does not love programming....\n")
    }
}

#studentクラスが実際にメソッドを持っている事を確認
methods(,"student")

#3つのオブジェクトがstudentクラスを実際に継承しているか確認
inherits(taro,"student")
inherits(jiro,"student")
inherits(hanako,"student")

##########################################
################## S4の場合 #################
##########################################

#まずstudentクラスを定義
#ここで値の型や自分でチェック項目を設定できるから、継承時に間違った値を入力するとエラーを出す。
setClass("student",
         
         #フィールド
         representation(
             name="character",
             grade="numeric",
             sex="character",
             programming="logical"
         ),
         
         #初期値(コンストラクタ)
         prototype=prototype(
             name="John Doe",
             grade=1,
             sex="Male",
             programming=TRUE
         ),
         
         #チェック項目
         validity=function(object){
             (nchar(object@name) >1)&&
                 ((object@grade >= 1)&&(object@grade <= 4))&&
                 ((object@sex=="Male")||(object@sex=="Female"))&&
                 ((object@programming==TRUE)||
                      (object@programming==FALSE))
         }
)

#試しに何もパラメーターを与えずオブジェクト生成
#John Doe(初期値）が出現
test <- new("student")
test

#これから使うshowは汎用関数showを使ったものだと宣言
#この行は無くても走る
setGeneric("show",
           function(object) {
               standardGeneric("show")
           }
)


#出力メソッドを定義
setMethod("show","student",
          function(object){
              cat("This Student's name is",object@name,"\n",
                  object@name,"'s grade is",object@grade,"\n",
                  object@name,"'s sex is",object@sex,"\n")
              if(object@programming){
                  cat(object@name,"loves programming!!!\n")
              }else{
                  cat(object@name,"does not love programming....\n")
              }
          }
)

#クラスを継承した3つのオブジェクトを生成
taro <- new("student",name="Taro",
            grade=4,sex="Male",programming=T)
jiro <- new("student",name="Jiro",
            grade=3,sex="Male",programming=F)
hanako <- new("student",name="Hanako",
              grade=1,sex="Female",programming=T)


#3つのオブジェクトがstudentクラスを実際に継承しているか確認
inherits(taro,"student")
inherits(jiro,"student")
inherits(hanako,"student")

#間違ったパラメーターを与えて、オブジェクト生成すると、エラーを出してくれる
kazuo <- new("student",name="Kazuo",grade=5,
             sex="Male",programming=F)

##########################################
################## R5の場合 #################
##########################################

#studentクラスを定義 (Javaっぽい）
st <- setRefClass(
    
    #クラス名を定義
    Class = "student",
    
    #フィールドを定義
    fields=list(
        name="character",
        grade="numeric",
        sex="character",
        programming="logical"
    ),    
    
    #メソッドを定義
    methods = list(
        
        #出力メソッド
        output = function(){
            cat("This Student's name is",name,"\n",
                name,"'s grade is",grade,"\n",
                name,"'s sex is",sex,"\n")
            if(programming){
                cat(name,"loves programming!!!\n")
            }else{
                cat(name,"does not love programming....\n")
            }
        }
    )
)

#クラスを継承した3つのオブジェクトを生成
taro <- st$new(name="Taro", grade=4, sex="Male", programming=TRUE)
jiro <- st$new(name="Jiro", grade=3, sex="Male", programming=FALSE)
hanako <- st$new(name="Hanako", grade=1, sex="Female", programming=TRUE)


#出力してみる
taro$output()
jiro$output()
hanako$output()


#3つのオブジェクトがstudentクラスを実際に継承しているか確認
inherits(taro,"student")
inherits(jiro,"student")
inherits(hanako,"student")


