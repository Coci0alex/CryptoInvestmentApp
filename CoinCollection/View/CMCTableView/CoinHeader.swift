//
//  Header.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 30/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol sortDelegate: class {
    func didTapRankBtn()
    func didTapCoinNameBtn()
    func didTapPriceBtn()
    func didTapRateBtn()
}

class CoinHeader: UITableViewHeaderFooterView {

    let headerHeight = UIScreen.main.bounds.height/22.333333333
    
override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupViews()
    
}
required init?(coder aDecoder: NSCoder) {
    fatalError("init(Coder:) has not been implemented")
}
    
    lazy var rankButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Rank", for: .normal )
        button.addTarget(self, action:  #selector(rankButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var coinNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Coin Name (Code)", for: .normal)
        button.addTarget(self, action: #selector(nameButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var priceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Price", for: .normal)
        button.addTarget(self, action: #selector(priceButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var rateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("24h", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(rateButtonAction), for: .touchUpInside)
        return button
    }()

   weak var delegate: sortDelegate?
    
    @objc func rankButtonAction()
    { delegate?.didTapRankBtn() }
    
    @objc func nameButtonAction()
    { delegate?.didTapCoinNameBtn() }
    
    @objc func priceButtonAction()
    { delegate?.didTapPriceBtn() }
    
    @objc func rateButtonAction()
    { delegate?.didTapRateBtn() }
    
    func setupViews() {
        addSubview(rankButton)
        addSubview(coinNameButton)
        addSubview(priceButton)
        addSubview(rateButton)
        setupView()
    }
    
    func setupView() {
        
        // Scaling variables to scale according to screen width //
        let rankScale:  CGFloat = 0.10
        let nameScale:  CGFloat = 0.35
        let priceScale: CGFloat = 0.10
        let rateScale:  CGFloat = 0.08
        
        let buttonArray = [rankButton, coinNameButton, priceButton, rateButton]
        let widthScales: [CGFloat] = [rankScale, nameScale, priceScale, rateScale]
        
        // Determines the space between rankButton and CoinNameButton //
        let spaceScaleAreaOne: CGFloat = 0.04
        let spaceScaleAreaTwo: CGFloat = -0.32
    
         for i in 0..<buttonArray.count {
            buttonArray[i].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: widthScales[i] ).isActive = true
            buttonArray[i].heightAnchor.constraint(equalTo:  self.heightAnchor).isActive = true
            buttonArray[i].bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            buttonArray[i].topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            buttonArray[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
            buttonArray[i].titleLabel?.numberOfLines = 0
            buttonArray[i].titleLabel?.adjustsFontSizeToFitWidth = true
            buttonArray[i].titleLabel?.minimumScaleFactor = 0.1
            buttonArray[i].titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            buttonArray[i].titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        }
        
        // Unique Constraints
        rankButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

        coinNameButton.leadingAnchor.constraint(equalTo: rankButton.trailingAnchor, constant: UIScreen.main.bounds.width*spaceScaleAreaOne).isActive = true
        
        priceButton.leadingAnchor.constraint(equalTo: rateButton.trailingAnchor, constant: UIScreen.main.bounds.width*spaceScaleAreaTwo).isActive = true
        
        rateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5).isActive = true
    }
}
