//
//  chartsTest.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import Charts

class CandleStickChartViewController: UIViewController, ChartViewDelegate {
    

    let candleStickChart: CandleStickChartView = {
        let candle = CandleStickChartView(frame: CGRect(x: 0, y: 200, width: 500, height: 300))
        return candle
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      //  view.addSubview(pieChart)
        //view.addSubview(barChart)
        view.backgroundColor = .white
        setDataCount(50, range: 12)
        self.title = "Candle Stick Chart"

        candleStickChart.delegate = self
        
        candleStickChart.chartDescription?.enabled = false
        
        candleStickChart.dragEnabled = false
        candleStickChart.setScaleEnabled(true)
        candleStickChart.maxVisibleCount = 200
        candleStickChart.pinchZoomEnabled = false
        candleStickChart.candleData?.setDrawValues(false)
        
        candleStickChart.legend.horizontalAlignment = .right
        candleStickChart.legend.verticalAlignment = .top
        candleStickChart.legend.orientation = .vertical
        candleStickChart.legend.drawInside = false
        candleStickChart.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        candleStickChart.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        candleStickChart.leftAxis.spaceTop = 0.3
        candleStickChart.leftAxis.spaceBottom = 0.3
        candleStickChart.leftAxis.axisMinimum = 0
        
        candleStickChart.rightAxis.enabled = false
        
        candleStickChart.xAxis.labelPosition = .bottom
        candleStickChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        view.addSubview(candleStickChart)

    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let yVals1 = (0..<count).map { (i) -> CandleChartDataEntry in
            
            let mult = range + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close)
        }
            let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
            set1.axisDependency = .left
            set1.setColor(UIColor(white: 80/255, alpha: 1))
            set1.drawIconsEnabled = false
            set1.shadowColor = .darkGray
            set1.shadowWidth = 0.7
            set1.decreasingColor = .red
            set1.decreasingFilled = true
            set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
            set1.increasingFilled = false
            set1.neutralColor = .blue
            
            let data = CandleChartData(dataSet: set1)
            candleStickChart.data = data
        }
}
