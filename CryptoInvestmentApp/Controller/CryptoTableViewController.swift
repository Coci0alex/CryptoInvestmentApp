//
//  CryptoTableViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import CoreData

class CryptoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let someService: Service
    let coreData: CoreDataStack
    init(someService: Service, coreData: CoreDataStack) {
        self.someService = someService
        self.coreData = coreData
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coins = [CoinProperties]()
    var logoURLs = [URL]()
    var jsonCoinLogoURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol="
    var cryptoSymbols = [String]()
    let tableView = CurrencyTableView()
    let loadActivity = ActivityIndicatorView()
    var myTableView = UITableView()
    var cryptoLogos = [UIImage]()
    let group = DispatchGroup()
    let screenSize = UIScreen.main.bounds
    var Ascending = [Bool] (repeating: true, count: 4)
    
    /// CMC = CoinMarketCap: Pass Core Data Object ///
    var coinDataCMC = [CoinData]()
    
    let navigationBar = NavigationBarView()
    let statusCodeOk = 200
    let statusCodeFail = 404
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Top 100 Cryptocurrencies"
        let indicator = loadActivity.activityIndicator
        let nav = navigationBar.navBar
        view.addSubview(nav)

        view.backgroundColor = .white
        
        setupTableView()
        setupTableViewConstraints()
        myTableView.addSubview(indicator)
        indicator.startAnimating()
        
        /// ensures that the activity indicator stays rendered while getting coinData ///
        DispatchQueue.main.async {
            self.checkNetworkErrors(statusCode: self.getCoinData())
            indicator.stopAnimating()
        }
    }
    
    func showModal(_ header: String, _ message: String) {
        let popUpVC = PopUpViewController()
        
        popUpVC.headerText = header
        popUpVC.errorMessageLabelText = message
        
        let navigationController = UINavigationController(rootViewController: popUpVC)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }

                // MARK: - Table view data source
        func tableView(_ tableVew: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UIScreen.main.bounds.height/30
        }
    
         func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return coinDataCMC.count
        }
  
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headeren = myTableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
            headeren.contentView.backgroundColor = .black
            headeren.delegate = self
            return headeren
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UIScreen.main.bounds.height/18//Choose your custom row height
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! CurrencyCellView
            cell.backgroundColor = UIColor.clear
            cell.rankLabel.text = String(coinDataCMC[indexPath.row].rank)
            cell.coinLogo.image = UIImage(data: (coinDataCMC[indexPath.row].logo as Data?)!)
            cell.coinName.text = coinDataCMC[indexPath.row].name
            cell.coinPrice.textColor = .magenta
            cell.coinPrice.text = "$" + String(coinDataCMC[indexPath.row].price)
            cell.coinSymbol.text = coinDataCMC[indexPath.row].symbol
            
             if coinDataCMC[indexPath.row].rate < 0 {
             cell.rateChange24h.textColor = .red
             }
             else {
             cell.rateChange24h.textColor = .green
             }
            cell.rateChange24h.text = String(coinDataCMC[indexPath.row].rate) + "%"
            return cell
        }
    
        func getCoinSymbols() -> Int  {
            var statusCodeInFunc = 0
            
            self.someService.fetchCoinData { (JsonCoinProperties, response, err) in

                if let response = response as? HTTPURLResponse, let url = response.url {
                    let statusCode = response.statusCode
                    let url = url
                    print("getCoinSymbols - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                    statusCodeInFunc = statusCode
                }
                    
                if let err = err {
                    print("getCoinSymbols Throwed An Error: ", err)
                    return
                }
                guard let getJson = JsonCoinProperties else { return  }
                
                for i in 0..<getJson.data.count {
                    self.cryptoSymbols.append(getJson.data[i].symbol)
                    
                    if i == getJson.data.count-1 {
                        self.jsonCoinLogoURL.append(getJson.data[i].symbol)
                    }
                    else {
                        self.jsonCoinLogoURL.append(getJson.data[i].symbol + ",")
                    }
                }
                self.someService.jsonCoinLogoURL = self.jsonCoinLogoURL
            }
            return statusCodeInFunc
        }
    
    func getCoinLogos() ->Int {
        var statusCodeInFunc = 0
        self.someService.fetchCoinLogos { (getJsonCoinLogo, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                let statusCode = response.statusCode
                let url = url
                print("getCoinLogos - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                statusCodeInFunc = statusCode
            }
            
            if let err = err {
                print("getCoinLogos Throwed An Error: ", err)
                return
            }
            
            guard let json = getJsonCoinLogo else { return }
            let newChar: [Character] = ["3","2","x","3","2"]
            for i in 0..<json.data.count {
                var tempString = json.data[self.cryptoSymbols[i]]!.logo
                var counter = 0
                for i in 46..<51 {
                    tempString = self.replaceChars(myString: tempString, index: i, newChar: newChar[counter])
                    counter += 1
                }
                guard let imageURL = URL(string: tempString) else { return }
                self.logoURLs.append(imageURL)
            }
        }
        return statusCodeInFunc
    }
    
    func getFinalCoinData() -> Int {
        var statusCodeInFunc = 0
        self.someService.fetchCoinData { (JsonCoinProperties, response, err) in
            
            if let response = response as? HTTPURLResponse, let url = response.url {
                let statusCode = response.statusCode
                let url = url
                print("getCoinSymbols - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
                statusCodeInFunc = statusCode
            }
            
            if let err = err {
                print("getFinalCoinData Throwed An Error: ", err)
                return
            }
            
            guard let json = JsonCoinProperties else { return }
            
            for i in 0..<self.logoURLs.count {
                let imageData = try? Data(contentsOf: self.logoURLs[i])
                self.cryptoLogos.append(UIImage(data: imageData!)!)
            }
            
            for i in 0..<json.data.count {
                let rank = json.data[i].cmc_rank
                let logo = self.cryptoLogos[i]
                let name =  json.data[i].name
                let symbol = "(" + json.data[i].symbol + ")"
                var price = json.data[i].quote.USD.price
                let marketCap = json.data[i].quote.USD.market_cap
                let rateChange = Double(json.data[i].quote.USD.percent_change_24h).rounded(toPlaces: 2)
                
                if price <= 1 {
                    price = price.rounded(toPlaces: 5)
                }
                else {
                    price = price.rounded(toPlaces: 2)
                }
                
                let currencyOne = CoinProperties(rank: rank, logoImage: logo, name: name, symbol: symbol, price: price , marketCap: String(marketCap), rateChange: rateChange)
                self.coins.append(currencyOne!)
            }
        }
        return statusCodeInFunc
    }
    
    func getCoinData() -> Int {
        var statusCode = self.getCoinSymbols()
        if statusCode == self.statusCodeOk {
            statusCode = self.getCoinLogos()
            
            if statusCode == self.statusCodeOk {
                statusCode = self.getFinalCoinData()
                
                if statusCode == self.statusCodeOk {
                    if self.coinDataCMC.count == 0 {
                        for coin in self.coins {
                            let saveCoinData = CoinData(context: self.coreData.context)
                            
                            saveCoinData.rank = Int32(coin.rank)
                            saveCoinData.logo = UIImagePNGRepresentation(coin.logoImage) as NSData?
                            saveCoinData.name = coin.name
                            saveCoinData.price = coin.price
                            saveCoinData.symbol = coin.symbol
                            saveCoinData.rate = coin.rateChange
                            self.coreData.saveContext()
                        }
                    }
                        
                        /// coins will only be filled with data if finalCoinData is retrieved successfully ////
                    else if self.coinDataCMC.count > 0 && self.coins.count > 0 {
                        for i in 0..<self.coinDataCMC.count {
                            self.coinDataCMC[i].rank = Int32(self.coins[i].rank)
                            self.coinDataCMC[i].logo = UIImagePNGRepresentation(self.coins[i].logoImage) as NSData?
                            self.coinDataCMC[i].name = self.coins[i].name
                            self.coinDataCMC[i].symbol = self.coins[i].symbol
                            self.coinDataCMC[i].price = self.coins[i].price
                            self.coinDataCMC[i].rate = self.coins[i].rateChange
                            self.coreData.saveContext()
                            print("UPDATING")
                        }
                    }
                    self.fetchCoins()
                    self.myTableView.reloadData()
                }
            }
        }
        return statusCode
    }
    
    /// Fetches Coins From CoreData ///
    func fetchCoins() {
        let fetchRequest: NSFetchRequest<CoinData> = CoinData.fetchRequest()
        
        do {
            let coinDataCMC = try CoreDataStack.shared.context.fetch(fetchRequest)
            self.coinDataCMC = coinDataCMC
        } catch {}
    }
    
    func replaceChars(myString: String, index: Int, newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
   
    func setupTableViewConstraints() {
        myTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
        myTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupTableView() {
        myTableView = tableView.currencyTableView
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
        self.fetchCoins()
        myTableView.reloadData()
    }
    
    func setupActivityIndicator() {
        myTableView.addSubview(loadActivity)
        loadActivity.startAnimating()
    }
    
    func checkNetworkErrors(statusCode: Int) {
        let statusCode = statusCode
        
        if statusCode == self.statusCodeFail  {
            let headerText = "No Internet"
            let errorMessage = "Please connect to the internet to use this app"
            self.showModal(headerText, errorMessage)
        }
        else if statusCode != self.statusCodeOk {
            let headerText = "Error"
            let errorMessage = "Apoligies something went wrong. Please try again later..."
            self.showModal(headerText, errorMessage)
        }
    }
}


        
extension CryptoTableViewController: sortDelegate {

    func didTapRankBtn() {
        self.coinDataCMC.sort(by: { Ascending[0] ? $0.rank > $1.rank : $0.rank < $1.rank })
        Ascending[0] = !Ascending[0]
        myTableView.reloadData()
    }

    func didTapCoinNameBtn() {
        self.coinDataCMC.sort(by: { Ascending[1] ? $0.name! > $1.name! : $0.name! < $1.name! })
        Ascending[1] = !Ascending[1]
        myTableView.reloadData()
    }
            
    func didTapPriceBtn() {
        self.coinDataCMC.sort(by: { Ascending[2] ? $0.price > $1.price : $0.price < $1.price })
        Ascending[2] = !Ascending[2]
        myTableView.reloadData()
    }
                
    func didTapRateBtn() {
        self.coinDataCMC.sort(by: { Ascending[3] ? $0.rate > $1.rate : $0.rate < $1.rate })
        Ascending[3] = !Ascending[3]
        myTableView.reloadData()
    }
}


extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

