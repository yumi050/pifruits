//
//  RegisterViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  //カメラで撮影した画像が表示される
  @IBOutlet weak var pictureImageView: UIImageView!
  
  

    override func viewDidLoad() {
        super.viewDidLoad()

      
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
  
  
  //登録ボタン、写真を保存する
  @IBAction func registerButton(_ sender: Any) {
    let image:UIImage! = pictureImageView.image
    if image != nil {
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }else{
      print("Image Failed to Save")
    }
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
      //後で変更する！！！
      print("Hello")
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
