//
//  currencyTableView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 29/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


class CoinTableView: UITableView {
    
    let currencyCell = "CurrCell"
    
    var currencyTableView: UITableView = {
        let cryptoTable = UITableView()
        cryptoTable.translatesAutoresizingMaskIntoConstraints = false
        cryptoTable.backgroundColor = .white
        cryptoTable.register(CoinCellView.self, forCellReuseIdentifier: "cellId")
        cryptoTable.register(CoinHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
        return cryptoTable
 
    }()
    
}

