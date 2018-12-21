//
//  SettingsViewController.swift
//  CryptoInvestmentAPp
//
//  Created by Alexander Carlsen on 13/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let comingSoonLabel: UILabel = {
            let label = UILabel()
            label.text = "Coming Soon..."
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        view.addSubview(comingSoonLabel)
        comingSoonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        comingSoonLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        comingSoonLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        comingSoonLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
