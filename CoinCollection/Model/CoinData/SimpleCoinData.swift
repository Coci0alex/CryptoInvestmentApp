//
//  CoinData.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 24/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class SimpleCoinData {
    
    var coinId: String
    var coinName: String
    var coinSymbol: String
    
    
    init?(coinId: String, coinName: String, coinSymbol: String) {
        guard !coinId.isEmpty else { return nil }
        guard !coinName.isEmpty else { return nil }
        guard !coinSymbol.isEmpty else { return nil }
        
        self.coinId = coinId
        self.coinName = coinName
        self.coinSymbol = coinSymbol
    }
}

