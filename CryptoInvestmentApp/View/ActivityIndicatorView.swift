//
//  ActivityIndicatorView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 18/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation

import UIKit

class ActivityIndicatorView: UIActivityIndicatorView {

    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        let screenSize = UIScreen.main.bounds
        let frameCenter: CGPoint = CGPoint(x: screenSize.size.width*0.5, y: screenSize.size.height*0.5)
        indicator.center = frameCenter
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        return indicator
    }()
    
    func setupViews() {
        self.addSubview(activityIndicator)
        setupConstraints()
    }
    
    func setupConstraints() {
      //  activityIndicator.centerXAnchor.constraint(equalTo: x)
    }
    
    
 /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 */
}
