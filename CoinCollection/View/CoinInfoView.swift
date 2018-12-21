//
//  CoinInfoView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 07/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import Charts

protocol deleteButtonDelegate: class {
    func didTapDeleteButton()
    func didTapZoomButton()
}

class CoinInfoView: UIView {
    
    let screenSize = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    
    
    let candleStickChart: CandleStickChartView = {
        let candle = CandleStickChartView()
        candle.translatesAutoresizingMaskIntoConstraints = false
        return candle
    }()
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let exchangeIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.backgroundColor = UIColor.blue.cgColor
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 2
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let marketPairLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.backgroundColor = UIColor.blue.cgColor
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 2
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
   lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(deleteButtonPushed), for: .touchUpInside)
        return button
    }()
    
    lazy var resetZoom: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.backgroundColor = UIColor.blue.cgColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(resetZoomPushed), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: deleteButtonDelegate?
    
    @objc func deleteButtonPushed() {
        print("BLEV TRYKKET")
        delegate?.didTapDeleteButton()
    }
    
    @objc func resetZoomPushed() {
        print("ZOOM BLEV TRYKKET")
        delegate?.didTapZoomButton()
    }
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rateChange: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lowest: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        return label
    }()
    
    let highest: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let volume: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let lowestHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "low"
        return label
    }()
    
    let highestHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "high"
        return label
    }()
    
    let volumeHeader: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "volume"
        return label
    }()
    
    let subContainer1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        return view
    }()
    
    let subContainer2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        return view
    }()
    
    let subContainer3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 2
        return view
    }()
    
    func setupViews() {
        addSubview(candleStickChart)
        addSubview(exchangeIdLabel)
        addSubview(marketPairLabel)
        addSubview(deleteButton)
        addSubview(resetZoom)

        addSubview(currentPriceLabel)
        addSubview(rateChange)
        addSubview(container)
        container.addSubview(subContainer1)
        container.addSubview(subContainer2)
        container.addSubview(subContainer3)

        subContainer1.addSubview(lowest)
        subContainer2.addSubview(highest)
        subContainer3.addSubview(volume)
        subContainer1.addSubview(lowestHeader)
        subContainer2.addSubview(highestHeader)
        subContainer3.addSubview(volumeHeader)
        setupConstraints()
    }
    
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: screenSize.height).isActive = true
        
        /// UI Items ///
        let labelArray = [exchangeIdLabel, marketPairLabel, currentPriceLabel, rateChange, lowest, lowestHeader, highest, highestHeader, volume, volumeHeader]
        for i in 0..<labelArray.count {
            labelArray[i].font = UIFont.systemFont(ofSize: 100)
            labelArray[i].numberOfLines = 1
            labelArray[i].adjustsFontSizeToFitWidth = true
            labelArray[i].minimumScaleFactor = 0.1
            labelArray[i].lineBreakMode = NSLineBreakMode.byClipping
            labelArray[i].baselineAdjustment = UIBaselineAdjustment.alignCenters
        }
    

        candleStickChart.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        candleStickChart.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
        candleStickChart.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        candleStickChart.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 25).isActive = true
        
        exchangeIdLabel.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor, multiplier: 0.25).isActive = true
        exchangeIdLabel.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.075).isActive = true
        exchangeIdLabel.leadingAnchor.constraint(equalTo: candleStickChart.leadingAnchor, constant: 5).isActive = true
        exchangeIdLabel.bottomAnchor.constraint(equalTo: candleStickChart.topAnchor, constant: -5).isActive = true
        
        marketPairLabel.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor,  multiplier: 0.25).isActive = true
        marketPairLabel.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.075).isActive = true
        marketPairLabel.leadingAnchor.constraint(equalTo: exchangeIdLabel.trailingAnchor, constant: 5).isActive = true
        marketPairLabel.bottomAnchor.constraint(equalTo: candleStickChart.topAnchor, constant: -5).isActive = true

        deleteButton.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor, multiplier: 0.25).isActive = true
        deleteButton.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.075).isActive = true
        deleteButton.leadingAnchor.constraint(equalTo: marketPairLabel.trailingAnchor, constant: 5).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: candleStickChart.topAnchor, constant: -5).isActive = true
        
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 100)
        deleteButton.titleLabel?.numberOfLines = 0
        deleteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        deleteButton.titleLabel?.minimumScaleFactor = 0.1
        deleteButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        deleteButton.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        
        resetZoom.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor, multiplier: 0.175).isActive = true
        resetZoom.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.075).isActive = true
        resetZoom.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 5).isActive = true
        resetZoom.bottomAnchor.constraint(equalTo: candleStickChart.topAnchor, constant: -5).isActive = true
        
        resetZoom.titleLabel?.font = UIFont.systemFont(ofSize: 100)
        resetZoom.titleLabel?.numberOfLines = 0
        resetZoom.titleLabel?.adjustsFontSizeToFitWidth = true
        resetZoom.titleLabel?.minimumScaleFactor = 0.1
        resetZoom.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        resetZoom.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters

        currentPriceLabel.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor, multiplier: 0.3).isActive = true
        currentPriceLabel.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.2).isActive = true
        currentPriceLabel.leadingAnchor.constraint(equalTo: candleStickChart.leadingAnchor, constant: 5).isActive = true
        currentPriceLabel.bottomAnchor.constraint(equalTo: exchangeIdLabel.topAnchor, constant: -2.5).isActive = true

        rateChange.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor, multiplier: 0.3).isActive = true
        rateChange.heightAnchor.constraint(equalTo: candleStickChart.heightAnchor, multiplier: 0.2).isActive = true
        rateChange.trailingAnchor.constraint(equalTo: candleStickChart.trailingAnchor, constant: 5).isActive = true
        rateChange.topAnchor.constraint(equalTo: currentPriceLabel.topAnchor).isActive = true
        
        container.widthAnchor.constraint(equalTo: candleStickChart.widthAnchor).isActive = true
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.075).isActive = true
        container.topAnchor.constraint(equalTo: candleStickChart.bottomAnchor, constant: 10).isActive = true
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        subContainer1.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        subContainer1.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        subContainer1.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        subContainer1.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        
        subContainer2.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        subContainer2.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        subContainer2.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        subContainer2.leadingAnchor.constraint(equalTo: subContainer1.trailingAnchor).isActive = true
        
        subContainer3.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        subContainer3.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        subContainer3.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        subContainer3.leadingAnchor.constraint(equalTo: subContainer2.trailingAnchor).isActive = true

        lowest.widthAnchor.constraint(equalTo: subContainer1.widthAnchor, multiplier: 0.5).isActive = true
        lowest.heightAnchor.constraint(equalTo: subContainer1.heightAnchor, multiplier: 0.5).isActive = true
        lowest.bottomAnchor.constraint(equalTo: subContainer1.bottomAnchor).isActive = true
        lowest.centerXAnchor.constraint(equalTo: subContainer1.centerXAnchor).isActive = true
        
        highest.widthAnchor.constraint(equalTo: subContainer2.widthAnchor, multiplier: 0.5).isActive = true
        highest.heightAnchor.constraint(equalTo: subContainer2.heightAnchor, multiplier: 0.5).isActive = true
        highest.centerXAnchor.constraint(equalTo: subContainer2.centerXAnchor).isActive = true
        highest.bottomAnchor.constraint(equalTo: subContainer2.bottomAnchor).isActive = true

        volume.widthAnchor.constraint(equalTo: subContainer3.widthAnchor, multiplier: 0.5).isActive = true
        volume.heightAnchor.constraint(equalTo: subContainer3.heightAnchor, multiplier: 0.5).isActive = true
        volume.centerXAnchor.constraint(equalTo: subContainer3.centerXAnchor).isActive = true
        volume.bottomAnchor.constraint(equalTo: subContainer3.bottomAnchor).isActive = true

        lowestHeader.widthAnchor.constraint(equalTo: subContainer1.widthAnchor, multiplier: 0.25).isActive = true
        lowestHeader.heightAnchor.constraint(equalTo: subContainer1.heightAnchor, multiplier: 0.4).isActive = true
        lowestHeader.topAnchor.constraint(equalTo: subContainer1.topAnchor).isActive = true
        lowestHeader.centerXAnchor.constraint(equalTo: subContainer1.centerXAnchor).isActive = true

        highestHeader.widthAnchor.constraint(equalTo: subContainer2.widthAnchor, multiplier: 0.3).isActive = true
        highestHeader.heightAnchor.constraint(equalTo: subContainer2.heightAnchor, multiplier: 0.4).isActive = true
        highestHeader.centerXAnchor.constraint(equalTo: subContainer2.centerXAnchor).isActive = true
        highestHeader.topAnchor.constraint(equalTo: subContainer2.topAnchor).isActive = true
        
        volumeHeader.widthAnchor.constraint(equalTo: subContainer3.widthAnchor, multiplier: 0.5).isActive = true
        volumeHeader.heightAnchor.constraint(equalTo: subContainer3.heightAnchor, multiplier: 0.4).isActive = true
        volumeHeader.centerXAnchor.constraint(equalTo: subContainer3.centerXAnchor).isActive = true
        volumeHeader.topAnchor.constraint(equalTo: subContainer3.topAnchor).isActive = true
    }
}



