//
//  PortfolioCoins.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

struct AllCoinData {
    var coinId: String
    var coinNameBuy: String
    var coinNameSell: String
    var exchangeId: String
    var buyPair: String
    var sellPair: String
    var quantity: Double?
    var coinCost: String
    var currentPrice: Double?
    var totalCost: String
    var date: String
    var open24h: Double?
    var close24h: Double?
    var high24h: Double?
    var low24h: Double?
    var rateChange: Double?
    
    init(coinId: String, coinNameBuy: String, coinNameSell: String, exchangeId: String, buyPair: String, sellPair: String, priceUSD: String, totalCost: String, date: String) {
        
        self.coinId = coinId
        self.coinNameBuy = coinNameBuy
        self.coinNameSell = coinNameSell
        self.exchangeId = exchangeId
        self.buyPair = buyPair
        self.sellPair = sellPair
        self.coinCost = priceUSD
        self.totalCost = totalCost
        self.date = date
    }
}
