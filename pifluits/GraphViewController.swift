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
  
    //Data
    let numberOfDataItems = 29
  
//    lazy var data: [Double] = self.generateRandomeData(self.numberOfDataItems, max: 50)
    var data: [Double] = []
    lazy var labels: [String] = self.generateSequentialLabels(self.numberOfDataItems, text: "July")
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
      
      graphView = ScrollableGraphView(frame: self.view.frame)
      graphView = createDarkGraph(self.view.frame)
      
        let firebaseManager = FirebaseManager()
        firebaseManager.getUVIndexData(completion: {
            uvIndexes in self.data = uvIndexes
            self.graphView.set(data: self.data, withLabels: self.labels)
            self.view.addSubview(self.graphView)
            self.setupConstraints()
            self.addLabel(withText: "Temperature (TAP HERE)")
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
      case .bar:
        addLabel(withText: "Humidity")
        graphView = createBarGraph(self.view.frame)
      case .dot:
        addLabel(withText: "Water")
        graphView = createDotGraph(self.view.frame)
      case .pink:
        addLabel(withText: "UV light")
        graphView = createPinkMountainGraph(self.view.frame)
      }
    
      graphView.set(data: data, withLabels: labels)
      self.view.insertSubview(graphView, belowSubview: label)
    
      setupConstraints()
    
    }
  
    //温度のグラフ
    fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
    
      let graphView = ScrollableGraphView(frame: frame)
    
      graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
    
      graphView.lineWidth = 1
      graphView.lineColor = UIColor.colorFromHex(hexString: "#777777")
      graphView.lineStyle = ScrollableGraphViewLineStyle.smooth
    
      graphView.shouldFill = true
      graphView.fillType = ScrollableGraphViewFillType.gradient
      graphView.fillColor = UIColor.colorFromHex(hexString: "#555555")
      graphView.fillGradientType = ScrollableGraphViewGradientType.linear
      graphView.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
      graphView.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
      
      graphView.dataPointSpacing = 80 //x軸（日付）の間隔
      graphView.dataPointSize = 2
      graphView.dataPointFillColor = UIColor.white
    
      graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
      graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
      graphView.referenceLineLabelColor = UIColor.white
      graphView.numberOfIntermediateReferenceLines = 5
      graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
    
      graphView.shouldAnimateOnStartup = true
      graphView.shouldAdaptRange = true
      graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
      graphView.animationDuration = 1.5
      graphView.rangeMax = 50
      graphView.shouldRangeAlwaysStartAtZero = true
    
      return graphView
    }
  
    //湿度のグラフ
    private func createBarGraph(_ frame: CGRect) -> ScrollableGraphView {
    
      let graphView = ScrollableGraphView(frame: frame)
      
      graphView.dataPointType = ScrollableGraphViewDataPointType.circle
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
      graphView.numberOfIntermediateReferenceLines = 5
      graphView.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
      
      graphView.shouldAnimateOnStartup = true
      graphView.shouldAdaptRange = true
      graphView.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
      graphView.animationDuration = 1.5
      graphView.rangeMax = 50
      graphView.shouldRangeAlwaysStartAtZero = true
    
      return graphView
    }
  
    //土壌水分のグラフ
    private func createDotGraph(_ frame: CGRect) -> ScrollableGraphView {
      
      let graphView = ScrollableGraphView(frame: frame)
      
      graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#ADD6FF") //#00BFFF:水色、#B2D8FF:パステル水色
      graphView.lineColor = UIColor.clear
      
      graphView.dataPointSize = 5
      graphView.dataPointSpacing = 80
      graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
      graphView.dataPointLabelColor = UIColor.white
      graphView.dataPointFillColor = UIColor.white
      
      graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
      graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
      graphView.referenceLineLabelColor = UIColor.white
      graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
      
      graphView.numberOfIntermediateReferenceLines = 9
      
      graphView.rangeMax = 50
      
      return graphView
    }
  
    //UV指数のグラフ
    private func createPinkMountainGraph(_ frame: CGRect) -> ScrollableGraphView {
    
      let graphView = ScrollableGraphView(frame: frame)
      
      graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333") // #222222
      graphView.lineColor = UIColor.clear
      
      graphView.shouldFill = true
      graphView.fillColor = UIColor.colorFromHex(hexString: "#BCBCFF") //#FF0080: 濃ピンク、#fde5e9：パステルピンク
      
      graphView.shouldDrawDataPoint = false
      graphView.dataPointSpacing = 22
      graphView.dataPointLabelFont = UIFont.boldSystemFont(ofSize: 10)
      graphView.dataPointLabelColor = UIColor.white
      
      graphView.dataPointLabelsSparsity = 3
      
      graphView.referenceLineThickness = 1
      graphView.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 10)
      graphView.referenceLineColor = UIColor.white.withAlphaComponent(0.5)
      graphView.referenceLineLabelColor = UIColor.white
      graphView.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
      
      graphView.numberOfIntermediateReferenceLines = 1
      
      graphView.shouldAdaptRange = true
      
      graphView.rangeMax = 50
      
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
      
      label.layer.cornerRadius = 2
      label.clipsToBounds = true
      
      label.translatesAutoresizingMaskIntoConstraints = false
      label.sizeToFit()
      
      return label
      
    }
  
    //Data Generation
    private func generateRandomeData(_ numberOfItems: Int, max: Double) -> [Double] {
    
      var data = [Double]()
      for _ in 0 ..< numberOfItems {
        var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
        
        if (arc4random() % 100 < 10) {
          randomNumber *= 3
        }
        
        data.append(randomNumber)
      }
      
      return data
      
    }
  
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
      
      var labels = [String]()
      for i in 0 ..< numberOfItems {
        labels.append("\(text) \(i+1)")
      }
      
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
