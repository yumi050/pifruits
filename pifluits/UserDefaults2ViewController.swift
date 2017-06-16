//
//  UserDefaults2ViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/07.
//  Copyright © 2017年 yumiH. All rights reserved.
//


//UserDefaults画面遷移用ファイル：練習用ファイル

import UIKit

class UserDefaults2ViewController: UIViewController  {
  
    //遷移先ラベル：植物名を表示させる
    @IBOutlet weak var textLabel: UILabel!
    //遷移先ラベル：画像を表示させる
    @IBOutlet weak var iconLabel: UIImageView!
  
    //UserDefaultsのインスタンス生成
    let userDefaults: UserDefaults = UserDefaults.standard

  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      //画像を正円にする
      let iconLabelWidth = iconLabel.bounds.size.width
      iconLabel.clipsToBounds = true
      iconLabel.layer.cornerRadius = iconLabelWidth / 2

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ラベルにUserDefaultsに登録した植物名を表示する
        textLabel.text = readSavedData()
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
    let PlantName: String = userDefaults.string(forKey: "plantName")!
    //     let PlantName: String = userDefaults.object(forKey: "plantName") as! String
    //    print(PlantName)
    return PlantName
  }

  
  //UserDefaultsに登録した画像を呼び出す
  func readSavedPictureData() -> UIImage {
    let imageData:Data = userDefaults.object(forKey:"plantIcon") as! Data
    let image = UIImage(data:imageData)
    
    return image!
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
