//
//  HomeViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SwiftyJSON
import NVActivityIndicatorView

class HomeViewController: UIViewController, WeatherDataManagerProtocol {
  
  
  @IBOutlet weak var cameraImage: UIImageView!
 
  
    //植物名を表示するラベル（UserDefaultsに登録した"plantName"）
    @IBOutlet weak var plantNameLabel: UILabel!
    //今日の日付を表示するラベル
    @IBOutlet var dateLabel: UILabel!
    //今日の天気の画像を表示する
    @IBOutlet weak var weatherImage: UIImageView!
    //登録した植物の画像を表示する
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
    
    // APIリクエストや、レスポンスデータを利用するためのクラスのインスタンス
    let dataManager = WeatherDataManager()
    
    var gotSoilMoistureData = false
    var gotUVIndexData = false
    var gotTemperatureData = false
    var gotHumidityData = false
    var storage:Storage? = nil
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //ストレージ サービスへの参照を取得
      
      //URLを取得し、imageのURLを参照
      if let imageURL = getImageUrl() {
        //ストレージ サービスへの参照を取得
        //gs://pifruits-5d32b.appspot.com/images/image.jpg
        storage = Storage.storage(url:getStorageUrl()!)
        let storageRef = storage!.reference(forURL: imageURL)
        
        //Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
          if (error != nil) {
            // Uh-oh, an error occurred!
            print("error")
          } else {
            // Data for "images/island.jpg" is returned
            let piCameraImage: UIImage! = UIImage(data: data!)
            self.cameraImage.image = piCameraImage
            print("image download")
            
          }
        }
      }
      
      
        //東京の天気を表示
        //WeatherDataManagerのデリゲートをViewController自身に設定
        self.dataManager.delegate = self
        // ここでAPIリクエストを行う
        self.dataManager.dataRequest()
        
        //今日の日付を表示
        dateLabel.text = getNowClockString()
        
        //植物の状態を表示
        statusLabel.text = ""
        
        //可愛いフォントを使用
        statusLabel.font = UIFont(name: "07LogoTypeGothic7", size: 21 )
      
        //画像を正円にする
//        let iconLabelWidth = iconLabel.bounds.size.width
//        iconLabel.clipsToBounds = true
//        iconLabel.layer.cornerRadius = iconLabelWidth / 2
      
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
        
        //土壌水分量:最新の値を取得し、ラベルに表示する　& 水分量に応じて、植物の状態をstatusLabelに表示する
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
        let plantName: String = userDefaults.string(forKey: "plantName") ?? "Alice"
        
        return plantName
    }
    
    
    //UserDefaultsに登録した画像を呼び出す関数
    func readSavedPictureData() -> UIImage {
        let imageData:Data? = userDefaults.object(forKey:"plantIcon") as? Data
        if let imageData = imageData {
            return UIImage(data:imageData)!
        } else {
            return UIImage(named: "red_plants2.jpg")!
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
    func setWeather(data: WeatherDataModel) {
        // お天気APIの返却値によって画像を変更する条件式
        if data.weather == "Clouds" {
            // 曇
            weatherImage.image = UIImage(named: "cloud.png")
            //      print(data.weather)
        } else if data.weather == "Clear" {
            // 晴れ
            weatherImage.image = UIImage(named: "sun.png")
            //      print(data.weather)
        } else if data.weather == "Rain" {
            // 雨
            weatherImage.image = UIImage(named: "umbrella.png")
            //      print(data.weather)
        } else{
            //      weatherImage.image = UIImage(named: "")
            //      print(data.weather)
            print("その他")
        }
        
    }
    
    
    //土壌水分量:最新の値を取得し、ラベルに表示する関数 & 水分量に応じて、植物の状態をstatusLabelに表示する
    func getSoilMoistureData() {
        
        var status = ""
        
        let firebaseManager = FirebaseManager()
        firebaseManager.getSoilMoistureData(completion: {
            humidity in
            
            if (humidity >= 100) {
                status = "お腹いっぱだよ！\nお水はたりてるよ！"
                self.statusLabel.text = status
                self.soilMoistureLabel.text = "100"
                print("お腹いっぱだよ！\nお水はたりてるよ！")
            }else if (humidity >= 80) {
                status = "今日は元気いっぱい！\n潤ってます ^o^"
                self.statusLabel.text = status
                self.soilMoistureLabel.text = String(humidity)
                print("今日は元気いっぱい！\n潤ってます ^ ^")
            }else if (humidity >= 50) {
                status = "今日も調子がいいよ！ \nお水はまだあるよ！"
                self.statusLabel.text = status
                self.soilMoistureLabel.text = String(humidity)
                print("今日も調子がいいよ！ \nお水はまだあるよ！")
            }else if (humidity >= 30) {
                status = "潤いがたりないわ＞＜ \nそろそろお水が欲しいな〜！"
                self.statusLabel.text = status
                self.soilMoistureLabel.text = String(humidity)
                print("潤いがたりないわ＞＜ \nそろそろお水が欲しいな〜！")
            }else {
                status = "のどが渇いたよ。。。\n今すぐお水が飲みたいよ〜\n＞＜"
                self.statusLabel.text = status
                self.soilMoistureLabel.text = String(humidity)
                print("のどが渇いたよ。。。\n今すぐお水が飲みたいよ〜\n＞＜")
            }
            
            self.gotSoilMoistureData = true
            if self.gotAllData() == true {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
        })
    }
    
    
    //UVIndex:最新の値を取得し、ラベルに表示する関数
    func getUVIndexData() {
        
        let firebaseManager = FirebaseManager()
        firebaseManager.getUVIndexData(completion: {
            text in
            self.uvLabel.text = text
            
            self.gotUVIndexData = true
            if self.gotAllData() == true {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }

        })
    }
    
    
    //Temperature:最新の値を取得し、ラベルに表示する関数
    func getTemperatureData() {
        
        let firebaseManager = FirebaseManager()
        firebaseManager.getTemperatureData(completion: {
            text in
            self.temperatureLabel.text = text
            
            self.gotTemperatureData = true
            if self.gotAllData() == true {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }

        })
    }
    
    
    //Humidity:最新の値を取得し、ラベルに表示する関数
    func getHumidityData() {
        
        let firebaseManager = FirebaseManager()
        firebaseManager.getHumidityData(completion: {
            text in
            self.moistureLabel.text = text
            
            self.gotHumidityData = true
            if self.gotAllData() == true {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }

        })
    }
    
    func gotAllData() -> Bool {
        return gotSoilMoistureData && gotUVIndexData && gotHumidityData && gotTemperatureData
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let firebaseManager = FirebaseManager()
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
        firebaseManager.removeAllObservers()
    }
  
  
    //GoogleService-InfoからstorageのimageURLを取得
    private func getImageUrl() -> String? {
      guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
        return nil
      }
      
      let configurations = NSDictionary(contentsOfFile: path)
      return configurations?.object(forKey: "IMAGE_STORAGE_URL") as? String
    }
  
  private func getStorageUrl() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      return nil
    }
    
    let configurations = NSDictionary(contentsOfFile: path)
    return configurations?.object(forKey: "STORAGE_URL") as? String
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
