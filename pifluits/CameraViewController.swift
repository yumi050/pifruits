//
//  CameraViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase //動画をFirebaseにアップする場合

class CameraViewController: UIViewController {
  //ストレージ サービスへの参照を取得
//  let storage = Storage.storage()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a storage reference from our storage service
//        let storageRef = storage.reference(forURL: "gs://pifruits-5d32b.appspot.com")
      
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  
  @IBAction func cameraButton(_ sender: Any) {
    
    
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
