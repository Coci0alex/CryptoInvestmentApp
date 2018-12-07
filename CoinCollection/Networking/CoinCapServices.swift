//
//  BinanceService.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 22/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

final class CoinCapServices {
    
    static var sharedCoinCapInstance = CoinCapServices()
    private let errorModal = NetworkErrorHandling()
    let group = DispatchGroup()

    func fetchExchanges(url: String, completion: @escaping (JsonGetExchanges?, URLResponse?, Error?) ->() ) {
        group.enter()
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            guard let response = response else { return }
            
            do {
                let json = try JSONDecoder().decode(JsonGetExchanges.self, from: data)
                completion(json, response, nil)
            }
                
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
            }.resume()
        group.wait()
    }
    
    func fetchExchangeData(url: String, completion: @escaping (JsonGetExchangeData?, URLResponse?, Error?) ->() ) {
        group.enter()
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            guard let response = response else { return }
            
            do {
                let json = try JSONDecoder().decode(JsonGetExchangeData.self, from: data)
                completion(json, response, nil)
            }
                
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
            }.resume()
        group.wait()
    }

    func fetchCoins(url: String, completion: @escaping (JsonGetCoins?, URLResponse?, Error?) ->() ) {
        
        if !Reachability.isConnectedToNetwork() {
            print("NO INTERNET")
            return
        }
        group.enter()
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            guard let response = response else { return }
            
            do {
                let json = try JSONDecoder().decode(JsonGetCoins.self, from: data)
                completion(json, response, nil)
            }
                
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
            }.resume()
        group.wait()
    }
    
    func fetchCandles(url: String, completion: @escaping (JsonGetCandles?, URLResponse?, Error?) ->() ) {
       
        if !Reachability.isConnectedToNetwork() {
            print("NO INTERNET")
            return
        }
        group.enter()
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { print("KOM HER IND");return }
            guard let response = response else { return }
            
            do {
                let json = try JSONDecoder().decode(JsonGetCandles.self, from: data)
                completion(json, response, nil)
            }
                
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
            }.resume()
        group.wait()
    }
    
}
