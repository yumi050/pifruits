//
//  CameraViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase //画像をFirebaseにアップする
import AVFoundation
import AVKit
import NVActivityIndicatorView


class CameraViewController: UIViewController {
  
  @IBOutlet weak var cameraImage: UIImageView!
  
  @IBOutlet weak var whiteLabel: UILabel!
  //動画再生用
  let avPlayerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer?
  

    override func viewDidLoad() {
      super.viewDidLoad()
      
      gradientBackground()
      NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
      
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
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            
          }
        }
      }
      
      //画像の角を丸くする
      self.cameraImage.clipsToBounds = true
      self.cameraImage.layer.cornerRadius = 128
      //白ラベルの角を丸くする
      self.whiteLabel.clipsToBounds = true
      self.whiteLabel.layer.cornerRadius = 128
      
      
      //Firebase上のdownloadURLをvideoUrlにセットし、movieUrlに渡す
      let videoUrl = getVideoUrl()
      let movieUrl: URL? = URL(string: videoUrl!)
      //movieUrlに値があれば、AVPlayerにurlを渡し、プレイヤーを設定する
      if let url = movieUrl {
        self.avPlayer = AVPlayer(url: url)
        self.avPlayerViewController.player = self.avPlayer
      }
      
      
    }
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  //Playボタンが押されると、タイムラプス動画を再生する
  @IBAction func playButtonTapped(_ sender: Any) {
    //triger the video to play
    self.present(self.avPlayerViewController, animated: true) { () -> Void in
      self.avPlayerViewController.player?.play()
    }
    
  }
  
  
  //GoogleService-InfoからstorageのimageURLを取得
  private func getImageUrl() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      return nil
    }
    
    let configurations = NSDictionary(contentsOfFile: path)
    return configurations?.object(forKey: "IMAGE_STORAGE_URL") as? String
  }
  
  
  //GoogleService-InfoからstorageのvideoURLを取得
  private func getVideoUrl() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      return nil
    }
    
    let configurations = NSDictionary(contentsOfFile: path)
    return configurations?.object(forKey: "VIDEO_STORAGE_URL") as? String
  }
  
//  @IBAction func cameraButton(_ sender: Any) {
//    gradientBackground()
//    NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
//    
//    //ストレージ サービスへの参照を取得
//    let storage = Storage.storage()
//    //URLを取得し、imageのURLを参照
//    if let imageURL = getImageUrl() {
//      let storageRef = storage.reference(forURL: imageURL)
//      
//      //Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//      storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
//        if (error != nil) {
//          // Uh-oh, an error occurred!
//          print("error")
//        } else {
//          // Data for "images/island.jpg" is returned
//          let piCameraImage: UIImage! = UIImage(data: data!)
//          self.cameraImage.image = piCameraImage
//          print("image download")
//          NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//          
//        }
//      }
//    }
//    
//    
//  }
  
  
  //背景をグラデーションにする
  func gradientBackground() {
    //グラデーションの開始色
    let topColor = UIColor.colorFromHex(hexString: "#FFEAF4") //blue: 066dab , green: C0F7EF, pink:FFEAF4
    //グラデーションの開始色
    let bottomColor = UIColor.colorFromHex(hexString: "#DBDBFF")//purple:E5E5FF
    //グラデーションの色を配列で管理
    let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
    //グラデーションレイヤーを作成
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    //グラデーションの色をレイヤーに割り当てる
    gradientLayer.colors = gradientColors
    //グラデーションレイヤーをスクリーンサイズにする
    gradientLayer.frame = self.view.bounds
    //グラデーションレイヤーをビューの一番下に配置
    self.view.layer.insertSublayer(gradientLayer, at: 0)
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
