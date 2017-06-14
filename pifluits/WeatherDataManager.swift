//
//  WeatherDataManager.swift
//  pifluits
//
//  Created by yumiH on 2017/06/14.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WeatherDataManagerProtocol {
  func setWeather(data: WeatherDataModel);
}

// AlamofireによるAPI通信を管理
class WeatherDataManager: NSObject {
  
  
  // レスポンスデータをパースするモデルクラスのインスタンスを格納すプロパティ
//  var weatherData: WeatherDataModel?
  
  var delegate: WeatherViewController?
  
  // リクエストするurl
  let url = "http://api.openweathermap.org/data/2.5/forecast?units=metric&q=Tokyo&APPID=c03dbd8a937565924a9b9257b70aa918"
//  let url = "http://api.openweathermap.org/data/2.5/forecast?id=1850147&APPID=c03dbd8a937565924a9b9257b70aa918" //Tokyo: 1850147

  
  // APIリクエストを実行する
  func dataRequest() {
    
    // AlamofireによるAPI通信
    Alamofire.request(url).responseJSON { response in
      switch response.result {
        
      case .success(let value):
        // 通信成功時の処理
        // レスポンスデータをJSON型に変換する
        // これはSwiftyJSONのルール
        let json = JSON(value)
        // JSONデータを引数に渡してモデルクラスのインスタンスを生成
        
        if let data = WeatherDataModel(data: json) {
          self.delegate?.setWeather(data: data)
        }
        // デバッグ用のログ出力を行う
        print(value)
        
      case .failure(let error):
        // 通信失敗時の処理
        // ログ出力だけ
        print(error)
      }
    }
    
  }
  //あっているか不明？？？
//  func weather() {
//    delegate?.checkWeather()
//  }
  
  
}
