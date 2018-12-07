//
//  AddTransactionHeaderView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


class AddTransactionHeaderView: UITableViewHeaderFooterView {
    
    lazy var saveBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 45))
        button.backgroundColor = .cyan
        button.setTitle("Save Transaction", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(AddTransactionTableViewController.didTapSaveBuyTransaction), for: .touchUpInside)
        return button
    }()
    
    
    let buyBtn: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Buy", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    let sellBtn: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Sell", for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    let watchBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        button.setTitle("Watch", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    let container: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    
    
    func setupHeaderViews() {
    addSubview(container)
    container.addSubview(buyBtn)
    container.addSubview(sellBtn)
    container.addSubview(watchBtn)        
    setupConstraints()
        
    }

    func setupConstraints() {
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        container.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        buyBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buyBtn.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        buyBtn.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        
        sellBtn.translatesAutoresizingMaskIntoConstraints = false
        sellBtn.leadingAnchor.constraint(equalTo: buyBtn.trailingAnchor).isActive = true
        sellBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sellBtn.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        sellBtn.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
        
        watchBtn.translatesAutoresizingMaskIntoConstraints = false
        watchBtn.leadingAnchor.constraint(equalTo: sellBtn.trailingAnchor).isActive = true
        watchBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        watchBtn.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        watchBtn.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHeaderViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    

}
