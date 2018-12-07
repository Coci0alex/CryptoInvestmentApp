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
   //     self.present(navigationController, animated: false, completion: nil)
        return navigationController
    }
    
    func noInternetModal() -> UINavigationController {
        let headerText = "No Internet"
        let errorMessage = "Please connect to the internet to use this app"
        let nav = showModal(headerText, errorMessage)
        return nav
        }
}
//
//    func testNetwork() -> [String] {
//        if !Reachability.isConnectedToNetwork() {
//            let header = "No Internet"
//            let message = "Please connect to the internet to use this app"
//            let response: [String] = [header, message]
//            return response
//        }
//        return ["Is Connected"]
//
//            //              statusCode = 404
////            let headerText = "No Internet"
////            let errorMessage = "Please connect to the internet to use this app"
////            showModal(headerText, errorMessage)
////        } else if statusCode != self.statusCodeOk {
////            return statusCode
////            let headerText = "Error"
////            let errorMessage = "Apoligies something went wrong. Please try again later..."
////            showModal(headerText, errorMessage)
//    }
