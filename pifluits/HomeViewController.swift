//
//  HomeViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class HomeViewController: UIViewController {
  
  //植物名を表示するラベル（UserDefaultsに登録した"plantName"）
  @IBOutlet weak var plantNameLabel: UILabel!
  //今日の日付を表示するラベル
  @IBOutlet var dateLabel: UILabel!
  //今日の天気を表示するラベル
  @IBOutlet var weatherLabel: UILabel!
  //登録した植物の画像を表示するラベル（データベース？）
  @IBOutlet var iconLabel: UIImageView!
  //植物の状態を表示するラベル
  @IBOutlet var statusLabel: UILabel!
  
  
  //土壌水分量を表示するラベル
  @IBOutlet weak var soilMoistureLabel: UILabel!
  //UV指数を表示するラベル
  @IBOutlet weak var uvLabel: UILabel!
  //温度を表示するラベル
  @IBOutlet weak var temperatureLabel: UILabel!
  //湿度を表示するラベル
  @IBOutlet weak var moistureLabel: UILabel!
  
  
  //UserDefaultsのインスタンス生成
  let userDefaults: UserDefaults = UserDefaults.standard
  
  //天気API(openweathermap)のURL
  var urlString = "http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=c03dbd8a937565924a9b9257b70aa918"  //Tokyo: 1850147
  

    override func viewDidLoad() {
        super.viewDidLoad()
        //東京の天気を表示
//        getWeather()
        //今日の日付を表示
        dateLabel.text = getNowClockString()
        //植物の状態を表示
        statusLabel.text = getStatus()
        statusLabel.numberOfLines = 0 //表示可能最大行数=0
        statusLabel.sizeToFit() //contentsのサイズに合わせてobujectのサイズを変える
        //可愛いフォントを使用
      
        //土壌水分量:最新の値を取得し、ラベルに表示する
        getSoilMoistureData()
        //UVIndex:最新の値を取得し、ラベルに表示する
        getUVIndexData()
        //Temperature:最新の値を取得し、ラベルに表示する
        getTemperatureData()
        //Humidity:最新の値を取得し、ラベルに表示する
        getHumidityData()
      
      

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //植物名をラベルに表示させる
        plantNameLabel.text = readSavedData()
        //imageViewにUserDefaultsに登録した画像を表示する
        iconLabel.image = readSavedPictureData()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  //植物名をUserDefaultsから読み出す関数
  func readSavedData() -> String {
    // Keyを"plantName"として指定して読み込み
    let plantName: String = userDefaults.string(forKey: "plantName") ?? "clover"
    
//    let PlantName: String = userDefaults.object(forKey: "plantName") as! String
    
    return plantName
  }
  
  
  //UserDefaultsに登録した画像を呼び出す関数
  func readSavedPictureData() -> UIImage {
    let imageData:Data? = userDefaults.object(forKey:"plantIcon") as? Data
    if let imageData = imageData {
        return UIImage(data:imageData)!
    } else {
        return UIImage(named: "ok.png")!
    }
  }
  
  
  //今日の日付を表示させる関数
  func getNowClockString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy. MM. dd"
    let now = Date()
    
    return formatter.string(from:now)
  }
  
  
  //東京の天気を表示させる関数
//  func getWeather() {
//    let url = URL(string: self.urlString)!
//    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//      if error == nil {
//        do {
//          // リソースの取得が終わると、ここに書いた処理が実行される
//          let json = try JSON(data: data!)
//          // 各セルに情報を突っ込む
//          for i in 0 ..< 3 {
//            let dt_txt = json["list"][i]["dt_txt"]
//            let weatherMain = json["list"][i]["weather"][0]["main"]
//            let weatherDescription = json["list"][i]["weather"][0]["description"]
//            let info = "\(dt_txt), \(weatherMain), \(weatherDescription)"
//            print(info)
//            self.weatherLabel.text = info
//          }
////          self.view.reloadData()
//          
//        } catch let jsonError {
//          print(jsonError.localizedDescription)
//        }
//      }
//    }
//    
//    task.resume()
//    
//  }
  
  
  
  
  //植物の状態を表示させる関数
  func getStatus () -> String {
    var status: String
    let soilMoistrue = 20
    let temperature = 25
    let moisture = 20
    let sunLight = 20
    
    if (soilMoistrue >= 70 && sunLight >= 50) {
      if (temperature >= 25 && moisture >= 30) {
        status = "Healthy"
      }else{
        status = "Healthy but it's Hot..."
      }
      
    }else if (soilMoistrue >= 50 && sunLight >= 40) {
      if (temperature >= 25 && moisture >= 30) {
        status = "Need Water"
      }else{
        status = "Need Water and it's Hot..."
      }
      
    }else if (soilMoistrue >= 30 && sunLight >= 30) {
      if (temperature >= 25 && moisture >= 30) {
        status = "Thirsty..."
      }else{
        status = "Hot and Thirsty..."
      }
      
    }else{
      status = "Dying...\n need water and sunlight!"
    }

    return status
    
  }
  
  //土壌水分量:最新の値を取得し、ラベルに表示する関数
  func getSoilMoistureData() {
    
    let firebaseManager = FirebaseManager()
    firebaseManager.getSoilMoistureData(completion: {
      text in
      self.soilMoistureLabel.text = text
    })
  }
  
  
  //UVIndex:最新の値を取得し、ラベルに表示する関数
  func getUVIndexData() {
    
    let firebaseManager = FirebaseManager()
    firebaseManager.getUVIndexData(completion: {
      text in
      self.uvLabel.text = text
    })
  }
  
  
  //Temperature:最新の値を取得し、ラベルに表示する関数
  func getTemperatureData() {
    
    let firebaseManager = FirebaseManager()
    firebaseManager.getTemperatureData(completion: {
      text in
      self.temperatureLabel.text = text
    })
  }
  
  
  //Humidity:最新の値を取得し、ラベルに表示する関数
  func getHumidityData() {
    
    let firebaseManager = FirebaseManager()
    firebaseManager.getHumidityData(completion: {
      text in
      self.moistureLabel.text = text
    })
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    let firebaseManager = FirebaseManager()
    //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
    firebaseManager.removeAllObservers()
    
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
