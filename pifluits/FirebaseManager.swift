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
    func getSoilMoistureData(completion: ((String) -> Void)?) {
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("soil_moisture").queryLimited(toLast: 192).observe(.childAdded, with: { (snapshot) in
            //取得した値を格納する配列
            var soilMoistures: [Double] = []
            
            for childSnap in  snapshot.children.allObjects {
                let snap = childSnap as! DataSnapshot //型キャスト
                if let snapshotValue = snapshot.value as? NSDictionary {
                    //土壌水分量の値のみをsoilMoisturesの配列にappendし、最新の値のみをラベルに表示
                    if snap.key == "soil_moisture" {
                        let snapVal = snapshotValue[snap.key]
                        soilMoistures.append(snapVal as! Double)
                        
                        completion?(String(describing: soilMoistures.last!) + "  %")
                    }
                }
            }
        })
    }
  
  
    //UVIndex:firebaseの最新の値のみを返す関数
    func getUVIndexData(completion: ((String) -> Void)?) {
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("UV index").queryLimited(toLast: 192).observe(.childAdded, with: { (snapshot) in
            //取得した値を格納する配列
            var uvIndexes: [Double] = []
            
            for childSnap in  snapshot.children.allObjects {
                let snap = childSnap as! DataSnapshot
                if let snapshotValue = snapshot.value as? NSDictionary {
                    //UVIndexの値のみをuvIndexesの配列にappendし、最新の値のみをラベルに表示
                    if snap.key == "UV index" {
                        let snapVal = (snapshotValue[snap.key] as! Double)
                        uvIndexes.append(snapVal)
                    }
                }
            }
          completion?("UVIndex: " + String(describing: uvIndexes.last!))
        })
    }
  
  
    //Temperature: firebaseの最新の値のみを返す関数
    func getTemperatureData(completion: ((String) -> Void)?) {
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        var temps: [Double] = []
//        var pressures: [Double] = []
        
        for childSnap in  snapshot.children.allObjects {
          let snap = childSnap as! DataSnapshot
          if let snapshotValue = snapshot.value as? NSDictionary {
            //気温の値のみをtempsの配列にappendし、最新の値のみをラベルに表示
            if snap.key == "temp" {
              let snapVal = snapshotValue[snap.key]
              temps.append(snapVal as! Double)
              
            //気圧の値のみをpressuresの配列にappendし、最新の値のみをラベルに表示
//            }else if snap.key == "pressure" {
//              let snapVal = snapshotValue[snap.key]
//              pressures.append(snapVal as! Double)
            }
          }
        }
        completion?(String(describing: temps.last!) + " ℃")
      })
    }
  
  
    //Humidity: firebaseの最新の値のみを返す関数
    func getHumidityData(completion: ((String) -> Void)?) {
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        var humids: [Double] = []
        
        for childSnap in  snapshot.children.allObjects {
          let snap = childSnap as! DataSnapshot
          if let snapshotValue = snapshot.value as? NSDictionary {
  
            //湿度の値のみをhumidsの配列にappendし、最新の値のみをラベルに表示
            if snap.key == "humidity" {
              let snapVal = snapshotValue[snap.key]
              humids.append(snapVal as! Double)
            }
          }
        }
        completion?(String(describing: humids.last!) + " %")
      })
    }

  
    //土壌水分量：グラフ表示用の配列（192：二日分のデータ）を返す関数
    func getSoilMoistureDataForGraph(completion: (([Double]) -> Void)?) {
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("soil_moisture").queryLimited(toLast: 192).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        var soilMoistures: [Double] = []
        
        for childSnap in  snapshot.children.allObjects {
          let snap = childSnap as! DataSnapshot //型キャスト
          if let snapshotValue = snapshot.value as? NSDictionary {
            //土壌水分量の値のみをsoilMoisturesの配列にappendし、最新の値のみをラベルに表示
            if snap.key == "soil_moisture" {
              let snapVal = snapshotValue[snap.key]
              soilMoistures.append(snapVal as! Double)
              
              completion?(soilMoistures)
            }
          }
        }
      })
    }

  
    //UVIndex: グラフ表示用の配列（192：二日分のデータ）を返す関数
    func getUVIndexDataForGraph(completion: (([Double]) -> Void)?) {
      
      var count = 0
      var uvIndexes: [Double] = []
      
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("UV index").queryLimited(toLast: 192).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        
        if let uvIndex = snapshot.value as? NSDictionary {
          if let uvIndexValue = uvIndex["UV index"] as? Double {
            uvIndexes.append(uvIndexValue)
          }
        }
        
//        
//        
//        count = count + 1
//        print("count: \(snapshot.children.allObjects.count)")
//        print("count: \(snapshot.children.allObjects[0])")
//        print("count: \(snapshot.children.allObjects[1])")
//        
//        for childSnap in snapshot.children.allObjects {
//          let snap = childSnap as! DataSnapshot
//          if let snapshotValue = snapshot.value as? NSDictionary {
//            //UVIndexの値のみをuvIndexesの配列にappendし、最新の値のみをラベルに表示
//            if snap.key == "UV index" {
//              let snapVal = (snapshotValue[snap.key] as! Double)
//              uvIndexes.append(snapVal)
//            }
//          }
//        }
//        print("loop count: \(count)")
        completion?(uvIndexes)
      })
    }

  
    //Temperature: グラフ表示用の配列（192：二日分のデータ）を返す関数
    func getTemperatureDataForGraph(completion: (([Double]) -> Void)?) {
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        var temps: [Double] = []
        
        for childSnap in  snapshot.children.allObjects {
          let snap = childSnap as! DataSnapshot
          if let snapshotValue = snapshot.value as? NSDictionary {
            
            //気温の値のみをtempsの配列にappendし、最新の値のみをラベルに表示
            if snap.key == "temp" {
              let snapVal = snapshotValue[snap.key]
              temps.append(snapVal as! Double)
            }
          }
        }
        completion?(temps)
      })
    }

  
    //Humidity: グラフ表示用の配列（192：二日分のデータ）を返す関数
    func getHumidityDataForGraph(completion: (([Double]) -> Void)?) {
      //Set the firebase reference
      ref = Database.database().reference()
      databaseHandle = ref?.child("Temp_Hum_Pres").queryLimited(toLast: 10).observe(.childAdded, with: { (snapshot) in
        //取得した値を格納する配列
        var humids: [Double] = []
        
        for childSnap in  snapshot.children.allObjects {
          let snap = childSnap as! DataSnapshot
          if let snapshotValue = snapshot.value as? NSDictionary {
           
            //湿度の値のみをhumidsの配列にappendし、最新の値のみをラベルに表示
            if snap.key == "humidity" {
              let snapVal = snapshotValue[snap.key]
              humids.append(snapVal as! Double)
            }
          }
        }
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
