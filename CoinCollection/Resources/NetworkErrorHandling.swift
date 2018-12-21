//
//  NetworkErrorHandling.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


class NetworkErrorHandling {


    
    func showModal(_ header: String, _ message: String) -> UINavigationController {
        let popUpVC = PopUpViewController()
        
        popUpVC.headerText = header
        popUpVC.errorMessageLabelText = message
        
        let navigationController = UINavigationController(rootViewController: popUpVC)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        return navigationController
    }
    
    func noInternetModal() -> UINavigationController {
        let headerText = "No Internet"
        let errorMessage = "Please connect to the internet to use this app"
        let nav = showModal(headerText, errorMessage)
        return nav
        }
}
