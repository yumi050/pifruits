//
//  WeatherViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/27.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Alamofire


class WeatherViewController: UIViewController, WeatherDataManagerProtocol {
  
  
  @IBOutlet var weatherLabel: UILabel!
  
  @IBOutlet var weatherImage: UIImageView!
 
  // APIリクエストや、レスポンスデータを利用するためのクラスのインスタンス
  let dataManager = WeatherDataManager()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //WeatherDataManagerのデリゲートをViewController自身に設定
//    self.dataManager.delegate = self
    // ここでAPIリクエストを行う
    self.dataManager.dataRequest()
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)

  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @IBAction func checkButtonTapped(_ sender: Any) {
    
     //お天気APIの返却値によって画像を変更する条件式
//            if dataManager.weatherData?.weather == "Clouds" {
//                // 曇
//                weatherLabel.text = "cloud"
//                weatherImage.image = UIImage(named: "cloudy-3.png")
//            } else if dataManager.weatherData?.weather == "Clear" {
//                // 晴れ
//                weatherLabel.text = "clear"
//                weatherImage.image = UIImage(named: "sunny.png")
//            } else if dataManager.weatherData?.weather == "Rain" {
//                // 雨
//                weatherLabel.text = "rain"
//                weatherImage.image = UIImage(named: "rainy-2.png")
//            }
//
//            // ボタンを隠す
////            self.checkButton.isHidden = true
//    
  }
  
  func setWeather(data: WeatherDataModel) {
    // お天気APIの返却値によって画像を変更する条件式
    if data.weather == "Clouds" {
      // 曇
      print(data.weather)
      weatherLabel.text = "cloud"
      weatherImage.image = UIImage(named: "cloudy-3.png")
    } else if data.weather == "Clear" {
      // 晴れ
      print(data.weather)
      weatherLabel.text = "clear"
      weatherImage.image = UIImage(named: "sunny.png")
    } else if data.weather == "Rain" {
      // 雨
      print(data.weather)
      weatherLabel.text = "rain"
      weatherImage.image = UIImage(named: "rainy-2.png")
    } else{
      print(data.weather)
      print("その他")
    }
    
    print("in!in!in!") //関数が実行されているかの確認
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
