//
//  ExchangeData.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 25/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


//protocol ExchangeDataDelegate: class {
//    func didReceiveDataUpdate(data: ExchangeData)
//}

class ExchangeData {
    var exchangeId: [String]
    var marketPair: [String]
    var priceUSD: [Double]
  
    
    init(exchangeId: [String] = [""], marketPair: [String] = [""], priceUSD: [Double] = [0]) {
        
        self.exchangeId = exchangeId
        self.marketPair = marketPair
        self.priceUSD = priceUSD
    }
}
