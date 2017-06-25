//
//  ChatViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
//import SwiftyJSON
//import JSQMessagesViewController


class ChatViewController: UIViewController { //JSQMessagesViewController
  
  @IBOutlet weak var iconLabel: UIImageView! //植物のアイコン画像
  @IBOutlet weak var iconLabel2: UIImageView!
  
  @IBOutlet weak var iconLabel3: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //アイコン画像を正円にする
    let iconLabelWidth = iconLabel.bounds.size.width
    iconLabel.clipsToBounds = true
    iconLabel.layer.cornerRadius = iconLabelWidth / 2
    //二つ目のアイコン画像を正円にする
    let iconLabelWidth2 = iconLabel2.bounds.size.width
    iconLabel2.clipsToBounds = true
    iconLabel2.layer.cornerRadius = iconLabelWidth2 / 2
    //三つ目のアイコン画像を正円にする
    let iconLabelWidth3 = iconLabel3.bounds.size.width
    iconLabel3.clipsToBounds = true
    iconLabel3.layer.cornerRadius = iconLabelWidth3 / 2

  
  }
  
  
////JSQMessagesViewController のコード：
//  private var messages: [JSQMessage] = []
//  private var incomingBubble: JSQMessagesBubbleImage!
//  private var outgoingBubble: JSQMessagesBubbleImage!
//  private var incomingAvatar: JSQMessagesAvatarImage!
//  // テスト用
//  private let targetUser: JSON = ["senderId": "targetUser", "displayName": "passion"]
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    initialSettings()
//  }
//  
//  private func initialSettings() {
//    // 自分の情報入力
//    self.senderId = "self"
//    self.senderDisplayName = "自分の名前"
//    // 吹き出しの色設定
//    let bubbleFactory = JSQMessagesBubbleImageFactory()
//    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
//    
//    // 相手の画像設定
//    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "red_plants2.jpg")!, diameter: 64)
//    // 自分の画像を表示しない
//    self.collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
//  }
//  
//  // 送信ボタンを押した時の挙動
//  override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
//    let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
//    messages.append(message!)
//    // 更新
//    finishSendingMessage(animated: true)
//    
//    sendAutoMessage()
//  }
//  
//  // 表示するメッセージの内容
//  //swift3の記法
//  override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
//    return messages[indexPath.item]
//  }
//  
//  // 表示するメッセージの背景を指定
//  override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
//    if messages[indexPath.item].senderId == senderId {
//      return self.outgoingBubble
//    }
//    return self.incomingBubble
//  }
//  
//  // 表示するユーザーアイコンを指定。nilを指定すると画像がでない
//  override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
//    if messages[indexPath.item].senderId != self.senderId {
//      return incomingAvatar
//    }
//    return nil
//  }
//  
//  // メッセージの件数を指定
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return messages.count
//  }
//  
//  // テストでメッセージを送信するためのメソッド
//  private func sendAutoMessage() {
//    let message = JSQMessage(senderId: targetUser["senderId"].string, displayName: targetUser["displayName"].string, text: "返信するぞ")
//    messages.append(message!)
//    finishReceivingMessage(animated: true)
//  }
//  
//  override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Dispose of any resources that can be recreated.
//  }
//  
//
//  
//  // 送信時刻を出すために高さを調整する
//  override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
//    let message = messages[indexPath.item]
//    if indexPath.item == 0 {
//      return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
//    }
//    if indexPath.item - 1 > 0 {
//      let previousMessage = messages[indexPath.item - 1]
//      if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
//        return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
//      }
//    }
//    return nil //nil
//  }
//  
//  // 送信時刻を出すために高さを調整する
//  override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
//    if indexPath.item == 0 {
//      return kJSQMessagesCollectionViewCellLabelHeightDefault
//    }
//    if indexPath.item - 1 > 0 {
//      let previousMessage = messages[indexPath.item - 1]
//      let message = messages[indexPath.item]
//      if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
//        return kJSQMessagesCollectionViewCellLabelHeightDefault
//      }
//    }
//    return 0.0
//  }
//  
//  



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
