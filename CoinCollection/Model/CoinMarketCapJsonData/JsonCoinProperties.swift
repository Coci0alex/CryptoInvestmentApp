//
//  jsonData.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation

struct JsonCoinProperties: Decodable {
    let status: jsonStatus
    let data: [jsonData]
}

struct jsonStatus: Decodable {
    let timestamp: String
    let error_code: Int
    let error_message: String?
    let elapsed: Int
    let credit_count: Int
    
    }

struct jsonData: Decodable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let circulating_supply: Double?
    let total_supply: Double?
//    let max_supply: Double?
 //   let date_added: String
//a    let num_market_pairs: Int
    let cmc_rank: Int
    let last_updated: String
    let quote: Quote
    
}

struct Quote: Decodable {
    let USD: usd
}

struct usd: Decodable {
    let price: Double
    let volume_24h: Double
    let percent_change_1h: Double
    let percent_change_24h: Double
    let percent_change_7d: Double
    let market_cap: Double
    let last_updated: String

}
