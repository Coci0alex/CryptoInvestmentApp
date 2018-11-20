//
//  Servic.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import Foundation

class Service {

    static var sharedInstance = Service()
    
    let group = DispatchGroup()
    
    var jsonCoinLogoURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol="

     func fetchCoinData(completion: @escaping (JsonCoinProperties?, URLResponse?, Error?) ->() ) {
        group.enter()

        guard let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest") else { return }
        var request = URLRequest(url: url)
        request.setValue("b1b01e07-530b-4a4b-8bfd-8ad2ed7831e4", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard let data = data else { return }
            guard let response = response else { return }

            do {
                let json = try JSONDecoder().decode(JsonCoinProperties.self, from: data)
                completion(json, response, nil)
            }
                
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
        }.resume()
        group.wait()
    }
    
    func fetchCoinLogos(completion: @escaping (JsonCoinLogoData?, URLResponse?, Error?) -> () ) {
        group.enter()

        guard let url = URL(string: jsonCoinLogoURL) else { return }
        var request = URLRequest(url: url)
        request.setValue("b1b01e07-530b-4a4b-8bfd-8ad2ed7831e4", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard let data = data else { return }
            guard let response = response else { return }

            do {
                let cryptoLogo = try JSONDecoder().decode(JsonCoinLogoData.self, from: data)
                    completion(cryptoLogo, response, nil)
            }
            
            catch let jsonErr {
                completion(nil, response, jsonErr)
            }
            self.group.leave()
            }.resume()
    group.wait()
    }
    

    
}
