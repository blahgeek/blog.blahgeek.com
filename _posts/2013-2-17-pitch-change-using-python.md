---
permalink: yong-pythonba-zhou-jie-lun-bian-wei-zhou-jie-lun.html
classification: tech
layout: post
title: 用Python把周杰伦变为周婕纶
tags: python numpy wave jay song
---

> 其实即：用Python调整音频音高...本人在半小时前才从Google那里学到了什么是快速傅立叶变换，还请大神多多指教..

虽然音频之前网上流传过，不过作为技术宅当然要自己动手制造女神啦。

准备材料：

- 周杰伦-甜甜的.wav
- Python

过程很简单，就是把整个声音波形的频率变高，但是直接改变频率会导致歌曲长度变短。
因此需要先通过快速傅立叶变换，改变其每个分量的频率后再合成回去。这里使用Numpy中的fft模块做快速傅立叶变换。

首先读入音频文件，把每个声道数据转换为整型数组。

```
wav = wave.open(sys.argv[1])
datatype = numpy.dtype('<i' + str(wav.getsampwidth()))  # Little endian
raw_data = numpy.fromstring(wav.readframes(wav.getnframes()), datatype)
channels_data = [raw_data[i::wav.getnchannels()] for i in xrange(wav.getnchannels())]

```
对于每一串数据，进行变换后将其频率增加1.25倍，然后变回。
这个过程纯属我自己瞎想出来的，应该存在更好的方法。

```
def tune(data):
    fft_data = numpy.fft.rfft(data)
    new_fft = [fft_data[round(i/1.25)] for i in xrange(len(fft_data))]
    return numpy.fft.irfft(new_fft)

```
对于每个声道的数据，将其分割成很多个片段调用上述函数。
测试的结果大概是每0.125秒分割一块效果较好。

```
def tuneChannel(data):
    ret = []
    chunksize = wav.getframerate() / 8
    for i in xrange(0, len(data), chunksize):
        chunk = data[i:i+chunksize]
        ret += list(tune(chunk))
    return ret

```
最后把整型数组转换为二进制数据，合并声道，写入新的音频文件。

```
final_data = []
for j in xrange(len(channels_data[0])):
    for i in xrange(len(channels_data)):
        final_data += [channels_data[i][j]]
final_data = numpy.array(final_data, dtype=datatype).tostring()

new_wav = wave.open('out.wav', 'w')
new_wav.setparams(wav.getparams())
new_wav.writeframes(final_data)
new_wav.close()

```
最后的最后...享受自己制造的女神的声音吧！（屌丝自备纸巾...）
[点此试听](/files/jay-tiantiande-mod.mp3)（已转换为MP3）

PS:20分钟写出来的快糙猛代码在运行速度上还能优化很多，
比如很多操作直接调用numpy函数等等。

> UPDATE:用mplayer直接播放时调整的方法：`mplayer -af scaletempo=speed=pitch -speed 1.25 xxx.mp3` (via @ppwwyyxx)

