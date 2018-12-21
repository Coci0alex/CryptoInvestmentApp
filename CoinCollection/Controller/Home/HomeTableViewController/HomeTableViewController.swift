//
//  UIViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 02/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import CoreData

final class HomeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let coinCapService: CoinCapServices
    let coreData: CoreDataStack
    let coinMarketCapService: CMCService
    
    init(someService: CoinCapServices, coreData: CoreDataStack, coinMarketCapService: CMCService) {
        self.coinCapService = someService
        self.coreData = coreData
        self.coinMarketCapService = coinMarketCapService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var homeTableView = UITableView()
    var coreDataCoins = [PortFolio]()
    var portfolioCoins = [AllCoinData]()
    var logoURLs = [URL]()
    var jsonCoinLogoURL = String()
    var candlesClose = [String]()
    var candlesOpen = [String]()
    
    let totalHoldings = UILabel()
    let totalCoins = UILabel()

    private let navigationBar = NavigationBarView()
    private var errorModal = NetworkErrorHandling()
    var Ascending = [Bool] (repeating: true, count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //   deleteAllCoins()
        fetchCoins()
        setupTableView()
        setupPortFolioView()
        setupNavigationUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        fetchCoins()
        didTapHoldingsBtn()
        homeTableView.reloadData()
       
        if !Reachability.isConnectedToNetwork() {
            let modal = errorModal.noInternetModal()
            self.present(modal, animated: false, completion: nil)
        } else if coreDataCoins.count != 0 {
            checkNetworkErrors(statusCode: self.updateCoinData())
            didTapHoldingsBtn()
            homeTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
    }
    
    func setupNavigationUI() {
        navigationBar.navigationDelegate = self
        self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0, green: 1, blue: 0.9874952435, alpha: 1)
        self.tabBarController?.tabBar.barTintColor = .black
        self.navigationItem.title = "Coin Collection"
        self.navigationItem.leftBarButtonItem = navigationBar.refreshButton
        self.navigationItem.rightBarButtonItem = navigationBar.addButton
    }
    
    func getCryptoLogos() {
        jsonCoinLogoURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol="
        
        for i in 0..<self.coreDataCoins.count {
            if i == self.coreDataCoins.count - 1 {
                if let buyPair = self.coreDataCoins[i].buyPair {
                    self.jsonCoinLogoURL.append(buyPair)
                }
            }
            else {
                if let buyPair = self.coreDataCoins[i].buyPair {
                    self.jsonCoinLogoURL.append(buyPair + ",")
                }
            }
        }
        self.coinMarketCapService.jsonCoinLogoURL = self.jsonCoinLogoURL
        
        if self.getCoinLogos() == 200 {
            for i in 0..<self.logoURLs.count {
                
                let imageData = try? Data(contentsOf: self.logoURLs[i])
                if let image = UIImage(data: imageData!) {
                    let coinLogo = image
                    self.coreDataCoins[i].logo = coinLogo.pngData() as NSData?
                }
            }
            self.fetchCoins()
            self.homeTableView.reloadData()
        }
    }
    
    func setupPortFolioView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "portFolioView")
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.bottomAnchor.constraint(equalTo: homeTableView.topAnchor, constant: -25).isActive = true
        imageView.widthAnchor.constraint(equalTo: homeTableView.widthAnchor, multiplier: 0.9).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        imageView.centerXAnchor.constraint(equalTo: homeTableView.centerXAnchor).isActive = true
        
        let totalHoldingsLabel = UILabel()
        totalHoldingsLabel.text = "Portfolio"
        imageView.addSubview(totalHoldingsLabel)
        totalHoldingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalHoldingsLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10).isActive = true
        totalHoldingsLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12.5).isActive = true
        totalHoldingsLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.3).isActive = true
        totalHoldingsLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3).isActive = true
        
        totalHoldings.text = "$0.00"
        imageView.addSubview(totalHoldings)
        totalHoldings.translatesAutoresizingMaskIntoConstraints = false
        
        totalHoldings.leadingAnchor.constraint(equalTo: totalHoldingsLabel.leadingAnchor).isActive = true
        totalHoldings.topAnchor.constraint(equalTo: totalHoldingsLabel.bottomAnchor).isActive = true
        totalHoldings.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.3).isActive = true
        totalHoldings.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3).isActive = true
        
        let totalCoinsLabel = UILabel()
        totalCoinsLabel.text = "Coins"
        imageView.addSubview(totalCoinsLabel)
        totalCoinsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        totalCoinsLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -25).isActive = true
        totalCoinsLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12.5).isActive = true
        totalCoinsLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.2).isActive = true
        totalCoinsLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3).isActive = true
        
        imageView.addSubview(totalCoins)
        totalCoins.text = "0.00"
        totalCoins.translatesAutoresizingMaskIntoConstraints = false
        totalCoins.adjustsFontSizeToFitWidth = true
        totalCoins.trailingAnchor.constraint(equalTo: totalCoinsLabel.trailingAnchor).isActive = true
        totalCoins.topAnchor.constraint(equalTo: totalCoinsLabel.bottomAnchor).isActive = true
        totalCoins.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.2).isActive = true
        totalCoins.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3).isActive = true
        
        let labelArray = [totalHoldingsLabel, totalHoldings, totalCoinsLabel, totalCoins]
        
        for i in 0..<labelArray.count {
            labelArray[i].font = UIFont.systemFont(ofSize: 100)
            labelArray[i].numberOfLines = 0
            labelArray[i].adjustsFontSizeToFitWidth = true
            labelArray[i].minimumScaleFactor = 0.1
            labelArray[i].lineBreakMode = NSLineBreakMode.byClipping
            labelArray[i].baselineAdjustment = UIBaselineAdjustment.alignCenters
        }
    }
   
    func calculate24HrRateChange(openPrice24Hr: Double, closePriceNow: Double) -> Double {
        let rateChange = (1 - (openPrice24Hr / closePriceNow)) * 100
        return rateChange.rounded(toPlaces: 2)
    }
    
    // MARK: - Table view data source
    func tableView(_ tableVew: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height/30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let homeHeader = homeTableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! HomeHeader
        homeHeader.delegate = self
        return homeHeader
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return coreDataCoins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/12//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedRow = self.coreDataCoins[indexPath.row]
        
        let coinInfoVC = CoinInfoViewController(someService: coinCapService)
        coinInfoVC.coinData = selectedRow
        coinInfoVC.delegate = self
        self.navigationController?.pushViewController(coinInfoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! HomeCellView
      
        cell.backgroundColor = UIColor.clear
        print(" ER HER NU")
        if let logo = coreDataCoins[indexPath.row].logo as Data? {
            let newLogo = UIImage(data: logo)
            cell.coinLogo.image = newLogo
        }

        cell.coinName.text = coreDataCoins[indexPath.row].coinNameBuy
        cell.coinPrice.text = "$" + String(coreDataCoins[indexPath.row].currentPrice)
        
        let holdingsUsd = coreDataCoins[indexPath.row].holdingsUsd
        cell.holdingsUsd.text = "$" + String(holdingsUsd)
        
        let rateChange = coreDataCoins[indexPath.row].rateChange
            if rateChange < 0 {
                cell.rateChange24h.textColor = .red
            } else if  rateChange > 0 {
                cell.rateChange24h.textColor = .green
                }
        
        cell.rateChange24h.text = String(rateChange) + "%"
        cell.holdingsCoin.text = String(coreDataCoins[indexPath.row].holdingsCoins)
        return cell
    }
    
    func setupTableView() {
        let tableView = HomeTableView()
        homeTableView = tableView.homeTableView
        homeTableView.delegate = self
        homeTableView.dataSource = self
        view.addSubview(homeTableView)
        homeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.3).isActive = true
        homeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        homeTableView.reloadData()
    }
    
    func checkNetworkErrors(statusCode: Int) {
            if statusCode != 200 {
            let headerText = "Error"
            let errorMessage = "Apoligies something went wrong. Please try again later..."
            let nav = errorModal.showModal(headerText, errorMessage)
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    
    /// Fetches Coins From CoreData ///
    func fetchCoins() {
        let fetchRequest: NSFetchRequest<PortFolio> = PortFolio.fetchRequest()
        
        do {
            let coreDataCoins = try CoreDataStack.shared.context.fetch(fetchRequest)
            self.coreDataCoins = coreDataCoins
        } catch {}
    }
    
    /// Deletes All Coins From CoreData ///
    func deleteAllCoins() {
        let fetchRequest: NSFetchRequest<PortFolio> = PortFolio.fetchRequest()
        

        do {
            let objects = try coreData.context.fetch(fetchRequest)
            for object in objects {
                coreData.context.delete(object)
            }
            coreData.saveContext()
        } catch {}
    }
    
    func replaceChars(myString: String, index: Int, newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}





