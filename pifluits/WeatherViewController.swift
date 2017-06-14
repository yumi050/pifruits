//
//  WeatherViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/27.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Alamofire


class WeatherViewController: UIViewController {
  
  
  @IBOutlet var weatherLabel: UILabel!
  
  @IBOutlet var weatherImage: UIImageView!
  

  
  // APIリクエストや、レスポンスデータを利用するためのクラスのインスタンス
  let dataManager = WeatherDataManager()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.dataManager.delegate = self  //????
    
    // ここでAPIリクエストを行う
    self.dataManager.dataRequest()
    
//    checkWeather()
//    print("hogehoge")
    
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.dataManager.weather()
  }
  
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Functions
  func checkWeather() {
    // お天気APIの返却値によって画像を変更する条件式
    if dataManager.weatherData?.weather == "Clouds" {
      // 曇
      print(dataManager.weatherData?.weather)
      weatherLabel.text = "cloud"
//      weatherImage.image = UIImage(named: "cloud")
    } else if dataManager.weatherData?.weather == "Clear" {
      // 晴れ
      print(dataManager.weatherData?.weather)
      weatherLabel.text = "clear"
//      weatherImage.image = UIImage(named: "sunny")
    } else if dataManager.weatherData?.weather == "Rain" {
      // 雨
      print(dataManager.weatherData?.weather)
      weatherLabel.text = "rain"
//      weatherImage.image = UIImage(named: "rain")
    } else{
      print(dataManager.weatherData?.weather)
      print("その他")
    }
    
    // 気温ラベルに気温をセット
//    tempLabel.text = dataManager.weatherData?.temp.description
    
    print("in!in!in!") //関数が実行されているかの確認
  }
  
 
  
  @IBAction func checkButtonTapped(_ sender: Any) {
    
     //お天気APIの返却値によって画像を変更する条件式
            if dataManager.weatherData?.weather == "Clouds" {
                // 曇
                weatherLabel.text = "cloud"
                weatherImage.image = UIImage(named: "cloudy-3.png")
            } else if dataManager.weatherData?.weather == "Clear" {
                // 晴れ
                weatherLabel.text = "clear"
                weatherImage.image = UIImage(named: "sunny.png")
            } else if dataManager.weatherData?.weather == "Rain" {
                // 雨
                weatherLabel.text = "rain"
                weatherImage.image = UIImage(named: "rainy-2.png")
            }
    
            // ボタンを隠す
//            self.checkButton.isHidden = true
    
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
