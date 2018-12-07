//
//  NavigationBarViw.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 18/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//
import UIKit

protocol navigationItemDelegate: class {
    func didTapAddCoin()
    func refreshButtonPushed()
}

class NavigationBarView: UINavigationBar  {
    
    lazy var refreshButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(refreshButtonPushed))
        return button
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonPushed))
        return button
    }()
    
    weak var navigationDelegate: navigationItemDelegate?
    
    @objc func refreshButtonPushed()
    { navigationDelegate?.refreshButtonPushed() }
    
    @objc func addButtonPushed()
    { navigationDelegate?.didTapAddCoin() }

}
