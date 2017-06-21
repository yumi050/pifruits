//
//  CameraViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase //画像をFirebaseにアップする場合

class CameraViewController: UIViewController {
  
  @IBOutlet weak var cameraImage: UIImageView!
  

    override func viewDidLoad() {
<<<<<<< HEAD
<<<<<<< Updated upstream
        super.viewDidLoad()
        // Create a storage reference from our storage service
//        let storageRef = storage.reference(forURL: "gs://pifruits-5d32b.appspot.com")
=======
      super.viewDidLoad()
      
//      //ストレージ サービスへの参照を取得
//      let storage = Storage.storage()
//      //URLを取得し、imageのURLを参照
//      if let imageURL = getImageUrl() {
//        let storageRef = storage.reference(forURL: imageURL)
//      
////       Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//          if (error != nil) {
//            // Uh-oh, an error occurred!
//            print("error")
//          } else {
//            // Data for "images/island.jpg" is returned
//            let piCameraImage: UIImage! = UIImage(data: data!)
//            self.cameraImage.image = piCameraImage
//            print("image download")
//          }
//        }
//      
//      }
//      
>>>>>>> bd0d8f5b6dde5454806e5be1e8e6b3abcd3c229a
      
=======
      super.viewDidLoad()
      
//      //ストレージ サービスへの参照を取得
//      let storage = Storage.storage()
//      //URLを取得し、imageのURLを参照
//      if let imageURL = getImageUrl() {
//        let storageRef = storage.reference(forURL: imageURL)
//      
////       Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//          if (error != nil) {
//            // Uh-oh, an error occurred!
//            print("error")
//          } else {
//            // Data for "images/island.jpg" is returned
//            let piCameraImage: UIImage! = UIImage(data: data!)
//            self.cameraImage.image = piCameraImage
//            print("image download")
//          }
//        }
//      
//      }
//      
    
    
>>>>>>> Stashed changes
      
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //GoogleService-InfoからstorageのimageURLを取得
  private func getImageUrl() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      return nil
    }
    
    let configurations = NSDictionary(contentsOfFile: path)
    return configurations?.object(forKey: "IMAGE_STORAGE_URL") as? String
  }
  
  
  @IBAction func cameraButton(_ sender: Any) {
    
    //ストレージ サービスへの参照を取得
    let storage = Storage.storage()
    //URLを取得し、imageのURLを参照
    if let imageURL = getImageUrl() {
      let storageRef = storage.reference(forURL: imageURL)
      
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
