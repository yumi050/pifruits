//
//  ViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/14.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase



class ViewController: UIViewController, UITextFieldDelegate {
  

 

  @IBOutlet var userTextField: UITextField!
  
  @IBOutlet var emailTextField: UITextField!
  
  @IBOutlet var passwordTextField: UITextField!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userTextField.delegate = self //デリゲートをセット
    emailTextField.delegate = self //デリゲートをセット
    passwordTextField.delegate = self //デリゲートをセット
    passwordTextField.isSecureTextEntry = true // 文字を非表示に
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  //サインアップボタン
  @IBAction func signUpButton(_ sender: Any) {
    //サインアップのための関数
    signup()
  }
  
  
  //ログイン画面への遷移ボタン
  @IBAction func loginButton(_ sender: Any) {
    transitionToLogin()
  }

  
  //ログイン画面へ遷移するメソッド
  func transitionToLogin() {
    self.performSegue(withIdentifier: "toLogin", sender: self)
  }
  
  //ホーム画面への遷移
  func transitionToHome() {
    self.performSegue(withIdentifier: "toHome", sender: self)
  }
  
  //returnキーを押すと、キーボードを隠す
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  //Signupのためのメソッド
  func signup() {
    //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    
    //FIRAuth.auth()?.createUserWithEmailでサインアップ
    //第一引数にEmail、第二引数にパスワード
    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
      //エラーなしなら、認証完了
      if error == nil {
        //メールのバリデーションを行う
        user?.sendEmailVerification(completion: { (error) in
          if error == nil {
            // エラーがない場合にはそのままログイン画面に飛び、ログイン
            self.transitionToHome()
            
          }else{
            print("\(error?.localizedDescription)")
          }
        })
      }
    })
  }


}

