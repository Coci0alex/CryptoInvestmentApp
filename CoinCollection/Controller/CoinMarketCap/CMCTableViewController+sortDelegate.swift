//
//  CoinTableViewController+sortDelegate.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 22/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

extension CMCTableViewController: sortDelegate {
        // Sorting Functions //
        func didTapRankBtn() {
            self.coinDataCMC.sort(by: { Ascending[0] ? $0.rank > $1.rank : $0.rank < $1.rank })
            Ascending[0] = !Ascending[0]
            myTableView.reloadData()
        }
        
        func didTapCoinNameBtn() {
            self.coinDataCMC.sort(by: { Ascending[1] ? $0.name! > $1.name! : $0.name! < $1.name! })
            Ascending[1] = !Ascending[1]
            myTableView.reloadData()
        }
        
        func didTapPriceBtn() {
            self.coinDataCMC.sort(by: { Ascending[2] ? $0.price > $1.price : $0.price < $1.price })
            Ascending[2] = !Ascending[2]
            myTableView.reloadData()
        }
        
        func didTapRateBtn() {
            self.coinDataCMC.sort(by: { Ascending[3] ? $0.rate > $1.rate : $0.rate < $1.rate })
            Ascending[3] = !Ascending[3]
            myTableView.reloadData()
        }
    
    
    }
