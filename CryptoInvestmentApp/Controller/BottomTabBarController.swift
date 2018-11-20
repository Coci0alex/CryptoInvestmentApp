//
//  BottomTabBarController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 02/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class BottomTabBarController: UITabBarController {

    let someService = Service.sharedInstance
    let coreData = CoreDataStack.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cryptoTableViewController = CryptoTableViewController(someService: someService, coreData: coreData)
        let top100CoinView = UINavigationController(rootViewController: cryptoTableViewController)
        top100CoinView.tabBarItem.title = "Top 100"

        let tabBarList = [createNavControllerWithTitle(title: "Home", viewController: UIViewController()), top100CoinView, createNavControllerWithTitle(title: "News", viewController: UIViewController()), createNavControllerWithTitle(title: "Settings", viewController: UIViewController())]
        
        viewControllers = tabBarList
    }
    
    private func createNavControllerWithTitle(title: String, imageName: String? = nil, viewController: UIViewController) -> UINavigationController {
        let newViewController = viewController
        let navController = UINavigationController(rootViewController: newViewController)
        navController.tabBarItem.title = title
        return navController
    }
}
