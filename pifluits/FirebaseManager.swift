//
//  FirebaseManager.swift
//  pifluits
//
//  Created by NanashimaHideyuki on 2017/06/10.
//  Copyright © 2017 yumiH. All rights reserved.
//

import Foundation
import FirebaseDatabase



class FirebaseManager {
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?

    
    func getSoilMoistureData(completion: ((String) -> Void)?) {
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("soil_moisture").observe(.childAdded, with: { (snapshot) in
            //取得した値を格納する配列
            var soilMoistures: [Double] = []
            
            for childSnap in  snapshot.children.allObjects {
                let snap = childSnap as! DataSnapshot //型キャスト
                if let snapshotValue = snapshot.value as? NSDictionary {
                    //土壌水分量の値のみをsoilMoisturesの配列にappendし、最新の値のみをラベルに表示
                    if snap.key == "soil_moisture" {
                        let snapVal = snapshotValue[snap.key]
                        soilMoistures.append(snapVal as! Double)
                        
                        completion?(String(describing: soilMoistures.last!) + " %")
                        //            print(soilMoistures)
                        //計測時間をtimesの配列にappend
                    }
                }
            }
        })
    }
    
    func getUVIndexData(completion: (([Double]) -> Void)?) {
        //Set the firebase reference
        ref = Database.database().reference()
        databaseHandle = ref?.child("UV index").observe(.childAdded, with: { (snapshot) in
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
            completion?(uvIndexes)
        })
    }
}
