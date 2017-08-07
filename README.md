# Gardening Pi (旧：　pifruits)
### Description
このIoTとiOSを組み合わせたアプリは、「家庭菜園をする人向け」の、
植物を楽しく、効率よく、栽培するためのサポートアプリです。

IoT機器を植物のそばに置き、離れた場所からiPhoneで植物の状態を観察でき、自分の育てている植物と会話をするように成長が楽しめます！

#### IoT部分の詳細
<img src="https://github.com/yumi050/pifruits/blob/master/iotimage.png" width="200"/>
![IoT image](https://github.com/yumi050/pifruits/blob/master/iotimage.png =200)

###### 基盤：
* Raspberry Pi3 ModelB (OS:Raspbian)
* Arduino Uno

###### センサ、その他：
* 土壌水分センサ（SEN0114）
* 温湿度気圧センサ（BME280）
* 紫外線センサ（SI1145）
* 照度センサ（TSL2560）
* 電圧変換モジュール
* Pi Camera

#### iOSアプリの詳細
[アプリ紹介ページ ~ Gardening Pi ~ 植物と会話をしよう](https://yumi050.github.io/GardeningPi/)

## Movie_1 : Home画面, Chatting画面

<Home画面>
植物状態を簡易モニタリングできる

* 植物が今の状態を知らせてくる
* 写真で観察（定点カメラでの定期撮影）
* 各種センサの数値を観測

<Chatting画面>
チャットで植物と会話ができる

![Gardening Pi　ビデオ](https://github.com/yumi050/pifruits/blob/master/GardeningPi_1.gif)

## Movie_2 : Graph画面 （温度、湿度、土壌水分量）

<Graph画面>
各センサの測定値をおしゃれなグラフで観測できる

* 土壌水分量
* 温度
* 湿度
* 紫外線量

![Graphs(温度、湿度、土壌水分量)](https://github.com/yumi050/pifruits/blob/master/GardeningPi_2.gif)

## Movie_3 : Graph画面 （UV） & カメラ画面

<カメラ画面>
タイムラプス動画で成長記録がみられる

![Graph(UV) & タイムラプス動画](https://github.com/yumi050/pifruits/blob/master/GardeningPi_3.gif)

### 使用言語
* Swift 3.0.2
* Python 3.5.1
* Arduino言語

### Database
* Firebase

