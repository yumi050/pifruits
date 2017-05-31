//
//  FirebaseViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/29.
//  Copyright © 2017年 yumiH. All rights reserved.
//


//テストファイル（最終的に削除）：Firebaseのデータを読み出す

import UIKit
import FirebaseDatabase

class FirebaseViewController: UIViewController {
  
  

  @IBOutlet weak var dataLabel: UILabel!
  

  var ref:DatabaseReference?
  var databaseHandle:DatabaseHandle?
  
//  var postData = [String]()
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
        getLatestData()
      
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
