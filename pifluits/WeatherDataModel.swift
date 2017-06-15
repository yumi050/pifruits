//
//  WeatherDataModel.swift
//  pifluits
//
//  Created by yumiH on 2017/06/14.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import SwiftyJSON


class WeatherDataModel: NSObject {
  
  // 今日の天気（晴れ、雨etc）を格納するプロパティ
  var weather: String = ""
  
  // 気温を格納するプロパティ
  var temp: Int = 0
  
  //weatherDataManagerクラスから初期化される
  init?(data: JSON){
    
    //引数で渡ったJSONデータをここでパースする
    //パース：JSONデータをプロジェクト内で使えるようにする
    //今日の天気データを取得して変数に格納する
    self.weather = data["list"][0]["weather"][0]["main"].stringValue
//    self.temp = data["list"][0]["main"]["temp"].intValue
  }

}
