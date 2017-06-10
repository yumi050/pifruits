//
//  HomeViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
        //今日の日付を表示
        dateLabel.text = getNowClockString()
        //植物の状態を表示
        statusLabel.text = getStatus()
        statusLabel.numberOfLines = 0 //表示可能最大行数=0
        statusLabel.sizeToFit() //contentsのサイズに合わせてobujectのサイズを変える
        //可愛いフォントを使用
      

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
    let PlantName: String = userDefaults.object(forKey: "plantName") as! String
    
    return PlantName
  }
  
  
  //UserDefaultsに登録した画像を呼び出す関数
  func readSavedPictureData() -> UIImage {
    let imageData:Data = userDefaults.object(forKey:"plantIcon") as! Data
    let image = UIImage(data:imageData)
    
    return image!
  }
  
  
  //今日の日付を表示させる関数
  func getNowClockString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let now = Date()
    
    return formatter.string(from:now)
    
  }
  
  
  //東京の天気を表示させる関数
  
  
  
  
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
  
  
  
  
  
  
  
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
