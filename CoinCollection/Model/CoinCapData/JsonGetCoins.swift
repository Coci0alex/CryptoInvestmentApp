//
//  JsonGetCoins.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 24/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

struct JsonGetCoins: Decodable {
    let data: [getCoins]
}

struct getCoins: Decodable {
    let symbol: String
    let id: String
    let name: String
}
