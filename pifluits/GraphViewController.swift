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

class GraphViewController: UIViewController {
  
    var graphView = ScrollableGraphView()
    var currentGraphType = GraphType.dark
    var graphConstraints = [NSLayoutConstraint]()
  
    var label = UILabel()
    var labelConstraints = [NSLayoutConstraint]()
  
  @IBOutlet weak var circleLabel: UILabel!
  
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var backgroundImage2: UIImageView!
  @IBOutlet weak var backgroundImage3: UIImageView!
  @IBOutlet weak var backgroundImage4: UIImageView!
  
  
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
      self.addLabel(withText: " Temperature  » ") //Temperature (TAP HERE)
      
      //circleLabelに温度データをセット、円形にし、最前面に移動
      self.getTemperatureData()
      self.circleLabel.isHidden = false
      let circleLabelWidth = self.circleLabel.bounds.size.width
      self.circleLabel.clipsToBounds = true
      self.circleLabel.layer.cornerRadius = circleLabelWidth / 2
      self.view.bringSubview(toFront: self.circleLabel) //最前面に移動
      self.view.bringSubview(toFront: self.backgroundImage) //最前面に移動
      
      
      
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
      })
    }
    
    //    graphView.set(data: data, withLabels: labels)
    //    self.view.insertSubview(graphView, belowSubview: label)
    //    setupConstraints()
    
  }
  
  //温度のグラフ
  fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
    
    let graphView = ScrollableGraphView(frame: frame)
    
    graphView.bottomMargin = 270
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333") //333333
    
    graphView.lineWidth = 1
    graphView.lineColor = UIColor.colorFromHex(hexString: "#777777") //777777
    graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
    
    graphView.shouldFill = true
    graphView.fillType = ScrollableGraphViewFillType.gradient //グラデーション
    graphView.fillColor = UIColor.colorFromHex(hexString: "#FFE0FF") //555555
    graphView.fillGradientType = ScrollableGraphViewGradientType.linear
    graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#93FFC9") //555555  orangepink:FFDBED
    graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#FFE0FF") //444444 lightpink:FFE0FF
    
    graphView.dataPointSpacing = 80 //x軸（時間）の間隔
    graphView.dataPointSize = 2
    graphView.dataPointFillColor = UIColor.white
    
    graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
    graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
    graphView.referenceLineLabelColor = UIColor.white
    graphView.numberOfIntermediateReferenceLines = 5 //上下を除いた中間線の数
    graphView.shouldShowReferenceLineUnits = true //Y軸の単位設定
    graphView.referenceLineUnits = "℃"
    graphView.dataPointLabelColor = UIColor.colorFromHex(hexString: "#777777")//UIColor.white.withAlphaComponent(0.8) //X軸ラベルの色
    
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
    
    graphView.bottomMargin = 270
    graphView.topMargin = 10
    
    graphView.dataPointType = ScrollableGraphViewDataPointType.circle
    //    graphView.dataPointSpacing = 55 //x軸（時間）の間隔
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
    graphView.dataPointSpacing = 59 //x軸（時間）の間隔
    
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
    
    graphView.bottomMargin = 270
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
    
    graphView.bottomMargin = 270
    graphView.topMargin = 10
    
    graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333") // #222222
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
    
//    let rightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -20) //-20
    
    let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 5) //20
    
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
  
  private func createLabel(withText text: String) -> UILabel {
    
    let label = UILabel()
    
    label.backgroundColor = UIColor.clear //black.withAlphaComponent(0.5)
    
    label.text = text
    label.textColor = UIColor.lightGray
    label.textAlignment = NSTextAlignment.center
//    label.font = UIFont.boldSystemFont(ofSize: 15)
    label.font = UIFont(name:"Palatino", size: UIFont.labelFontSize)
    label.layer.cornerRadius = 15
    label.clipsToBounds = true
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.sizeToFit()
    
    return label
    
  }
  
  
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
      self.circleLabel.text = text + " ℃"

    })
  }
  
  
  //Humidity:最新の値を取得し、ラベルに表示する関数
  func getHumidityData() {
    firebaseManager.getHumidityData(completion: {
      text in
      self.circleLabel.text = text + " %"

    })
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
