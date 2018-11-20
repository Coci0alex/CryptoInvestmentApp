//
//  currencyCellView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class CurrencyCellView: UITableViewCell {
    
    var rankLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var coinLogo: UIImageView = {
        let logo = UIImageView()
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    var coinName: UILabel = {
        let coinName = UILabel()
        return coinName
    }()
    
    var coinSymbol: UILabel = {
        let coinSymbol = UILabel()
        return coinSymbol
    }()
    
    var coinPrice: UILabel = {
        let coinPrice = UILabel()
        coinPrice.font = UIFont.systemFont(ofSize: 100)
        return coinPrice
    }()
    
    var rateChange24h: UILabel = {
        let rateChange24h = UILabel()
        rateChange24h.textAlignment = .right
        return rateChange24h
    }()
    
    func setupViews() {
        addSubview(rankLabel)
        addSubview(coinLogo)
        addSubview(coinSymbol)
        addSubview(coinName)
        addSubview(coinPrice)
        addSubview(rateChange24h)
        setRankView()
    }
    
    func setRankView() {
        
        /// Height and X-position Scaling Variables ///
        let rankScale: (CGFloat, CGFloat) = (height: 0.4, xPos: 0)
        let logoScale: (CGFloat, CGFloat) = (height: 0.6, xPos: 0.06)
        let nameScale: (CGFloat, CGFloat) = (height: 0.4, xPos: 0.185)
        let symbolScale: (CGFloat, CGFloat) = (height: 0.4, xPos: 0.55)
        let priceScale: (CGFloat, CGFloat) = (height: 0.4, xPos: -0.32)
        let rateScale: (CGFloat, CGFloat) = (height: 0.4, xPos: 0.825)

        
        let array: [(height: CGFloat, xPos: CGFloat)] = [rankScale, nameScale, symbolScale, priceScale, rateScale]
        
        /// UI Items ///
        var label: [UILabel] = [rankLabel, coinName, coinSymbol, coinPrice, rateChange24h]
        
        // Triviel constraints //
        for i in 0..<label.count {
            label[i].heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: array[i].height).isActive = true
            label[i].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            label[i].translatesAutoresizingMaskIntoConstraints = false
            label[i].font = UIFont.systemFont(ofSize: 100)
            label[i].numberOfLines = 0
            label[i].adjustsFontSizeToFitWidth = true
            label[i].minimumScaleFactor = 0.1
            label[i].lineBreakMode = NSLineBreakMode.byClipping
            label[i].baselineAdjustment = UIBaselineAdjustment.alignCenters
        }
        
        // Unique constraints
        rankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width * rankScale.1).isActive = true
        
        coinLogo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: logoScale.0).isActive = true
        coinLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coinLogo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.05).isActive = true
        coinLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width * logoScale.1).isActive = true

        coinName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width * nameScale.1).isActive = true

        coinSymbol.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width * symbolScale.1).isActive = true
        
        coinPrice.leadingAnchor.constraint(equalTo: rateChange24h.trailingAnchor, constant: UIScreen.main.bounds.width * priceScale.1).isActive = true
        coinPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
   
        rateChange24h.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width * rateScale.1).isActive = true
        rateChange24h.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}
