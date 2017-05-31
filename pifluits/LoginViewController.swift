//
//  LoginViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/14.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet var emailTextField: UITextField!
  
  @IBOutlet var passwordTextField: UITextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      emailTextField.delegate = self //デリゲートをセット
      passwordTextField.delegate = self //デリゲートをセット
      passwordTextField.isSecureTextEntry  = true // 文字を非表示に
      

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
  
    //ログインボタン
    @IBAction func loginButton(_ sender: Any) {
      //ログインのためのメソッド
      login()
    
    }
  
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }
  
    //ログイン完了後に、Home画面へ遷移のためのメソッド
    func transitionToHome() {
      self.performSegue(withIdentifier: "toHome", sender: self)
    }

  
    //ログインのためのメソッド
    func login() {
      
      //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
      guard let email = emailTextField.text else { return }
      guard let password = passwordTextField.text else { return }
      
      //signInWithEmailでログイン
      //第一引数にEmail、第二引数にパスワード
      Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
        //エラーなしなら、認証完了
        if error == nil {
          
          if let loginUser = user {
            // バリデーションが完了しているか確認 -> 完了ならログイン
            if self.checkUserValidate(user: loginUser) {
              //完了済みなら、Homerに遷移
              print(Auth.auth().currentUser)
              self.transitionToHome()
              
            }else{
              // 完了していない場合は、アラートを表示
              self.presentValidateAlert()
            }
            
          }
          
        }else{
          print("error...\(error?.localizedDescription)")
        }
        
      })

    }
  
    // ログインした際に、バリデーションが完了しているか返す
    func checkUserValidate(user: User) -> Bool {
    
      return user.isEmailVerified
    
    }
  
    // メールのバリデーションが完了していない場合のアラートを表示
    func presentValidateAlert() {
      let alert = UIAlertController(title: "メール認証", message: "メール認証を行ってください", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
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
