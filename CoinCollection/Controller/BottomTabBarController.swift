//
//  BottomTabBarController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 02/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class BottomTabBarController: UITabBarController {

    let coinMarketCapService = CMCService.sharedCMCInstance
    let coreData = CoreDataStack.shared
    
    let coinCapService = CoinCapServices.sharedCoinCapInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coinMarketCapTableViewController = CMCTableViewController(someService: coinMarketCapService, coreData: coreData)
        
        let homeViewController = HomeTableViewController(someService: coinCapService, coreData: coreData, coinMarketCapService: coinMarketCapService)

        let tabBarList = [createNavControllerWithTitle(title: "Home", viewController: homeViewController), createNavControllerWithTitle(title: "Top 100", viewController: coinMarketCapTableViewController), createNavControllerWithTitle(title: "News", viewController: UIViewController()), createNavControllerWithTitle(title: "Settings", viewController: UIViewController())]
        
        viewControllers = tabBarList
    }
    
    private func createNavControllerWithTitle(title: String, imageName: String? = nil, viewController: UIViewController) -> UINavigationController {
        let newViewController = viewController
        let navController = UINavigationController(rootViewController: newViewController)
        navController.tabBarItem.title = title
        return navController
    }
}
