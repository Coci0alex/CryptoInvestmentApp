//
//  HomeCellView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 23/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class HomeCellView: UITableViewCell {
    
    
    var coinLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var coinName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var coinPrice: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var rateChange24h: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        return label
    }()
    
    var holdingsUsd: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    var holdingsCoin: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    func setupViews() {
        addSubview(containerView)
       // containerView.addSubview(topLine)
        containerView.addSubview(bottomLine)
        containerView.addSubview(coinLogo)
        containerView.addSubview(coinName)
        containerView.addSubview(coinPrice)
        containerView.addSubview(rateChange24h)
        containerView.addSubview(holdingsUsd)
        containerView.addSubview(holdingsCoin)
        setRankView()
    }
    
    func setRankView() {
        
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.01 ).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        
        /// Height and Width Scaling Variables ///
        let logoScale: (CGFloat, CGFloat) = (height: 0.6, width: 0.05)
        let nameScale: (CGFloat, CGFloat) = (height: 0.4, width: 0.3)
        let priceScale: (CGFloat, CGFloat) = (height: 0.3, width: 0.2)
        let rateScale: (CGFloat, CGFloat) = (height: 0.3, width: 0.2)
        let holdingsUsdScale: (CGFloat, CGFloat) = (height: 0.3, width: 0.3)
        let holdingsCoinScale: (CGFloat, CGFloat) = (height: 0.3, width: 0.3)
        
        let array: [(height: CGFloat, width: CGFloat)] = [nameScale, priceScale, rateScale, holdingsUsdScale, holdingsCoinScale]
        
        /// UI Items ///
        var label: [UILabel] = [coinName, coinPrice, rateChange24h, holdingsUsd, holdingsCoin]
        
        // Triviel constraints //
        for i in 0..<label.count {
            label[i].heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: array[i].height).isActive = true
            label[i].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: array[i].width).isActive = true
            label[i].translatesAutoresizingMaskIntoConstraints = false
            label[i].font = UIFont.systemFont(ofSize: 100)
            label[i].numberOfLines = 0
            label[i].adjustsFontSizeToFitWidth = true
            label[i].minimumScaleFactor = 0.1
            label[i].lineBreakMode = NSLineBreakMode.byClipping
            label[i].baselineAdjustment = UIBaselineAdjustment.alignCenters
        }

        // Unique constraints
        coinLogo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        coinLogo.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: logoScale.0).isActive = true
        coinLogo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: logoScale.1).isActive = true
        coinLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coinLogo.contentMode = .scaleAspectFit
        
        coinName.leadingAnchor.constraint(equalTo: coinLogo.trailingAnchor, constant: 5).isActive = true
        coinName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        coinPrice.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        coinPrice.topAnchor.constraint(equalTo: self.topAnchor, constant: 5 ).isActive = true

        rateChange24h.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        rateChange24h.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        holdingsCoin.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        holdingsCoin.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        holdingsUsd.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
        holdingsUsd.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}
