//
//  UserDefaultViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/04.
//  Copyright © 2017年 yumiH. All rights reserved.
//

//UserDefault動作確認：　練習用ファイル

import UIKit

class UserDefaultViewController: UIViewController,UITextFieldDelegate {
  
  //植物名入力テキストラベル
  @IBOutlet weak var plantNameTextField: UITextField!
  //表示用ラベル
  @IBOutlet weak var textLabel: UILabel!
  //画像表示ラベル
  @IBOutlet weak var pictureImageView: UIImageView!
  
  
  
  //UserDefaultsのインスタンス生成
  let userDefaults: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
      super.viewDidLoad()

      //textFiel の情報を受け取るための delegate を設定
      plantNameTextField.delegate = self
      //UserDefaultsのデフォルト値
      userDefaults.register(defaults: ["DataStore": "default"])
      

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //Returnキーを押すと、キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  //plantNameTextFieldに入力した値をUserDefaultsに登録する
  func registerPlantName() {
    //textfieldに入力された植物名をplantNameに入れる
    let plantName = self.plantNameTextField.text
    userDefaults.set(plantName, forKey:"plantName")
    userDefaults.synchronize()
  }
  
  //UserDefaultsに登録した値を呼び出す
  func readSavedData() -> String {
    // Keyを"plantName"として指定して読み込み
    let PlantName: String = userDefaults.string(forKey: "plantName")!
    //    print(PlantName)
    return PlantName
  }
  
  
  //画像をUserDefaultsに登録する
  func registerIcon() {
    if let image = UIImage(named: "red_plants2.jpg") {
      //UIImageをDataに変換
      let imageData = UIImagePNGRepresentation(image)
      //UserDefaultsに保存
      userDefaults.set(imageData, forKey:"plantIcon")
      userDefaults.synchronize()
    }
  }
  
  
 
  
    //登録ボタンを押すと、
  @IBAction func register(_ sender: Any) {
    //UserDefaultsに植物名を登録
    registerPlantName()
    //登録された植物名をラベルに表示
    textLabel.text = readSavedData()
    //UserDefaultsに画像アイコンを登録
    registerIcon()
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
