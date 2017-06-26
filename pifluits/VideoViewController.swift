//
//  VideoViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/26.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Firebase //動画をFirebaseからダウンロードして表示させる

class VideoViewController: UIViewController {
  
  let avPlayerViewController = AVPlayerViewController()
  var avPlayer: AVPlayer?
  


    override func viewDidLoad() {
      super.viewDidLoad()
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
  
  
  //GoogleService-InfoからstorageのvideoURLを取得
  private func getVideoUrl() -> String? {
    guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
      return nil
    }
    
    let configurations = NSDictionary(contentsOfFile: path)
    return configurations?.object(forKey: "VIDEO_STORAGE_URL") as? String
  }
  
  
  
  @IBAction func buttonTapped(_ sender: Any) {
    
    //triger the video to play
    self.present(self.avPlayerViewController, animated: true) { () -> Void in
      self.avPlayerViewController.player?.play()
    }
    
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
