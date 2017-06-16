//
//  RealDataGraphViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/06/03.
//  Copyright © 2017年 yumiH. All rights reserved.
//


//Firebaseから実際のデータを取り出し、グラフに表示させるためのView!!!

import UIKit
import Firebase
import FirebaseDatabase
import ScrollableGraphView


class RealDataGraphViewController: UIViewController {
  
  var graphView = ScrollableGraphView()
  var currentGraphType = GraphType.dark
  var graphConstraints = [NSLayoutConstraint]()
  
  var label = UILabel()
  var labelConstraints = [NSLayoutConstraint]()
  
  @IBOutlet weak var circleLabel: UILabel! //最新の値を表示するラベル
    
  
  //Data
  let numberOfDataItems = 96 //96 = 24時間分のデータ
  
  //    lazy var data: [Double] = self.generateRandomeData(self.numberOfDataItems, max: 50)
  var data: [Double] = []
  //  lazy var labels: [String] = self.generateSequentialLabels(self.numberOfDataItems, text: "July")
  lazy var labels: [String] = self.dataTimeLabel(self.numberOfDataItems, text: "分前")
  //FirebaseManagerのインスタンス生成
  let firebaseManager = FirebaseManager()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    circleLabel.isHidden = true
    graphView = ScrollableGraphView(frame: self.view.frame)
    graphView = createDarkGraph(self.view.frame)
    //温度のグラフを表示
    firebaseManager.getTemperatureDataForGraph(completion: {
      temps in self.data = temps
      self.graphView.set(data: self.data, withLabels: self.labels)
      self.view.addSubview(self.graphView)
      self.setupConstraints()
      self.addLabel(withText: "Temperature (TAP HERE)")
      
      //circleLabelに温度データをセット、円形にし、最前面に移動
      self.getTemperatureData()
      self.circleLabel.isHidden = false
      let circleLabelWidth = self.circleLabel.bounds.size.width
      self.circleLabel.clipsToBounds = true
      self.circleLabel.layer.cornerRadius = circleLabelWidth / 2
      self.view.bringSubview(toFront: self.circleLabel)
      
    })
    
  }
  
  
  func didTap(_ gesture: UITapGestureRecognizer) {
    
    currentGraphType.next()
    
    self.view.removeConstraints(graphConstraints)
    graphView.removeFromSuperview()
    
    switch(currentGraphType) {
    case .dark:
      addLabel(withText: "Temperature")
      graphView = createDarkGraph(self.view.frame)
      //温度のデータをセット
      firebaseManager.getTemperatureDataForGraph(completion: {
        temps in self.data = temps
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getTemperatureData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
      })
    case .bar:
      addLabel(withText: "Humidity")
      graphView = createBarGraph(self.view.frame)
      //湿度のデータをセット
      firebaseManager.getHumidityDataForGraph(completion: {
        humids in self.data = humids
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getHumidityData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
      })
    case .dot:
      addLabel(withText: "Water")
      graphView = createDotGraph(self.view.frame)
      //土壌水分のデータをセット
      firebaseManager.getSoilMoistureDataForGraph(completion: {
        soilMoistures in self.data = soilMoistures
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getSoilMoistureData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
      })
    case .pink:
      addLabel(withText: "UV light")
      graphView = createPinkMountainGraph(self.view.frame)
      //UVのデータをセット
      firebaseManager.getUVIndexDataForGraph(completion: {
        uvIndexes in self.data = uvIndexes
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getUVIndexData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
      })
    }
    
//    graphView.set(data: data, withLabels: labels)
//    self.view.insertSubview(graphView, belowSubview: label)
//    setupConstraints()
    
  }
  
  //温度のグラフ
  fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 280
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
    
    graphView.lineWidth = 1
    graphView.lineColor = UIColor.colorFromHex(hexString: "#777777")
    graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
    
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient //グラデーション
    graphView.fillColor = UIColor.colorFromHex(hexString: "#555555")
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
    
    graphView.dataPointSpacing = 80 //x軸（時間）の間隔
    graphView.dataPointSize = 2
    graphView.dataPointFillColor = UIColor.white
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.numberOfIntermediateReferenceLines = 5 //上下を除いた中間線の数
    graphView.shouldShowReferenceLineUnits = true //Y軸の単位設定
    graphView.referenceLineUnits = "℃"
    graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.8) //X軸ラベルの色
    
