//
//  File.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 29/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class newViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "hej"
        return cell
    }
    
    
    let currencyCell = "CurrCell"
    
    var currencyTableView: UITableView = {
        let cryptoTable = UITableView()
        cryptoTable.translatesAutoresizingMaskIntoConstraints = false
        cryptoTable.backgroundColor = .white
        return cryptoTable
        
    }()
    
    override func viewDidLoad() {
        self.view.addSubview(currencyTableView)
        currencyTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        currencyTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        currencyTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        currencyTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        currencyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        currencyTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
       //self.currencyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")

        
        currencyTableView.delegate = self
        currencyTableView.dataSource = self

        print("HERJ MED DIG")
    }
}
