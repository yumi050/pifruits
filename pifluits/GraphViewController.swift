//
//  GraphViewController.swift
//  pifluits
//
//  Created by yumiH on 2017/05/16.
//  Copyright © 2017年 yumiH. All rights reserved.
//

import UIKit
import Firebase
import ScrollableGraphView
import NVActivityIndicatorView


class GraphViewController: UIViewController {
  
    var graphView = ScrollableGraphView()
    var currentGraphType = GraphType.dark
    var graphConstraints = [NSLayoutConstraint]()
  
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()
  
  @IBOutlet weak var circleLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!//平均水やり日数ラベル
  
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var backgroundImage2: UIImageView!
  @IBOutlet weak var backgroundImage3: UIImageView!
  @IBOutlet weak var backgroundImage4: UIImageView!
  
  @IBOutlet weak var temperatureImage: UIImageView!
  @IBOutlet weak var humidityImage: UIImageView!
  @IBOutlet weak var soilMoistureImage: UIImageView!
  @IBOutlet weak var uvImage: UIImageView!
  
  
  
  //Data数
  let numberOfDataItems = 96 //96 = 15分間隔の24時間分のデータ
  //グラフに表示するデータを格納する配列
  var data: [Double] = []
  //X軸のラベル表示用の配列
  lazy var labels: [String] = self.dataTimeLabel(self.numberOfDataItems, text: "分前")
  //自動水やり記録用データの配列
  var autoData: [Double] = [0,0,100,0,0,0,0,0,100,0,0,0,100,0,0,0,0,0,100,0,0,0,0,100,0,0,0,0,0,100]
  //自動水やり記録用 x軸ラベル表示用の配列
  lazy var autoLabels: [String] = self.autoDataTimeLabel(self.numberOfDataItems, text: "6/")
  
  
  
  //FirebaseManagerのインスタンス生成
  let firebaseManager = FirebaseManager()
  
