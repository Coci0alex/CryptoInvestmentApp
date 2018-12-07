//
//  HomeTableViewController+Networking.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 02/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

extension HomeTableViewController {
    func fetchPrices(url: String, index: Int) -> Int {
        var statusCode = 0
        
        coinCapService.fetchExchangeData(url: url) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("fetchPrices Throwed An Error: ", error)
                return
            }
            
            guard let getJson = data else { return }
            
            
            for getData in getJson.data {
                
                if let priceUSD = getData.priceUsd {
                    
                    if var price = Double(priceUSD) {
                        if price <= 1 {
                            price = price.rounded(toPlaces: 5)
                        }
                        else {
                            price = price.rounded(toPlaces: 2)
                        }
                        self.coreDataCoins[index].currentPrice = price
                    }
                }
            }
            self.homeTableView.reloadData()
        }
        return statusCode
    }


    func fetchCandles(url: String, index: Int) -> Int {
        var statusCode = 0
        coinCapService.fetchCandles(url: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("getExchangesForCoin Throwed An Error: ", error)
                return
            }
            guard let getJson = data else { return }
            
            //// first data object is contains readings from 24 hours ago last one is from now ////
            for i in 0..<getJson.data.count {
                self.candlesClose.append(getJson.data[i].close)
                self.candlesOpen.append(getJson.data[i].open)
                
                if i == 0 {
                    if let open24h = Double(getJson.data[i].open) {
                        self.coreDataCoins[index].open24h = open24h
                    }
                }
                
                if i == getJson.data.count - 1 {
                    if let close24h = Double(getJson.data[i].open) {
                        
                        self.coreDataCoins[index].close24h = close24h
                    }
                }
            }
            self.homeTableView.reloadData()
        }
        return statusCode
    }
    
    func getCoinLogos() ->Int {
        var statusCode = 0
        logoURLs.removeAll()
        
        self.coinMarketCapService.fetchCoinLogos { (getJsonCoinLogo, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            
            if let err = err {
                print("getCoinLogos Throwed An Error: ", err)
                return
            }
            
            guard let json = getJsonCoinLogo else { return }
            let newChar: [Character] = ["3","2","x","3","2"]
            for i in 0..<json.data.count {
                if let symbol = self.coreDataCoins[i].buyPair {
                    var tempString = json.data[symbol]!.logo
                    var counter = 0
                    for i in 46..<51 {
                        tempString = self.replaceChars(myString: tempString, index: i, newChar: newChar[counter])
                        counter += 1
                    }
                    print("TEMPSTRING = :", tempString)
                    guard let imageURL = URL(string: tempString) else { return }
                    self.logoURLs.append(imageURL)
                }
            }
        }
        return statusCode
    }
    
    func updateCoinData() -> Int {
        
        var statusCode = 200
        var portfolio = 0.0
        var allCoins = 0.0
        for index in 0..<coreDataCoins.count {
            
            if let exchangeId = coreDataCoins[index].exchangeId, let coinId = coreDataCoins[index].coinId, let coinNameSell = coreDataCoins[index].coinNameSell {
                
                statusCode = fetchCandles(url: "https://api.coincap.io/v2/candles?exchange=" + exchangeId + "&interval=m1&baseId=" + coinId + "&quoteId=" + coinNameSell, index: index)
                
                let closePrice = coreDataCoins[index].close24h
                let openPrice = coreDataCoins[index].open24h
                
                let rateChange = calculate24HrRateChange(openPrice24Hr: openPrice, closePriceNow:  closePrice)
                coreDataCoins[index].rateChange = rateChange
                
                
                if statusCode != 200 {
                    return statusCode
                }
                
                statusCode = fetchPrices(url: "https://api.coincap.io/v2/markets?exchangeId=" + coreDataCoins[index].exchangeId! + "&baseSymbol=" + coreDataCoins[index].buyPair! + "&quoteSymbol=" + coreDataCoins[index].sellPair!, index: index)
                
                let currentPrice = coreDataCoins[index].currentPrice
                let holdingsCoins = coreDataCoins[index].holdingsCoins
                let totalHoldingsUsd = (currentPrice * holdingsCoins).rounded(toPlaces: 2)
                
                coreDataCoins[index].holdingsUsd = totalHoldingsUsd
                
                portfolio += totalHoldingsUsd
                allCoins += holdingsCoins
                homeTableView.reloadData()
            }
        }
        totalHoldings.text = "$" + String(portfolio.rounded(toPlaces: 2))
        totalCoins.text = String(allCoins.rounded(toPlaces: 2))
        homeTableView.reloadData()
        getCryptoLogos()
        return statusCode
    }

    func getNetworkResponse(response: HTTPURLResponse, url: URL) -> Int {
        let statusCode = response.statusCode
        let url = url
        print("fetchExchangeData - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
        return statusCode
    }
    
    
    
    

}
