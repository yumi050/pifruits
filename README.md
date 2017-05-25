# (仮アプリ名) pifruits


## Description(アプリの詳細)

**IOT機器（raspberry pi/Arduino）と連携した植物管理アプリ（iOS)**

    - 鉢植えに設置した各種センサの値をiOSアプリを通じて把握することで、植物の育成状況を管理できるアプリ
    - 複数人で一つの植物の状況を管理できるアプリ　（グループチャット機能）



## Features(実現したいアプリ機能)

1. センサの値を取得し、アプリ画面上にグラフ表示する
    - temperature
    - humidity
    - Soil Moisture (土壌水分)
    - UV light


2. センサの値が基準を逸脱した場合、チャット機能で通知が送られる
    - temperature (５℃以下、26℃以上でアラート：低温、高温)
    - humidity （70%以上でアラート:多湿）
    - Soil Moisture (150以下でアラート？：水分不足)
    - UV light （６以上でアラート：　6.7=high, 8~10=very high, +11=extreme）


3. 複数人でグループチャットができる
    - ５人以下でグループチャットを可能にし、水やり担当などの連絡を取り合う


4. （可能であれば）プランタに設置したカメラ(picamera)の映像をアプリ画面で確認できる
    - 遠隔で植物の状態を確認できるようにする
    
## Application Details（アプリ画面について）

1. 必須作成画面
    - タブバー１： Home :現在の植物の管理状況が一目でわかる画面
        - Healthy, not enough water等の表示
        - ４種類のセンサの値と図を表示
        - その日の天気、温湿度の表示（天気APIから取得？）
        
    - タブバー2： Chat 〜 センサの値による自動アラートを受信する、複数人でのチャットができる画面
    - タブバー3： Graph　〜 4種類のグラフをタブ切り替えでそれぞれ表示
    
    
2. 可能であれば作成する画面
    - login/sign up画面
    - 植物の名前、アイコン登録画面
    - グループメンバー追加画面
    - タブバー4： Camera　〜picameraの映像を１０秒/回　程度画面に表示
    
## Requirement

- Requirement
- Requirement
- Requirement


## Usage

1. Usage
2. Usage
3. Usage


## Installation

    $ git clone https://github.com/......


## Anything Else

AnythingAnythingAnything
AnythingAnythingAnything
AnythingAnythingAnything


## Author

[yumi050](https://............)

