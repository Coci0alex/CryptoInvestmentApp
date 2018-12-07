//
//  HomeHeader.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 23/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//
import UIKit

protocol sortHomeHeaderDelegate: class {
    func didTapCoinNameBtn()
    func didTapPriceBtn()
    func didTapHoldingsBtn()
}

class HomeHeader: UITableViewHeaderFooterView {
    
    let headerHeight = UIScreen.main.bounds.height/22.333333333
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
 
    lazy var coinNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Coin", for: .normal)
        button.titleLabel?.textAlignment = .left

        button.addTarget(self, action: #selector(nameButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var priceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Price", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(priceButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var holdingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Holdings", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(holdingsButtonAction), for: .touchUpInside)
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    weak var delegate: sortHomeHeaderDelegate?
    

    @objc func nameButtonAction()
    { delegate?.didTapCoinNameBtn() }
    
    @objc func priceButtonAction()
    { delegate?.didTapPriceBtn() }
    
    @objc func holdingsButtonAction()
    { delegate?.didTapHoldingsBtn() }
    
    func setupViews() {
        addSubview(containerView)
        containerView.addSubview(coinNameButton)
        containerView.addSubview(priceButton)
        containerView.addSubview(holdingsButton)
        setupHeader()
    }
    
    func setupHeader() {
        
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        /// Height and Width Scaling Variables ///
        let nameScale: (CGFloat, CGFloat) = (height: 0.15, width: 0.08)
        let priceScale: (CGFloat, CGFloat) = (height: 0.2, width: 0.09)
        let holdingsScale: (CGFloat, CGFloat) = (height: 0.2, width: 0.166)
        
        /// UI Items ///
        let buttonArray = [coinNameButton, priceButton, holdingsButton]
        
        let scaleArray: [(height: CGFloat, width: CGFloat)] = [nameScale, priceScale, holdingsScale]
        
        for i in 0..<buttonArray.count {
            buttonArray[i].setTitleColor(UIColor.white, for: .normal)
            buttonArray[i].widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: scaleArray[i].width).isActive = true
            buttonArray[i].heightAnchor.constraint(equalTo:  self.heightAnchor, multiplier: scaleArray[i].height).isActive = true
            buttonArray[i].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            buttonArray[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 100)
            buttonArray[i].titleLabel?.numberOfLines = 0
            buttonArray[i].titleLabel?.adjustsFontSizeToFitWidth = true
            buttonArray[i].titleLabel?.minimumScaleFactor = 0.1
            buttonArray[i].titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
            buttonArray[i].titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        }
 
        // Unique Constraints
        coinNameButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        priceButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        holdingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5).isActive = true
    }
}
