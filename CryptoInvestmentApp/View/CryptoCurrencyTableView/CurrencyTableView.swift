//
//  currencyTableView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 29/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


class CurrencyTableView: UITableView {
    
    let currencyCell = "CurrCell"
    
    var currencyTableView: UITableView = {
        let cryptoTable = UITableView()
        cryptoTable.translatesAutoresizingMaskIntoConstraints = false
        cryptoTable.backgroundColor = .white
        cryptoTable.register(CurrencyCellView.self, forCellReuseIdentifier: "cellId")
        cryptoTable.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        return cryptoTable
 
    }()
    
}

