//
//  ChatViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
//import JSQMessagesViewController


class ChatViewController: UIViewController {

//  var messages: [JSQMessage]?
//  var incomingBubble: JSQMessagesBubbleImage!
//  var outgoingBubble: JSQMessagesBubbleImage!
//  var incomingAvatar: JSQMessagesAvatarImage!
//  var outgoingAvatar: JSQMessagesAvatarImage!
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    //自分のsenderId, senderDisokayNameを設定
//    self.senderId = "user1"
//    self.senderDisplayName = "hoge"
//    
//    //吹き出しの設定
//    let bubbleFactory = JSQMessagesBubbleImageFactory()
//    self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
//    self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
//    
//    //アバターの設定
//    self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "ok.png")!, diameter: 64)
//    self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "red_plants2.jpg")!, diameter: 64)
//    
//    //メッセージデータの配列を初期化
//    self.messages = []
//    
//  }
//  
//  override func didReceiveMemoryWarning() {
//    super.didReceiveMemoryWarning()
//    // Dispose of any resources that can be recreated.
//  }
//  
//  //Sendボタンが押された時に呼ばれる
//  func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//    
//    //新しいメッセージデータを追加する
//    let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
//    self.messages?.append(message!)
//    
//    //メッセジの送信処理を完了する(画面上にメッセージが表示される)
//    self.finishReceivingMessage(animated: true)
//    
//    //擬似的に自動でメッセージを受信
//    self.receiveAutoMessage()
//    
//  }
//  
//  //アイテムごとに参照するメッセージデータを返す
//  func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
//    return self.messages?[indexPath.item]
//  }
//  
//  //アイテムごとのMessageBubble(背景)を返す
//  func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
//    let message = self.messages?[indexPath.item]
//    if message?.senderId == self.senderId {
//      return self.outgoingBubble
//    }
//    return self.incomingBubble
//  }
//  
//  //アイテムごとにアバター画像を返す
//  func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
//    let message = self.messages?[indexPath.item]
//    if message?.senderId == self.senderId {
//      return self.outgoingAvatar
//    }
//    return self.incomingAvatar
//  }
//  
//  //アイテムの総数を返す
//  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    return (self.messages?.count)!
//  }
//  
//  //返信メッセージを受信する
//  func receiveAutoMessage() {
//    Timer.scheduledTimer(timeInterval: 1, target: self, selector: "didFinishMessageTimer:", userInfo: nil, repeats: false)
//  }
//  
//  func didFinishMessageTimer(sender: Timer) {
//    let message = JSQMessage(senderId: "user2", displayName: "underscore", text: "Hello!")
//    self.messages?.append(message!)
//    self.finishReceivingMessage(animated: true)
//  }
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
