//
//  HomeTableView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 23/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class HomeTableView: UITableView {

    var homeTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.register(HomeCellView.self, forCellReuseIdentifier: "cellId")
        table.register(HomeHeader.self, forHeaderFooterViewReuseIdentifier: "headerId")
        table.separatorStyle = .none
        return table
    }()
    
    
    
}
