//
//  FirebaseViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/29.
//  Copyright © 2017年 yumiH. All rights reserved.
//


//Firebaseのデータを読み出す動作確認：練習用ファイル

import UIKit
import FirebaseDatabase

class FirebaseViewController: UIViewController {
  
  

  @IBOutlet weak var dataLabel: UILabel!
  
  @IBOutlet weak var soilMoistureLabel: UILabel!
  
  @IBOutlet weak var uvLabel: UILabel!
  
  @IBOutlet weak var temperatureLabel: UILabel!
  
  @IBOutlet weak var moistureLabel: UILabel!
  
  @IBOutlet weak var uvIndexLabel: UILabel!
  

  var ref:DatabaseReference?
  var databaseHandle:DatabaseHandle?
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
        getLatestData()
        getSoilMoistureData()
        getUVIndexData()
        getTempHumidData()
      
    }
  
  
    //Firebaseから最新の値のみを読み出す
    func getLatestData() {
      //Set the firebase reference
      ref = Database.database().reference()
      //Retrieve the posts and listen for changes
      databaseHandle = ref?.child("test").observe(.childAdded, with: { (snapshot) in
        //code to execute when a child is added under "test"
        //take the value from snapshot
        //Try to convert the value of the data to a string
        if let postedData = snapshot.value as? String {
          self.dataLabel.text = postedData
          print(postedData)
        }
        
      })

    }
  
  //土壌水分量の値を取得し、ラベルに表示する
  func getSoilMoistureData() {
    //Set the firebase reference
    ref = Database.database().reference()
    databaseHandle = ref?.child("soil_moisture").observe(.childAdded, with: { (snapshot) in
      //取得した値を格納する配列
      var soilMoistures: [Double] = []
      var times: [String] = []
      
      for childSnap in  snapshot.children.allObjects {
        let snap = childSnap as! DataSnapshot //型キャスト
        if let snapshotValue = snapshot.value as? NSDictionary {
          //土壌水分量の値のみをsoilMoisturesの配列にappendし、最新の値のみをラベルに表示
          if snap.key == "soil_moisture" {
            let snapVal = snapshotValue[snap.key]
            soilMoistures.append(snapVal as! Double)
            
            self.soilMoistureLabel.text = String(describing: soilMoistures.last!) + " %"
//            print(soilMoistures)
          //計測時間をtimesの配列にappend
          }else if snap.key == "time"{
            let snapVal = snapshotValue[snap.key]
            times.append(snapVal as! String)
            
//            self.uvLabel.text = times.last!
//            print(times)
            
          }
        }
      }
    })
  }
  
  
  //UV indexの値を取得し、ラベルに表示する
  func getUVIndexData() {
    //Set the firebase reference
    ref = Database.database().reference()
    databaseHandle = ref?.child("UV index").observe(.childAdded, with: { (snapshot) in
      //取得した値を格納する配列
      var uvIndexes: [Double] = []
      var times: [String] = []
      
      for childSnap in  snapshot.children.allObjects {
        let snap = childSnap as! DataSnapshot
        if let snapshotValue = snapshot.value as? NSDictionary {
          //UVIndexの値のみをuvIndexesの配列にappendし、最新の値のみをラベルに表示
          if snap.key == "UV index" {
            let snapVal = snapshotValue[snap.key]
            uvIndexes.append(snapVal as! Double)
            
            self.uvLabel.text = String(describing: uvIndexes.last!)
            
            switch uvIndexes.last! {
              
            case 0...2:
              self.uvIndexLabel.text = "UV Index: Weak"
            case 3...5:
              self.uvIndexLabel.text = "UV Index: Moderate"
            case 6...7:
              self.uvIndexLabel.text = "UV Index: High"
            case 8...10:
              self.uvIndexLabel.text = "UV Index: Very High"
            case 11...100:
              self.uvIndexLabel.text = "UV Index: Extreme"
            default:
              print("other")
            }
            
//            print(uvIndexes)
          //計測時間をtimesの配列にappend
          }else if snap.key == "time"{
            let snapVal = snapshotValue[snap.key]
            times.append(snapVal as! String)
            
//            self.uvLabel.text = times.last!
//            print(times)
            
          }
        }
      }
    })
  }
  
  
  //TemperatureとHumidityの値を取得し、ラベルに表示する
  func getTempHumidData() {
    //Set the firebase reference
    ref = Database.database().reference()
    databaseHandle = ref?.child("Temp_Hum_Pres").observe(.childAdded, with: { (snapshot) in
      //取得した値を格納する配列
      var temps: [String] = []
      var humids: [String] = []
      var pressures: [String] = []
      var times: [String] = []
      
      for childSnap in  snapshot.children.allObjects {
        let snap = childSnap as! DataSnapshot
        if let snapshotValue = snapshot.value as? NSDictionary {
          //気温の値のみをtempsの配列にappendし、最新の値のみをラベルに表示
          if snap.key == "temp" {
            let snapVal = snapshotValue[snap.key]
            temps.append(snapVal as! String)
            
            self.temperatureLabel.text = temps.last! + " ℃"
            print(temps)
          //湿度の値のみをhumidsの配列にappendし、最新の値のみをラベルに表示
          }else if snap.key == "humidity" {
            let snapVal = snapshotValue[snap.key]
            humids.append(snapVal as! String)
            
            self.moistureLabel.text = humids.last! + " %"
            print(temps)
          //気圧の値のみをpressuresの配列にappendし、最新の値のみをラベルに表示
          }else if snap.key == "pressure" {
            let snapVal = snapshotValue[snap.key]
            pressures.append(snapVal as! String)
            
//            self.dataLabel.text = pressures.last!
//            print(temps)
            
          //計測時間をtimesの配列にappend
          }else if snap.key == "time"{
            let snapVal = snapshotValue[snap.key]
            times.append(snapVal as! String)
            
//           self.moistureLabel.text = times.last!
//           print(times)
            
          }
        }
      }
    })
  }
  
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    //Set the firebase reference
    ref = Database.database().reference()
    //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
    ref?.removeAllObservers()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
