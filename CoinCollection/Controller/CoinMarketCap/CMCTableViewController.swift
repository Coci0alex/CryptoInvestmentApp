//
//  CryptoTableViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 04/10/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit
import CoreData

class CMCTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let coinMarketCapService: CMCService
    let coreData: CoreDataStack
    
    init(someService: CMCService, coreData: CoreDataStack) {
        self.coinMarketCapService = someService
        self.coreData = coreData
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var coins = [CoinMarketCapCoinProperties]()
    var logoURLs = [URL]()
    var jsonCoinLogoURL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?symbol="
    var cryptoSymbols = [String]()
    let tableView = CoinTableView()
    let loadActivity = ActivityIndicatorView()
    var myTableView = UITableView()
    var cryptoLogos = [UIImage]()
    let group = DispatchGroup()
    let screenSize = UIScreen.main.bounds
    var Ascending = [Bool] (repeating: true, count: 4)
    private let errorModal = NetworkErrorHandling()
    
    private var filteredCoins = [CoinData]()
    private var searching  = false
    private let searchBarUI = UISearchBar()

    /// CMC = CoinMarketCap: Pass Core Data Object ///
    var coinDataCMC = [CoinData]()
    
    let navigationBar = NavigationBarView()

    let statusCodeOk = 200
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPushed))
    }
    
    @objc func refreshButtonPushed() {
            self.checkNetworkErrors(statusCode: self.getCoinData())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let indicator = loadActivity.activityIndicator
        
        setupTableView()
        setupTableViewConstraints()
        setupSearchBar()

        myTableView.addSubview(indicator)
        myTableView.separatorColor = .blue
        
        indicator.startAnimating()
        if !Reachability.isConnectedToNetwork() {
            let modal = errorModal.noInternetModal()
            self.present(modal, animated: false, completion: nil)
            indicator.stopAnimating()
        } else {
            /// ensures that the activity indicator stays rendered while getting coinData ///
            DispatchQueue.main.async {
                self.checkNetworkErrors(statusCode: self.getCoinData())
                indicator.stopAnimating()
            }
        }
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBarUI.endEditing(true)
    }
    
    func setupSearchBar() {
        
        view.addSubview(searchBarUI)
        searchBarUI.translatesAutoresizingMaskIntoConstraints = false
        searchBarUI.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchBarUI.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBarUI.bottomAnchor.constraint(equalTo: myTableView.topAnchor, constant: -5).isActive = true
        searchBarUI.heightAnchor.constraint(equalToConstant: screenSize.height / 15).isActive = true
        searchBarUI.backgroundColor = .blue
        searchBarUI.showsCancelButton = false
        
        let textFieldInsideSearchBar = searchBarUI.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .blue
        textFieldInsideSearchBar?.placeholder = "Search for coins"
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.blue
        searchBarUI.delegate = myTableView.delegate as? UISearchBarDelegate
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
            if searching {
                return filteredCoins.count
            } else {
                return coinDataCMC.count
            }
        }
  
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headeren = myTableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! CoinHeader
            headeren.contentView.backgroundColor = .blue
            headeren.delegate = self
            return headeren
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBarUI.endEditing(true)
    }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UIScreen.main.bounds.height/18//Choose your custom row height
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! CoinCellView
            cell.selectionStyle = .none
            
            if !searching {
                cell.rankLabel.text = String(coinDataCMC[indexPath.row].rank)
                cell.coinLogo.image = UIImage(data: (coinDataCMC[indexPath.row].logo as Data?)!)
                cell.coinName.text = coinDataCMC[indexPath.row].name
                cell.coinPrice.textColor = .magenta
                cell.coinPrice.text = "$" + String(coinDataCMC[indexPath.row].price)
                
                 if coinDataCMC[indexPath.row].rate < 0 {
                 cell.rateChange24h.textColor = .red
                 }
                 else {
                 cell.rateChange24h.textColor = .green
                 }
                cell.rateChange24h.text = String(coinDataCMC[indexPath.row].rate) + "%"
                return cell
            } else {
                cell.rankLabel.text = String(filteredCoins[indexPath.row].rank)
                cell.coinLogo.image = UIImage(data: (filteredCoins[indexPath.row].logo as Data?)!)
                cell.coinName.text = filteredCoins[indexPath.row].name
                cell.coinPrice.textColor = .magenta
                cell.coinPrice.text = "$" + String(filteredCoins[indexPath.row].price)
                
                if filteredCoins[indexPath.row].rate < 0 {
                    cell.rateChange24h.textColor = .red
                }
                else {
                    cell.rateChange24h.textColor = .green
                }
                cell.rateChange24h.text = String(filteredCoins[indexPath.row].rate) + "%"
                return cell
            }
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
        myTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.2).isActive = true
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupTableView() {
        myTableView = tableView.currencyTableView
        myTableView.delegate = self
        myTableView.dataSource = self
        view.addSubview(myTableView)
        self.fetchCoins()
        self.myTableView.tableFooterView = UIView()
        myTableView.reloadData()
    }
    
    func setupActivityIndicator() {
        myTableView.addSubview(loadActivity)
        loadActivity.startAnimating()
    }
    
    func checkNetworkErrors(statusCode: Int) {
            if statusCode != self.statusCodeOk {
            let headerText = "Error"
            let errorMessage = "Apoligies something went wrong. Please try again later..."
            self.showModal(headerText, errorMessage)
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CMCTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredCoins = self.coinDataCMC.filter( {$0.name!.localizedCaseInsensitiveContains(searchText) ||  $0.name!.localizedCaseInsensitiveContains(searchText)} )
            searching = true
            myTableView.reloadData()
        } else {
            searching = false
            myTableView.reloadData()
        }
    }
}

