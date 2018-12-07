//
//  CoinInfoViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import Charts


protocol deleteCoinDelegate: class {
    func didTapDeleteCoin(coinData: PortFolio)
}

class CoinInfoViewController: UIViewController, ChartViewDelegate  {
    
    var coinCapService: CoinCapServices
    
    
    init(someService: CoinCapServices) {
        self.coinCapService = someService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var open24h = [String]()
    private var close24h = [String]()
    private var high24h = [String]()
    private var low24h = [String]()
    private var period = [Int64]()
    private var newPeriod = [String]()
    
    private var lowest = Double()
    private var highest = Double()
    private var totalVolume = Double()
  
    private var candleStickChart: CandleStickChartView!
    private let errorModal = NetworkErrorHandling()

    var getUI: CoinInfoView!
    var coinData: PortFolio!
    weak var axisFormatDelegate: IAxisValueFormatter?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = coinData.coinNameBuy

        initUIComponents()
        setupUIData()
        setupCandleStickChart()
        axisFormatDelegate = self

        if !Reachability.isConnectedToNetwork() {
            let modal = errorModal.noInternetModal()
            self.present(modal, animated: false, completion: nil)
        } else {
            if let exchangeId = coinData.exchangeId, let coinId = coinData.coinId, let coinNameSell =  coinData.coinNameSell {
                let statusCode = fetchCandles(url: "https://api.coincap.io/v2/candles?exchange=" + exchangeId
                + "&interval=m1&baseId=" + coinId +  "&quoteId=" + coinNameSell )
                checkNetworkErrors(statusCode: statusCode)
                setCandleStickData()
            }
        }
    }
    
    func initUIComponents() {
        getUI = CoinInfoView(frame: CGRect.zero)
        getUI.delegate = self
        view.addSubview(getUI)
        candleStickChart =  getUI.candleStickChart

    }
    
    func setupUIData() {
        getUI.exchangeIdLabel.text = coinData.exchangeId?.capitalizingFirstLetter()
        getUI.currentPriceLabel.text = "$" + String(coinData.currentPrice.rounded(toPlaces: 2))
        
        if let buyPair = coinData.buyPair, let sellPair = coinData.sellPair {
            getUI.marketPairLabel.text = buyPair + "/" + sellPair
        }
        
        getUI.deleteButton.setTitle("Delete", for: .normal)
        getUI.deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        getUI.deleteButton.setTitleColor(.black, for: .normal)
        
        if coinData.rateChange < 0 {
            getUI.rateChange.textColor = .red
        } else if coinData.rateChange > 0 {
            getUI.rateChange.textColor = .green
        }
        getUI.rateChange.text = "%" + String(coinData.rateChange)
    }
    

    func setupCandleStickChart() {
        candleStickChart.delegate = self
        
        candleStickChart.chartDescription?.enabled = false
        
        candleStickChart.dragEnabled = true
        candleStickChart.setScaleEnabled(false)
        candleStickChart.pinchZoomEnabled = true
        candleStickChart.candleData?.setDrawValues(false)

        candleStickChart.legend.enabled = false
        
        candleStickChart.leftAxis.enabled = false
        
        candleStickChart.rightAxis.enabled = true
        candleStickChart.rightAxis.spaceBottom = 0
        candleStickChart.xAxis.axisMaxLabels = 9
        candleStickChart.xAxis.centerAxisLabelsEnabled = false
        candleStickChart.xAxis.labelPosition = .bottom
        candleStickChart.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        candleStickChart.xAxis.drawLimitLinesBehindDataEnabled = false
        candleStickChart.xAxis.avoidFirstLastClippingEnabled = false
    }
    
    var dataEntries: [CandleChartDataEntry] = []
    
    func setCandleStickData() {
        let yVals1 = (0..<open24h.count).map { (i) -> CandleChartDataEntry in
            if let high = Double(high24h[i]), let low = Double(low24h[i]), let open = Double(open24h[i]), let close = Double(close24h[i]) {
                let period = Double(self.period[i])
                
                let newPeriod = Date(timeIntervalSince1970: TimeInterval(period)/1000)
                let timerIntervalForDate: TimeInterval = newPeriod.timeIntervalSince1970
                
                return CandleChartDataEntry(x: Double(timerIntervalForDate), shadowH: high, shadowL: low, open: open, close: close)
            }
            return(CandleChartDataEntry(x: 0, shadowH: 0, shadowL: 0, open: 0, close: 0))
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: "")
        set1.axisDependency = YAxis.AxisDependency.left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.highlightLineWidth = 1
        
        candleStickChart.xAxis.valueFormatter = axisFormatDelegate
        candleStickChart.xAxis.granularity = 1

        let data = CandleChartData(dataSet: set1)
        candleStickChart.data = data
    }
     func fetchCandles(url: String) -> Int {
        var statusCode = 0
        
        coinCapService.fetchCandles(url: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("fetchCandles Throwed An Error: ", error)
                return
            }
                guard let getJson = data else { return }
            
                for index in 0..<getJson.data.count {
                    let low = getJson.data[index].low
                    let high = getJson.data[index].high
                    
                    if index == 1 {
                        if let low = Double(low) {
                            self.lowest = Double(low)
                        }
                    }
                    
                    if let low = Double(low) {
                        if low < self.lowest {
                            self.lowest = low
                        }
                    }
                    
                    if let high = Double(high) {
                        if high > self.highest {
                            self.highest = high
                        }
                    }
                    
                    if let volume = Double(getJson.data[index].volume) {
                        self.totalVolume += volume
                    }
                    
                    self.open24h.append(getJson.data[index].open)
                    self.close24h.append(getJson.data[index].close)
                    self.period.append(getJson.data[index].period)
                    self.low24h.append(low)
                    self.high24h.append(high)
                }
            
            self.getUI.lowest.text = "$" + String(self.lowest.rounded(toPlaces: 2))
            self.getUI.highest.text = "$" + String(self.highest.rounded(toPlaces: 2))
            if self.totalVolume > 1000000 {
                self.getUI.volume.text = "$" + String((self.totalVolume / 1000000).rounded(toPlaces: 2)) + "MM"
            } else {
                self.getUI.volume.text = "$" + String((self.totalVolume / 1000000).rounded(toPlaces: 2)) + "K"
            }
        }
        return statusCode
}
    
    func checkNetworkErrors(statusCode: Int) {
        if statusCode != 200 {
            let headerText = "Error"
            let errorMessage = "Apoligies something went wrong. Please try again later..."
            let nav = errorModal.showModal(headerText, errorMessage)
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    func getNetworkResponse(response: HTTPURLResponse, url: URL) -> Int {
        let statusCode = response.statusCode
        let url = url
        print("fetchCandles - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
        return statusCode
    }
    
    weak var delegate: deleteCoinDelegate?
}


extension CoinInfoViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}

extension CoinInfoViewController: deleteButtonDelegate {
    @objc func didTapDeleteButton() {
        delegate?.didTapDeleteCoin(coinData: coinData)
        self.navigationController?.popViewController(animated: true)
    }
}
