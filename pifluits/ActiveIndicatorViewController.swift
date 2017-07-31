//
//  ActiveIndicatorViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/21.
//  Copyright © 2017年 yumiH. All rights reserved.

//練習用ファイル：


import UIKit
import Foundation
import NVActivityIndicatorView

class ActiveIndicatorViewController: UIViewController, NVActivityIndicatorViewable {

  
  override func viewDidLoad() {
    super.viewDidLoad()
    //背景をグラデーションにする
    gradientBackground()
    
//    self.view.backgroundColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1)
    self.view.backgroundColor = UIColor.colorFromHex(hexString: "#FFF3B0")

    
    let cols = 1
    let rows = 1
    let cellWidth = Int(self.view.frame.width / CGFloat(cols))
    let cellHeight = Int(self.view.frame.height / CGFloat(rows))
    
    (NVActivityIndicatorType.ballPulse.rawValue ... NVActivityIndicatorType.audioEqualizer.rawValue).forEach {
      let x = ($0 - 1) % cols * cellWidth
      let y = ($0 - 1) / cols * cellHeight
      let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
      let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                          type: NVActivityIndicatorType(rawValue: 18)!) //(rawValue: $0)!)
      activityIndicatorView.padding = 250
      if $0 == NVActivityIndicatorType.orbit.rawValue {
        activityIndicatorView.padding = 0
      }
      self.view.addSubview(activityIndicatorView)
      //animation開始
      activityIndicatorView.startAnimating()
      
      //３秒後にanimation停止予定だが停止しない。。。。
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
        self.stopAnimating()
      }
      
      let button: UIButton = UIButton(frame: frame)
      button.tag = $0
      button.addTarget(self,
                       action: #selector(buttonTapped(_:)),
                       for: UIControlEvents.touchUpInside)
      self.view.addSubview(button)
    }
  }
  
  func buttonTapped(_ sender: UIButton) {
    let size = CGSize(width: 50, height: 50) //(width: 30, height: 30)
    
    startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
    
//    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//      NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
//    }
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
      self.stopAnimating()
    }
  }

  //背景をグラデーションにする
  func gradientBackground() {
    //グラデーションの開始色
//    let topColor = UIColor(red:0.07, green:0.13, blue:0.26, alpha:1)
    let topColor = UIColor.colorFromHex(hexString: "#ACF2F9") //blue: 066dab , green: C0F7EF

    //グラデーションの開始色
//    let bottomColor = UIColor(red:0.54, green:0.74, blue:0.74, alpha:1)
    let bottomColor = UIColor.colorFromHex(hexString: "#F5C2F9")

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