  //Indicator表示用
  var gotTemperatureData = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData())
    
    circleLabel.isHidden = true
    graphView = ScrollableGraphView(frame: self.view.frame)
    graphView = createDarkGraph(self.view.frame)
    //温度のグラフを表示
    firebaseManager.getTemperatureDataForGraph(completion: {
      temps in self.data = temps
      self.graphView.set(data: self.data, withLabels: self.labels)
      self.view.addSubview(self.graphView)
      self.setupConstraints()
      self.addLabel(withText: " Temperature  » ") //Temperature (TAP HERE)
      
      //circleLabelに温度データをセット、円形にし、最前面に移動
      self.getTemperatureData()
      self.circleLabel.isHidden = false
      let circleLabelWidth = self.circleLabel.bounds.size.width
      self.circleLabel.clipsToBounds = true
      self.circleLabel.layer.cornerRadius = circleLabelWidth / 2
      self.view.bringSubview(toFront: self.circleLabel) //最前面に移動
      self.view.bringSubview(toFront: self.backgroundImage) //最前面に移動
      self.view.bringSubview(toFront: self.temperatureImage) //温度のロゴを最前面に移動
      
    })
    
  }
  
  
  func didTap(_ gesture: UITapGestureRecognizer) {
    
    currentGraphType.next()
    
    self.view.removeConstraints(graphConstraints)
    graphView.removeFromSuperview()
    
    switch(currentGraphType) {
    case .dark:
      addLabel(withText: " Temperature  » ")
      graphView = createDarkGraph(self.view.frame)
      //温度のデータをセット
      firebaseManager.getTemperatureDataForGraph(completion: {
        temps in self.data = temps
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getTemperatureData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
        self.view.bringSubview(toFront: self.backgroundImage) //最前面に移動
        self.view.bringSubview(toFront: self.temperatureImage) //温度のロゴを最前面に移動
      })
    case .bar:
      addLabel(withText: " Humidity  » ")
      graphView = createBarGraph(self.view.frame)
      //湿度のデータをセット
      firebaseManager.getHumidityDataForGraph(completion: {
        humids in self.data = humids
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getHumidityData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
        self.view.bringSubview(toFront: self.backgroundImage2) //最前面に移動
        self.view.sendSubview(toBack: self.temperatureImage)
        self.view.sendSubview(toBack: self.soilMoistureImage)
        self.view.sendSubview(toBack: self.uvImage)
        self.view.sendSubview(toBack: self.averageLabel)
        self.view.bringSubview(toFront: self.humidityImage) //湿度のロゴを最前面に移動
      })
    case .dot:
      addLabel(withText: " Water  » ")
      graphView = createDotGraph(self.view.frame)
      //土壌水分のデータをセット
      firebaseManager.getSoilMoistureDataForGraph(completion: {
        soilMoistures in self.data = soilMoistures
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getSoilMoistureData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
        self.view.bringSubview(toFront: self.backgroundImage3) //最前面に移動
        self.view.bringSubview(toFront: self.soilMoistureImage) //土壌水分のロゴを最前面に移動
      })
    case .pink:
      addLabel(withText: " UV light  » ")
      graphView = createPinkMountainGraph(self.view.frame)
      //UVのデータをセット
      firebaseManager.getUVIndexDataForGraph(completion: {
        uvIndexes in self.data = uvIndexes
        self.graphView.set(data: self.data, withLabels: self.labels)
        self.view.insertSubview(self.graphView, belowSubview: self.label)
        
        self.setupConstraints()
        self.getUVIndexData()//ラベルにデータをセット
        self.view.bringSubview(toFront: self.circleLabel)
        self.view.bringSubview(toFront: self.backgroundImage4) //最前面に移動
        self.view.bringSubview(toFront: self.uvImage) //UVのロゴを最前面に移動
      })
    case .dot2:
      addLabel2(withText: "自動水やり記録")
      graphView = createAutoDotGraph(self.view.frame)
      graphView.set(data: autoData, withLabels: autoLabels)
      self.view.insertSubview(graphView, belowSubview: label)
      self.setupConstraints()
      self.getAverageDays()//ラベルにデータをセット
      self.view.bringSubview(toFront: self.circleLabel)
      self.view.bringSubview(toFront: self.backgroundImage3) //最前面に移動
      self.view.bringSubview(toFront: self.averageLabel)
    }
    
    //    graphView.set(data: data, withLabels: labels)
    //    self.view.insertSubview(graphView, belowSubview: label)
    //    setupConstraints()
    
  }
  
  
  //温度のグラフ
  fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 250
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#9EFFCE") //333333 パステルグリーン：C1FFE0,B2FFD8
    
    graphView.lineWidth = 1
    graphView.lineColor = UIColor.white.withAlphaComponent(0.5) //colorFromHex(hexString: "#5297FF") //777777 .clear,7FFFBF
    graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
    
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient //グラデーション
    graphView.fillColor = UIColor.colorFromHex(hexString: "#FFE0FF") //555555
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#7FFFBF") //555555  orangepink:FFDBED , green: 93FFC9 < 8EFFC6
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FFD6FF") //444444 lightpink:FFE0FF
    
    graphView.dataPointSpacing = 80 //x軸（時間）の間隔
    graphView.dataPointSize = 2
    graphView.dataPointFillColor = UIColor.white
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.9)
    graphView.referenceLineLabelColor = UIColor.lightGray//white
    graphView.numberOfIntermediateReferenceLines = 5 //上下を除いた中間線の数
    graphView.shouldShowReferenceLineUnits = true //Y軸の単位設定
    graphView.referenceLineUnits = "℃"
    graphView.dataPointLabelColor = UIColor.lightGray//UIColor.white.withAlphaComponent(0.8) //X軸ラベルの色 777777, UIColor.colorFromHex(hexString: "#ffffff")
    
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
    
    graphView.bottomMargin = 250
    graphView.topMargin = 10
    
    graphView.dataPointType = ScrollableGraphViewDataPointType.circle
    graphView.dataPointSpacing = 58 //x軸（時間）の間隔
    graphView.shouldDrawBarLayer = true
    graphView.shouldDrawDataPoint = false
    
    graphView.lineColor = UIColor.clear
    graphView.barWidth = 25
    graphView.barLineWidth = 1
    graphView.barLineColor = UIColor.colorFromHex(hexString: "#CCFFE5") //origin:777777
    graphView.barColor = UIColor.colorFromHex(hexString: "#CCFFFF") //origin:555555 ,pink:FFE0FF, FFE5FF ,blue: C1FFFF
    graphView.backgroundFillColor = UIColor.clear //UIColor.colorFromHex(hexString: "#CCFFFF") //origin:333333
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
    graphView.referenceLineLabelColor = UIColor.colorFromHex(hexString: "#777777") //x軸のラベルの色
    graphView.numberOfIntermediateReferenceLines = 5 //上下を除いた中間線の数
    //    graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.8) //X軸ラベルの色
    graphView.dataPointLabelColor = UIColor.colorFromHex(hexString: "#777777") //X軸ラベルの色
    graphView.dataPointSpacing = 60 //x軸（時間）の間隔
    
    graphView.shouldAnimateOnStartup = true
    graphView.shouldAnimateOnAdapt = true
    graphView.shouldAdaptRange = true
    graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
    graphView.animationDuration = 1.5
    graphView.rangeMin = 25 //Y軸最小値
    graphView.rangeMax = 70 //Y軸最小値
    //    graphView.shouldRangeAlwaysStartAtZero = true //0から始まる
    
    self.gradientBackground()
    
    return graphView
  }
  
  
  //土壌水分のグラフ
  private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 250
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
    graphView.dataPointLabelColor = UIColor.colorFromHex(hexString: "#ffffff")  //X軸ラベルの色 ,777777
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
    
    graphView.bottomMargin = 250
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#B2B2FF") // #222222
    graphView.lineColor = UIColor.clear
    graphView.lineStyle = ScrollableGraphViewLineStyle.smooth //丸みのあるライン
    
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient //グラデーション
    graphView.fillColor = UIColor.colorFromHex(hexString: "#BCBCFF") //#FF0080: 濃ピンク、#fde5e9：パステルピンク
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear //radial
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#B2B2FF") //#BCBCFF 紫：B7B7FF　＞　C1C1FF
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FFE0FF") //薄いピンク：#E8D1FF < FFDBFF
    
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
  
  
  //自動水やり日記：
  private func createAutoDotGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 250
    graphView.topMargin = 58
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#FFDBFF") //#00BFFF:水色、#B2D8FF:パステル水色
    //グラデーション部分（要確認）
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient
    graphView.fillColor = UIColor.colorFromHex(hexString: "#CCFFE5") //パステルブルー　CCFFFF
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear //radial
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#FFD1FF") //パステルグリーン　CCFFE5　、濃い　BCFFDD
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#B2D8FF") //薄いピンク　FFD1FF
    
    graphView.lineColor = UIColor.clear
    
    graphView.dataPointSize = 5
    graphView.dataPointSpacing = 75 //x軸（時間）の間隔
    graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10) //X軸のラベルの文字サイズ
    graphView.dataPointLabelColor = UIColor.colorFromHex(hexString: "#ffffff")  //X軸ラベルの色 ,777777
    graphView.dataPointFillColor = UIColor.white
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 9) //Y軸のラベルの文字サイズ
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
    
    graphView.numberOfIntermediateReferenceLines = 1 //上下を除いた中間線の数
    graphView.shouldAnimateOnStartup = true
    //    graphView.shouldAdaptRange = true
    graphView.adaptAnimationType = ScrollableGraphViewAnimationType.easeOut
    graphView.animationDuration = 1.5
    graphView.rangeMin = 0 //Y軸最小値
    graphView.rangeMax = 100 //Y軸最大値
    
    return graphView
  }
  
  
  private func setupConstraints() {
    
    self.graphView.translatesAutoresizingMaskIntoConstraints = false
    graphConstraints.removeAll()
    
    let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
    
    let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
    
    let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    
    let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
    
    graphConstraints.append(topConstraint)
    graphConstraints.append(bottomConstraint)
    graphConstraints.append(rightConstraint)
    graphConstraints.append(leftConstraint)
    //graphConstraints.append(heightConstraint)
    
    self.view.addConstraints(graphConstraints)
    
  }
  
  
  //グラフ内容を表示するラベル：タップでグラフの切り替え：Adding and updating the graph switching label in the top right corner of the screen
  private func addLabel(withText text: String) {
    
    label.removeFromSuperview()
    label = createLabel(withText: text)
    label.isUserInteractionEnabled = true
    
//    let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20) //-20
    
    let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10) //20
    
    let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40) //40
    
