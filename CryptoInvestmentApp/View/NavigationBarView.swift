//
//  NavigationBarViw.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 18/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//
import UIKit

class NavigationBarView: UINavigationBar  {
    
    let navBar: UINavigationBar = {
        let bar = UINavigationBar(frame: CGRect(x: 0, y:30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/18))
        let navItem = UINavigationItem(title: "Coin Market Top 100")
        bar.backgroundColor = .blue
        //let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(whenClicked));
        //navItem.leftBarButtonItem = doneItem;
        bar.setItems([navItem], animated: true)
        //bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    
}
