//
//  CryptoTableViewProperties.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation
import UIKit

class CoinProperties {
    var rank: Int
    var logoImage: UIImage
    var name: String
    var symbol: String
    var price: Double
    var marketCap: String
    var rateChange: Double
    
    init?(rank: Int?, logoImage: UIImage? = #imageLiteral(resourceName: "btc"), name: String, symbol: String, price: Double?, marketCap: String, rateChange: Double?) {
        
        
        // If values is empty return nil
        guard let rnk = rank else { return nil }
        guard let image = logoImage else { return nil }
        guard !name.isEmpty else { return nil }
        guard !symbol.isEmpty else { return nil }
        guard let price = price else { return nil }
       // guard !price.isEmpty else { return nil }
        guard !marketCap.isEmpty else { return nil }
        guard let rateChange = rateChange else { return nil }

        // if not empty initialize values
        self.rank = rnk
        self.logoImage = image
        self.name = name
        self.symbol = symbol
        self.price = price
        self.marketCap = marketCap
        self.rateChange = rateChange
        
    }
    
}
