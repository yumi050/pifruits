//
//  FirebaseManager.swift
//  pifluits
//
//  Created by NanashimaHideyuki on 2017/06/10.
//  Copyright © 2017 yumiH. All rights reserved.
//


import Foundation
import FirebaseDatabase

//firebaseから最新の値、及びグラフ表示用のデータ配列を取得するクラス
class FirebaseManager {
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

  
    //土壌水分量：firebaseの最新の値のみを返す関数
    func getSoilMoistureData(completion: ((Double) -> Void)?) {
      
      //取得した値を格納する配列
      var soilMoistures: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("soil_moisture").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
        
        if let soilMoisture = snapshot.value as? NSDictionary {
          if let soilMoistureData = soilMoisture["soil_moisture"] as? Double {
            soilMoistures.append(soilMoistureData/2)
          }
        }
        print(soilMoistures.last!)
        completion?(soilMoistures.last!)
      })
    }
  
  
    //UVIndex:firebaseの最新の値のみを返す関数
    func getUVIndexData(completion: ((String) -> Void)?) {
      
        //取得した値を格納する配列
        var uvIndexes: [Double] = []
      
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("UV index").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
          
          if let uvIndex = snapshot.value as? NSDictionary {
            if let uvData = uvIndex["UV index"] as? Double {
              uvIndexes.append(uvData)
            }
          }
          completion?(String(describing: uvIndexes.last!))
        })
    }
  
  
    //Temperature: firebaseの最新の値のみを返す関数
    func getTemperatureData(completion: ((String) -> Void)?) {
      
      //取得した値を格納する配列
      var temps: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
        
        if let temp = snapshot.value as? NSDictionary {
          if let tempData = temp["temp"] as? Double {
            temps.append(tempData)
          }
        }
        
//        for childSnap in  snapshot.children.allObjects {
//          let snap = childSnap as! DataSnapshot
//          if let snapshotValue = snapshot.value as? NSDictionary {
//            //気温の値のみをtempsの配列にappendし、最新の値のみをラベルに表示
//            if snap.key == "temp" {
//              let snapVal = snapshotValue[snap.key]
//              temps.append(snapVal as! Double)
//              
//            //気圧の値のみをpressuresの配列にappendし、最新の値のみをラベルに表示
////            }else if snap.key == "pressure" {
////              let snapVal = snapshotValue[snap.key]
////              pressures.append(snapVal as! Double)
//            }
//          }
//        }
        completion?(String(describing: temps.last!))
      })
    }
  
  
    //Humidity: firebaseの最新の値のみを返す関数
    func getHumidityData(completion: ((String) -> Void)?) {
      
      //取得した値を格納する配列
      var humids: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
        
        if let humid = snapshot.value as? NSDictionary {
          if let humidData = humid["humidity"] as? Double {
            humids.append(humidData)
          }
        }
        print(humids)
        completion?(String(describing: humids.last!))
      })
    }

  
    //土壌水分量：グラフ表示用の配列（96：1日分のデータ）を返す関数
    func getSoilMoistureDataForGraph(completion: (([Double]) -> Void)?) {
      //取得した値を格納する配列
      var soilMoisturesArray: [Double] = []
      var soilMoistures: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("soil_moisture").queryLimited(toLast: 96).observe(.childAdded, with: { (snapshot) in
        
        if let soilMoisture = snapshot.value as? NSDictionary {
          if let soilMoistureData = soilMoisture["soil_moisture"] as? Double {
            soilMoisturesArray.append(soilMoistureData/2)
            soilMoistures = soilMoisturesArray.reversed()
          }
        }
        print(soilMoistures)
        completion?(soilMoistures)
      })
    }

  
    //UVIndex: グラフ表示用の配列（96：1日分のデータ）を返す関数
    func getUVIndexDataForGraph(completion: (([Double]) -> Void)?) {
      
//      var count = 0
      //取得した値を格納する配列
      var uvIndexesArray: [Double] = []
      var uvIndexes: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("UV index").queryLimited(toLast: 96).observe(.childAdded, with: { (snapshot) in
        
        if let uvIndex = snapshot.value as? NSDictionary {
          if let uvIndexValue = uvIndex["UV index"] as? Double {
            uvIndexesArray.append(uvIndexValue)
            uvIndexes = uvIndexesArray.reversed()
          }
        }
//        count = count + 1
//        print("count: \(snapshot.children.allObjects.count)")
//        print("count: \(snapshot.children.allObjects[0])")
//        print("count: \(snapshot.children.allObjects[1])")
//        
//        for childSnap in snapshot.children.allObjects {
//          let snap = childSnap as! DataSnapshot
//          if let snapshotValue = snapshot.value as? NSDictionary {
//            //UVIndexの値のみをuvIndexesの配列にappend
//            if snap.key == "UV index" {
//              let snapVal = (snapshotValue[snap.key] as! Double)
//              uvIndexes.append(snapVal)
//            }
//          }
//        }
//        print("loop count: \(count)")
        print(uvIndexes)
        completion?(uvIndexes)
      })
    }

  
    //Temperature: グラフ表示用の配列（96：1日分のデータ）を返す関数
    func getTemperatureDataForGraph(completion: (([Double]) -> Void)?) {
      //取得した値を格納する配列
      var tempsArray: [Double] = []
      var temps: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 96).observe(.childAdded, with: { (snapshot) in
        
        if let temp = snapshot.value as? NSDictionary {
          if let tempData = temp["temp"] as? Double {
            //気温の値をtempsの配列にappendし、、新しい値が先頭にくる配列に作り変える
            tempsArray.append(tempData)
            temps = tempsArray.reversed()
          }
        }
        print(temps)
        completion?(temps)
      })
    }

  
    //Humidity: グラフ表示用の配列（96：1日分のデータ）を返す関数
    func getHumidityDataForGraph(completion: (([Double]) -> Void)?) {
      //取得した値を格納する配列
      var humidsArray: [Double] = [] //古い順から配列に追加される
      var humids: [Double] = [] //新しい順から配列に追加（グラフ表示用）
      
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 96).observe(.childAdded, with: { (snapshot) in
        
        if let humid = snapshot.value as? NSDictionary {
          if let humidData = humid["humidity"] as? Double {
            //湿度の値をtempsの配列にappendし、新しい値が先頭にくる配列に作り変える
            humidsArray.append(humidData)
            humids = humidsArray.reversed()
          }
        }
        print(humids)
        completion?(humids)
      })
    }

    func removeAllObservers() {
      //Set the firebase reference
      ref = Database.database().reference()
      //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除しておく
      ref?.removeAllObservers()
    }
  
  
}//class FirebaseManager
