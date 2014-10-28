#
# ========================================================
#    フーリエ変換テスト
# ========================================================

# フーリエ変換テスト
x <- 100
f <- 1:x
hz <- 1:( x/2 )
t <- seq( 0.01, 1.00,  1 / length( f ) )

# 4Hzの正弦波
data_waveA <- sin( 2 * pi * t * 4 )

# 18Hzの余弦波
data_waveB <- cos( 2 * pi * t * 18 )

# 上記2つの合成波
data_waveC <- data_waveA + data_waveB


# これらの波を描きます。
par( "mfrow" = c( 3, 1 ) )
plot( t, data_waveA, type="l" )
plot( t, data_waveB, type="l" )
plot( t, data_waveC, type="l" )


# 高速フーリエ変換を行ないます。
data_freqA <- fft( data_waveA - mean( data_waveA ) )
data_freqB <- fft( data_waveB - mean( data_waveB ) )
data_freqC <- fft( data_waveC - mean( data_waveC ) )
data_freqD <- fft( data_waveA )



変換結果を表示します。
par( "mfrow" = c( 3, 1 ) )
plot( hz, abs( data_freqA[ hz ] ), type="l" )
plot( hz, abs( data_freqB[ hz ] ), type="l" )
plot( hz, abs( data_freqC[ hz ] ), type="l" )
plot( hz, abs( data_freqD[ hz ] ), type="l" )



