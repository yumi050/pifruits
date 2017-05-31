//
//  HomeViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
  //今日の日付を表示するラベル
  @IBOutlet var dateLabel: UILabel!
  //今日の天気を表示するラベル
  @IBOutlet var weatherLabel: UILabel!
  //登録した植物の画像を表示するラベル（データベース？）
  @IBOutlet var iconLabel: UIImageView!
  //植物の状態を表示するラベル
  @IBOutlet var statusLabel: UILabel!
  
  

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //今日の日付を表示させる関数
  func getNowClockString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let now = Date()
    
    return formatter.string(from:now)
    
  }
  
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