//    graphView.shouldAutomaticallyDetectRange = true //???
    
    graphView.shouldAnimateOnStartup = true
    graphView.shouldAdaptRange = true //Y軸を自動調整
    graphView.shouldAnimateOnAdapt = true //mmmmm
    graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
    graphView.animationDuration = 1.5
    graphView.rangeMin = 22 //Y軸最小値
    graphView.rangeMax = 30 //Y軸最大値
//    graphView.shouldRangeAlwaysStartAtZero = true
    
    return graphView
  }
  
  //湿度のグラフ
  private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 280
    graphView.topMargin = 10
    
    graphView.dataPointType = ScrollableGraphViewDataPointType.circle
//    graphView.dataPointSpacing = 55 //x軸（時間）の間隔
    graphView.shouldDrawBarLayer = true
    graphView.shouldDrawDataPoint = false
    
    graphView.lineColor = UIColor.clear
    graphView.barWidth = 25
    graphView.barLineWidth = 1
    graphView.barLineColor = UIColor.colorFromHex(hexString: "#777777")
    graphView.barColor = UIColor.colorFromHex(hexString: "#555555")
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.numberOfIntermediateReferenceLines = 5 //上下を除いた中間線の数
    graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.8) //X軸ラベルの色
    graphView.dataPointSpacing = 59 //x軸（時間）の間隔
    
    graphView.shouldAnimateOnStartup = true
    graphView.shouldAnimateOnAdapt = true
    graphView.shouldAdaptRange = true
    graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
    graphView.animationDuration = 1.5
    graphView.rangeMin = 25 //Y軸最小値
    graphView.rangeMax = 70 //Y軸最小値
//    graphView.shouldRangeAlwaysStartAtZero = true //0から始まる
    
    return graphView
  }
  
  //土壌水分のグラフ
  private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 280
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#B2D8FF") //#00BFFF:水色、#B2D8FF:パステル水色
    //グラデーション部分（要確認）
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient
    graphView.fillColor = UIColor.colorFromHex(hexString: "#CCFFE5") //パステルブルー　CCFFFF
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear //radial
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#CCFFFF") //パステルグリーン　CCFFE5　、濃い　BCFFDD
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FFD1FF") //薄いピンク　FFD1FF
    
    graphView.lineColor = UIColor.clear
    
    graphView.dataPointSize = 5
    graphView.dataPointSpacing = 75 //x軸（時間）の間隔
    graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10) //X軸のラベルの文字サイズ
    graphView.dataPointLabelColor = UIColor.white  //X軸ラベルの色
    graphView.dataPointFillColor = UIColor.white
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 9) //Y軸のラベルの文字サイズ
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
    
    graphView.numberOfIntermediateReferenceLines = 9 //上下を除いた中間線の数
    graphView.shouldAnimateOnStartup = true
//    graphView.shouldAdaptRange = true
    graphView.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
    graphView.animationDuration = 1.5
    graphView.rangeMin = 0 //Y軸最小値
    graphView.rangeMax = 100 //Y軸最大値
    
    return graphView
  }
  
  //UV指数のグラフ
  private func createPinkMountainGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 280
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333") // #222222
    graphView.lineColor = UIColor.clear
    graphView.lineStyle = ScrollableGraphViewLineStyle.smooth //丸みのあるライン
    
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient //グラデーション
    graphView.fillColor = UIColor.colorFromHex(hexString: "#BCBCFF") //#FF0080: 濃ピンク、#fde5e9：パステルピンク
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear //radial
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#B7B7FF") //#BCBCFF
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#E8D1FF") //薄いピンク：#E8D1FF
    
    graphView.shouldDrawDataPoint = false
    graphView.dataPointSpacing = 70 //x軸（時間）の間隔
    graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
    graphView.dataPointLabelColor = UIColor.white  //X軸ラベルの色
    
    graphView.dataPointLabelsSparsity = 1
    
    graphView.referenceLineThickness = 1
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 9)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
    
    graphView.numberOfIntermediateReferenceLines = 1 //上下を除いた中間線の数
    
    graphView.shouldAdaptRange = true
    graphView.rangeMin = 0 //Y軸最小値
    graphView.rangeMax = 2 //Y軸最大値
