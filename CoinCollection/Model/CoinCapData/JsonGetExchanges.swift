//
//  CoinCapData.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 22/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

struct JsonGetExchanges: Decodable {
    let data: [getExchanges]
}

struct getExchanges: Decodable {
    let exchangeId: String
    let name: String
    let rank: String
    let percentTotalVolume: String?
    let volumeUsd: String?
    let tradingPairs: String?
    let socket: Bool?
    let exchangeUrl: String
    let updated: Int
}