//    let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.5) //label.frame.width * 1.5
    
    //self.viewの横幅いっぱいにする
    let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
    
    let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
    label.addGestureRecognizer(tapGestureRecogniser)
    
    self.view.insertSubview(label, aboveSubview: graphView)
//    self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    self.view.addConstraints([topConstraint, heightConstraint, widthConstraint])
    
  }
  
  
  //グラフ内容を表示するラベルを生成
  private func createLabel(withText text: String) -> UILabel {
    
    let label = UILabel()
    
    label.backgroundColor = UIColor.clear //black.withAlphaComponent(0.5)
    
    label.text = text
    label.textColor = UIColor.colorFromHex(hexString: "#777777") //UIColor.lightGray
    label.textAlignment = NSTextAlignment.center
    label.font = UIFont(name:"American Typewriter", size: 20) //UIFont.labelFontSize
    label.layer.cornerRadius = 15
    label.clipsToBounds = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    
    return label
    
  }
  
  //自動水やり記録用のラベル
  //グラフ内容を表示するラベル：タップでグラフの切り替え：Adding and updating the graph switching label in the top right corner of the screen
  private func addLabel2(withText text: String) {
    
    label.removeFromSuperview()
    label = createLabel2(withText: text)
    label.isUserInteractionEnabled = true
    
    //    let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20) //-20
    
    let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10) //20
    
    let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40) //40
    
    //    let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 1.5) //label.frame.width * 1.5
    
    //self.viewの横幅いっぱいにする
    let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
    
    let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTap))
    label.addGestureRecognizer(tapGestureRecogniser)
    
    self.view.insertSubview(label, aboveSubview: graphView)
    //    self.view.addConstraints([rightConstraint, topConstraint, heightConstraint, widthConstraint])
    self.view.addConstraints([topConstraint, heightConstraint, widthConstraint])
    
  }
  
  //自動水やり記録用のラベル
  //グラフ内容を表示するラベルを生成
  private func createLabel2(withText text: String) -> UILabel {
    
    let label = UILabel()
    
    label.backgroundColor = UIColor.clear //black.withAlphaComponent(0.5)
    
    label.text = text
    label.textColor = UIColor.colorFromHex(hexString: "#777777") //UIColor.lightGray
    label.textAlignment = NSTextAlignment.center
    label.font = UIFont(name:"07LogoTypeGothic7", size: 17) //UIFont.labelFontSize
    label.layer.cornerRadius = 15
    label.clipsToBounds = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    
    return label
    
  }
  
  
  //X軸のラベル生成：自動水やり記録用（1日〜31日まで）
  private func autoDataTimeLabel(_ numberOfItems: Int, text: String) -> [String] {
    
    var autoLabels = [String]()
    for i in 1 ..< 31 {
      autoLabels.append("\(text)\(i) ")
    }
    
    return autoLabels
    
  }
  
  
  //X軸のラベル生成
  private func dataTimeLabel(_ numberOfItems: Int, text: String) -> [String] {
    
    var labels = [String]()
    
    for i in 0 ..< 10 {
      if (i < 4){ //3回繰り返す＝45分まで表示
        labels.append("\(i*15)\(text) ")
      }else{
        for h in 1 ..< 25 { //23時間45分前まで表示
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
//    print(labels)
    return labels
    
  }
  
  
  //表示するグラフの種類
  enum GraphType {
    case dark
    case bar
    case dot
    case pink
    case dot2
    
    mutating func next() {
      switch(self) {
      case .dark:
        self = GraphType.bar
      case .bar:
        self = GraphType.dot
      case .dot:
        self = GraphType.pink
      case .pink:
        self = GraphType.dot2
      case .dot2:
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
      self.circleLabel.text = text + " ℃"
      //値を取得できたらindicatorを止める
      self.gotTemperatureData = true
      if self.gotTemperatureData == true {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
      }
    })
  }
  
  
  //Humidity:最新の値を取得し、ラベルに表示する関数
  func getHumidityData() {
    firebaseManager.getHumidityData(completion: {
      text in
      self.circleLabel.text = text + " %"

    })
  }
  
  
  //自動水やり記録：平均水やり日数をラベルに表示する関数
  func getAverageDays() {
    self.circleLabel.text = "4日間"
    self.averageLabel.text = "平均水やり間隔"
    self.averageLabel.textColor = UIColor.darkGray.withAlphaComponent(0.7)//UIColor.colorFromHex(hexString: "#888888")
    self.averageLabel.font = UIFont(name:"07LogoTypeGothic7", size: 14)
  }
  
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  //背景をグラデーションにする
  func gradientBackground() {
    //グラデーションの開始色
    let topColor = UIColor.colorFromHex(hexString: "#FFFF9E") //blue: 066dab , green: C0F7EF
    //グラデーションの開始色
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