//    graphView.shouldRangeAlwaysStartAtZero = true //0から始まる
    
    return graphView
  }
  
  private func setupConstraints() {
    
    self.graphView.translatesAutoresizingMaskIntoConstraints = false
    graphConstraints.removeAll()
    
    let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    
    let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    
    //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
    
    graphConstraints.append(topConstraint)
    graphConstraints.append(bottomConstraint)
    graphConstraints.append(rightConstraint)
    graphConstraints.append(leftConstraint)
    //graphConstraints.append(heightConstraint)
    
    self.view.addConstraints(graphConstraints)
    
  }
  
  //右上のラベル：タップでグラフの切り替え：Adding and updating the graph switching label in the top right corner of the screen
  private func addLabel(withText text: String) {
    
    label.removeFromSuperview()
    label = createLabel(withText: text)
    label.isUserInteractionEnabled = true
    
    let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20)
    
    let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20)
    
    let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
    
    let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.5)
    
    let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
    label.addGestureRecognizer(tapGestureRecogniser)
    
    self.view.insertSubview(label, aboveSubview: graphView)
    self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    
  }
  
  private func createLabel(withText text: String) -> UILabel {
    
    let label = UILabel()
  
    label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
    label.text = text
    label.textColor = UIColor.white
    label.textAlignment = NSTextAlignment.center
    label.font = UIFont.boldSystemFont(ofSize: 14)
    
    label.layer.cornerRadius = 15
    label.clipsToBounds = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    
    return label
    
  }
  
  //不使用
  //Data Generation
//  private func generateRandomeData(_ numberOfItems: Int, max: Double) -> [Double] {
//    
//    var data = [Double]()
//    for _ in 0 ..< numberOfItems {
//      var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
//      
//      if (arc4random() % 100 < 10) {
//        randomNumber *= 3
//      }
//      
//      data.append(randomNumber)
//    }
//    
//    return data
//    
//  }

  
//  //X軸のラベル生成
//  private func dataTimeLabel(_ numberOfItems: Int, text: String) -> [String] {
//    
//    var labels = [String]()
//    for i in 0 ..< numberOfItems {
//      labels.append("\(i*15)\(text) ")
//    }
//    
//    return labels
//    
//  }
  
  //X軸のラベル生成
  private func dataTimeLabel(_ numberOfItems: Int, text: String) -> [String] {
    
    var labels = [String]()
    
    for i in 0 ..< 10 {
      if (i < 7){ //6回繰り返す＝90分まで表示
        labels.append("\(i*15)\(text) ")
      }else{
        for h in 1 ..< 25 { //24時間45分前まで表示
          for m in 0 ..< 4 {
            if (m == 0) {
              labels.append("\(h)時間前")
            }else{
              labels.append("\(h)時間\(m*15)\(text) ")
            }
          }
        }
      }
    }
    print(labels)
    return labels
      
    }
  
  
  //表示するグラフの種類
  enum GraphType {
    case dark
    case bar
    case dot
    case pink
    
    mutating func next() {
      switch(self) {
      case .dark:
        self = GraphType.bar
      case .bar:
        self = GraphType.dot
      case .dot:
        self = GraphType.pink
      case .pink:
        self = GraphType.dark
      }
    }
  }
  
  
  //土壌水分量:最新の値を取得し、ラベルに表示する関数 
  func getSoilMoistureData() {
    firebaseManager.getSoilMoistureData(completion: {
      text in
      self.circleLabel.text = String(text) + " %"
    })
  }
  
  
  //UVIndex:最新の値を取得し、ラベルに表示する関数
  func getUVIndexData() {
    firebaseManager.getUVIndexData(completion: {
      text in
      self.circleLabel.text = text
    })
  }
  
  
  //Temperature:最新の値を取得し、ラベルに表示する関数
  func getTemperatureData() {
    firebaseManager.getTemperatureData(completion: {
      text in
      self.circleLabel.text = text
    })
  }
  
  
  //Humidity:最新の値を取得し、ラベルに表示する関数
  func getHumidityData() {
    firebaseManager.getHumidityData(completion: {
      text in
      self.circleLabel.text = text
    })
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
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
