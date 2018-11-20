//
//  ViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let coreData: CoreDataStack
    
    var coinData = [CoinData]()
    
    init(persistenceManager: CoreDataStack) {
        self.coreData = persistenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HJE")
        createCurrency()
        getCurrencies()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // create core data object
    func createCurrency() {
        let CurrencyToSave = CoinData(context: coreData.context)
        CurrencyToSave.name = "Alexander"
        coreData.saveContext()
        
    }
    
    func getCurrencies() {
        //guard let currenciesToSave = try! persistenceManager.context.fetch(CurrencyData.fetchRequest()) as? [CurrencyData] else { return }
        
        let fetchRequest: NSFetchRequest<CoinData> = CoinData.fetchRequest()
        
        do {
            let coinData = try CoreDataStack.shared.context.fetch(fetchRequest)
            coinData.forEach({print($0.name)})
            self.coinData = coinData
        } catch {}
        
        /*
        for i in coinData
            {
                print(i.name)
        }
 */
        
        
       // let currenciesToSave = coreData.fetch(CoinData.self)
      // currenciesToSave.forEach({print($0.name as Any)})
    }

}

