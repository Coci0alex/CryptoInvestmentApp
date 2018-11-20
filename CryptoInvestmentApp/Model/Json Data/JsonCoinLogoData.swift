//
//  jsonCoinLogo.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 11/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation

struct JsonCoinLogoData: Decodable {
    let data: [String: Props]
}


struct Props: Decodable {
    let logo: String
}

