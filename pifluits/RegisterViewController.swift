//
//  RegisterViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
  
  //カメラで撮影した画像が表示される
  @IBOutlet weak var pictureImageView: UIImageView!
  //植物の名前を入力するtextField
  @IBOutlet weak var plantNameTextField: UITextField!
  
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
  
  
  //カメラで写真を撮影するボタン
  @IBAction func takePictureButton(_ sender: Any) {
    let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
    //カメラが利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      //インスタンスの作成
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
      
    }else{
      print("error")
      //アラートでエラーを通知
      showAlert()
    }
  }
  
  
  //撮影が完了した時に呼ばれる関数
  func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      pictureImageView.contentMode = .scaleAspectFit
      pictureImageView.image = pickedImage
    }
    //閉じる処理
    imagePicker.dismiss(animated: true, completion: nil)
    print("completed")
  }
  
  
  // 撮影がキャンセルされた時に呼ばれる
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    print("canceled")
  }
  
  
  //フォトライブラリから選択するボタン
  @IBAction func albumButton(_ sender: Any) {
    let sourceType:UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
    //フォトライブラリ利用可能かチェック
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      //インスタンスの作成
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
      
    }else{
      print("Photolibrary not available")
    }
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
  
  
  //Returnキーを押すと、キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  
  //登録ボタンが押されると：写真をフォトアルバムに保存し、UserDefaultsに植物名が登録される　ー＞　その後、遷移先のHomeViewControllerに写真と植物名が表示される
  @IBAction func registerButton(_ sender: Any) {
    let image:UIImage! = pictureImageView.image
    if image != nil {
      //フォトアルバムにimageを保存する
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
      //写真をUserDefaultsに保存する
      let imageData = UIImagePNGRepresentation(image)
      //UserDefaultsに保存
      userDefaults.set(imageData, forKey:"plantIcon")
      userDefaults.synchronize()
      
    }else{
      print("Image Failed to Save")
    }
    //UserDefaultsに登録
    registerPlantName()
  }
  
  
  //書き込み完了結果の受け取り
  func image(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
    print("1")
    if error != nil {
      print(error.code)
    }else{
      print("Save Succeeded")
    }
  }
  
  
  //アラートでエラーを表示
  func showAlert() {
    //アラートコントローラーの実装
    let alertController = UIAlertController(title: "Error", message: "カメラの利用を許可してください。", preferredStyle: UIAlertControllerStyle.alert)
    //OKボタンの実装
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(action: UIAlertAction) in
      //okがクリックされた時の処理
      print("OK")
    }
    
    //キャンセルボタンの実装
    let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
    
    alertController.addAction(okAction)
    alertController.addAction(cancelButton)
    
    //アラートの表示
    present(alertController, animated: true, completion: nil)
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
