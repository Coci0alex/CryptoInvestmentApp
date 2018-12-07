//
//  AddTransactionTableViewController+networking.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


extension AddTransactionTableViewController {
    
    func fetchData() -> Int {
        
        var statusCode = 0
        let exchangeDataUrl = "https://api.coincap.io/v2/markets?baseSymbol=" + coinData.buyPair + "&limit=1000"
        
        if getExchangesForCoin(url: exchangeDataUrl) == 200 {
            let marketPairsUrl = "https://api.coincap.io/v2/markets?exchangeId=" + coinData.exchangeId + "&baseSymbol=" + coinData.buyPair
            statusCode = getMarketsPairs(url: marketPairsUrl)
        }
        return statusCode
    }
    
    func getExchangesForCoin(url: String) -> Int {
        var statusCode = 0
        
        binanceService.fetchExchangeData(url: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("getExchangesForCoin Throwed An Error: ", error)
                return
            }
            
            guard let getJson = data else { return }
            
            for getData in 0..<getJson.data.count {
                let exchangeId = getJson.data[getData].exchangeId
                
                /// override the initialized element and store value to show in tableview cell ////
                if getData == 0 {
                    self.coinData.exchangeId = exchangeId
                    self.exchangeDataContainer.exchangeId[getData] = exchangeId
                } else {
                    
                    if !self.exchangeDataContainer.exchangeId.contains(exchangeId) {
                        
                        self.exchangeDataContainer.exchangeId.append(exchangeId)
                    }
                }
            }
            self.tableView.reloadData()
        }
        return statusCode
    }
    
    func getMarketsPairs(url: String) -> Int {
        var statusCode = 0
        
        binanceService.fetchExchangeData(url: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("getExchangesForCoin Throwed An Error: ", error)
                return
            }
            
            guard let getJson = data else { return }
            self.exchangeDataContainer.marketPair.removeAll()
            self.exchangeDataContainer.priceUSD.removeAll()
            
            for getData in 0..<getJson.data.count {
                let marketPair = self.coinData.buyPair + "/" + getJson.data[getData].quoteSymbol
                self.exchangeDataContainer.marketPair.append(marketPair)

                guard let priceUSD = getJson.data[getData].priceUsd else { return }
                
                if getData == 0 {
                    self.coinData.sellPair = getJson.data[getData].quoteSymbol
                    self.coinData.coinNameSell = getJson.data[getData].quoteId
                }
                if var price = Double(priceUSD) {
                    if price <= 1 {
                        price = price.rounded(toPlaces: 5)
                    }
                    else {
                        price = price.rounded(toPlaces: 2)
                   }
                    self.exchangeDataContainer.priceUSD.append(price)
                }
            }
            self.coinData.coinCost = String(self.exchangeDataContainer.priceUSD[0])
            self.tableView.reloadData()
        }
        return statusCode
    }
    
    func getNetworkResponse(response: HTTPURLResponse, url: URL) -> Int {
        let statusCode = response.statusCode
        let url = url
        print("getExchangesForCoin - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
        return statusCode
    }    
}
