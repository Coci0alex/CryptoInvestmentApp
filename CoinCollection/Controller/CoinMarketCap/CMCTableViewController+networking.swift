//
//  CMCTableViewController+networkRequest.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 22/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//


import UIKit

extension CMCTableViewController  {
    
    /// Handle network requests ///
    func getCoinSymbols() -> Int  {
        var statusCodeInFunc = 0
        self.jsonCoinLogoURL.removeAll()
        jsonCoinLogoURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol="

        self.coinMarketCapService.fetchCoinData { (JsonCoinProperties, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                let statusCode = response.statusCode
                let url = url
                print("getCoinSymbols - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                statusCodeInFunc = statusCode
            }
            
            if let err = err {
                print("getCoinSymbols Throwed An Error: ", err)
                return
            }
            guard let getJson = JsonCoinProperties else { return  }
            
            for i in 0..<getJson.data.count {
                self.cryptoSymbols.append(getJson.data[i].symbol)
                
                if i == getJson.data.count-1 {
                    self.jsonCoinLogoURL.append(getJson.data[i].symbol)
                }
                else {
                    self.jsonCoinLogoURL.append(getJson.data[i].symbol + ",")
                }
            }
            self.coinMarketCapService.jsonCoinLogoURL = self.jsonCoinLogoURL
        }
        return statusCodeInFunc
    }
    
    func getCoinLogos() ->Int {
        var statusCodeInFunc = 0
        self.logoURLs.removeAll()
        self.coinMarketCapService.fetchCoinLogos { (getJsonCoinLogo, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                let statusCode = response.statusCode
                let url = url
                print("getCoinLogos - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                statusCodeInFunc = statusCode
            }
            
            if let err = err {
                print("getCoinLogos Throwed An Error: ", err)
                return
            }
            
            guard let json = getJsonCoinLogo else { return }
            let newChar: [Character] = ["3","2","x","3","2"]
            for i in 0..<json.data.count {
                if let symbol = json.data[self.cryptoSymbols[i]] {
                    var tempString = symbol.logo
                    var counter = 0
                    for i in 46..<51 {
                        tempString = self.replaceChars(myString: tempString, index: i, newChar: newChar[counter])
                        counter += 1
                    }
                    guard let imageURL = URL(string: tempString) else { return }
                    self.logoURLs.append(imageURL)
                }
            }
        }
        return statusCodeInFunc
    }
    
    func getFinalCoinData() -> Int {
        var statusCodeInFunc = 0
        coins.removeAll()
        self.coinMarketCapService.fetchCoinData { (JsonCoinProperties, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                let statusCode = response.statusCode
                let url = url
                print("getCoinSymbols - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                statusCodeInFunc = statusCode
            }
            
            if let err = err {
                print("getFinalCoinData Throwed An Error: ", err)
                return
            }
            
            guard let json = JsonCoinProperties else { return }
            
            for i in 0..<self.logoURLs.count {
                let imageData = try? Data(contentsOf: self.logoURLs[i])
                self.cryptoLogos.append(UIImage(data: imageData!)!)
            }
            
            for i in 0..<json.data.count {
                let rank = json.data[i].cmc_rank
                let logo = self.cryptoLogos[i]
                let symbol = "(" + json.data[i].symbol + ")"
                let name =  json.data[i].name + "  " + symbol
                var price = json.data[i].quote.USD.price
                let marketCap = json.data[i].quote.USD.market_cap
                let rateChange = Double(json.data[i].quote.USD.percent_change_24h).rounded(toPlaces: 2)
                
                if price <= 1 {
                    price = price.rounded(toPlaces: 5)
                }
                else {
                    price = price.rounded(toPlaces: 2)
                }
                
                let currencyOne = CoinMarketCapCoinProperties(rank: rank, logoImage: logo, name: name, symbol: symbol, price: price , marketCap: String(marketCap), rateChange: rateChange)
                self.coins.append(currencyOne!)
            }
        }
        return statusCodeInFunc
    }
    
    func getCoinData() -> Int {
        var statusCode = self.getCoinSymbols()
        if statusCode == self.statusCodeOk {
            statusCode = self.getCoinLogos()
            
            if statusCode == self.statusCodeOk {
                statusCode = self.getFinalCoinData()
                
                if statusCode == self.statusCodeOk {
                    if self.coinDataCMC.count == 0 {
                        for coin in self.coins {
                            let saveCoinData = CoinData(context: self.coreData.context)
                            
                            saveCoinData.rank = Int32(coin.rank)
                            saveCoinData.logo = coin.logoImage.pngData() as NSData?
                            saveCoinData.name = coin.name
                            saveCoinData.price = coin.price
                            saveCoinData.symbol = coin.symbol
                            saveCoinData.rate = coin.rateChange
                            self.coreData.saveContext()
                        }
                    }
                        
                        /// coins will only be filled with data if finalCoinData is retrieved successfully ////
                    else if self.coinDataCMC.count > 0 && self.coins.count > 0 {
                        for i in 0..<self.coinDataCMC.count {
                            self.coinDataCMC[i].rank = Int32(self.coins[i].rank)
                            self.coinDataCMC[i].logo = self.coins[i].logoImage.pngData() as NSData?
                            self.coinDataCMC[i].name = self.coins[i].name
                            self.coinDataCMC[i].symbol = self.coins[i].symbol
                            self.coinDataCMC[i].price = self.coins[i].price
                            self.coinDataCMC[i].rate = self.coins[i].rateChange
                            self.coreData.saveContext()
                            print("UPDATING")
                        }
                    }
                    self.fetchCoins()
                    self.myTableView.reloadData()
                }
            }
        }
        return statusCode
    }
}
