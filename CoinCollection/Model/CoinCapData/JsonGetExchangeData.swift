//
//  CoinCapData.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 22/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

struct JsonGetExchangeData: Decodable {
    let data: [getExchangeData]
}

struct getExchangeData: Decodable {
    let exchangeId: String
    let rank: String?
    let baseSymbol: String
    let baseId: String
    let quoteSymbol: String
    let quoteId: String
    let priceQuote: String?
    let priceUsd: String?
    let volumeUsd24Hr: String?
    let percentExchangeVolume: String?
    let tradesCount24Hr: String?
    let updated: Int?
}
