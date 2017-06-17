//
//  tabBarSettingViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//


import UIKit

class tabBarSettingViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // タブバーアイコン非選択時の色を変更（iOS 10で利用可能）
        UITabBar.appearance().unselectedItemTintColor = .white
        //選択時のアイコンの色
        UITabBar.appearance().tintColor = UIColor.colorFromHex(hexString: "#FFD6FF") //pink: FFDBFF < FFD6FF ,bluegreen: A8FFD3
        //TabBarの背景色
        UITabBar.appearance().barTintColor = .black
        // ナビゲーションバーを半透明にしない(画面遷移直後にちらつくため)
        tabBar.isTranslucent = false

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
