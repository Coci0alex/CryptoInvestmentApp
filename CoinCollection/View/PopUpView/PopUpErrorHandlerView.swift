//
//  PopUpView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 17/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol popUpDelegate: class {
    func didTapOk()
}

class PopUpErrorHandlerView: UIView {
    
    let screenSize = UIScreen.main.bounds
    
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "No Internet"
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 100)
        return label
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 100)
        return label
    }()
    
    let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blue.cgColor
        return view
    }()
    
    let popUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(popUpButtonAction), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = false
        return button
    }()
    weak var delegate: popUpDelegate?
    
    @objc func popUpButtonAction() {
        self.removeFromSuperview()
        delegate?.didTapOk()
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: screenSize.height).isActive = true

        popUpView.translatesAutoresizingMaskIntoConstraints = false
        popUpView.widthAnchor.constraint(equalToConstant: screenSize.width/2.5).isActive = true
        popUpView.heightAnchor.constraint(equalTo: popUpView.widthAnchor, multiplier: 1/2).isActive = true
        popUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        popUpButton.translatesAutoresizingMaskIntoConstraints = false
        popUpButton.widthAnchor.constraint(equalTo: popUpView.widthAnchor, multiplier: 0.4).isActive = true
        popUpButton.heightAnchor.constraint(equalTo: popUpView.heightAnchor, multiplier: 0.2).isActive = true
        popUpButton.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        popUpButton.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor).isActive = true
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.widthAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalTo: popUpView.heightAnchor, multiplier: 0.16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: popUpView.centerYAnchor, constant: -25).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.adjustsFontSizeToFitWidth = true
        errorMessageLabel.widthAnchor.constraint(equalTo: popUpView.widthAnchor).isActive = true
        errorMessageLabel.heightAnchor.constraint(equalTo: popUpView.heightAnchor, multiplier: 0.32).isActive = true
        errorMessageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5).isActive = true
        errorMessageLabel.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor).isActive = true
    }

    func setupViews() {
        self.addSubview(popUpView)
        popUpView.addSubview(popUpButton)
        popUpView.addSubview(errorMessageLabel)
        popUpView.addSubview(headerLabel)
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}