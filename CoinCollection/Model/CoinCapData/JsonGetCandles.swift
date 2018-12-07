//
//  JsonGetCandles.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

struct JsonGetCandles: Decodable {
    let data: [getCandles]
}

struct getCandles: Decodable {
    let open: String
    let high: String
    let low: String
    let close: String
    let volume: String
    let period: Int64
}
