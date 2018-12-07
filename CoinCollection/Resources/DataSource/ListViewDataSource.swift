//
//  ListViewDataSource.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 30/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class ListViewDataSource: NSObject, UITableViewDataSource {
    
    var list = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            cell.textLabel?.text = list[indexPath.row].capitalizingFirstLetter()
            return cell
    }
}
