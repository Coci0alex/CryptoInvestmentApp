//
//  AddCoinViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 23/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol sendDataToHomeDelegate: class {
    func sendTransactionDataToHome(transactionData: AllCoinData)
}

final class SelectCoinTableViewController: UITableViewController {
  
    let coinCapService: CoinCapServices
    
    init(someService: CoinCapServices) {
        self.coinCapService = someService
        super.init(nibName: nil, bundle: nil)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addCoinTableView = UITableView()
    var coinId = [SimpleCoinData]()
    var filteredCoins = [SimpleCoinData]()
    var searching  = false
    var isSorted = false
    let searchBarUI = UISearchBar()
    private let errorModal = NetworkErrorHandling()
    
    weak var delegate: sendDataToHomeDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        

        let getCoinsUrl = "https://api.coincap.io/v2/assets?limit=500"
        if !Reachability.isConnectedToNetwork() {
            let modal = errorModal.noInternetModal()
            self.present(modal, animated: false, completion: nil)
        } else {
            checkNetworkErrors(statusCode: getCoins(url: getCoinsUrl))
        }
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBarUI.endEditing(true)
        if let cancelButton = searchBarUI.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
            view.addSubview(searchBarUI)
        }
    }
    
    func checkNetworkErrors(statusCode: Int) {
            if statusCode != 200 {
            let headerText = "Error"
            let errorMessage = "Apoligies something went wrong. Please try again later..."
            let nav = errorModal.showModal(headerText, errorMessage)
            self.present(nav, animated: false, completion: nil)
        }
    }
    
    func getCoins(url: String ) -> Int {
        var statusCode = 0
        
        coinCapService.fetchCoins(url: url) { ( data, response, error) in
            if let response = response as? HTTPURLResponse, let url = response.url {
                statusCode = self.getNetworkResponse(response: response, url: url)
            }
            
            if let error = error {
                print("getCoins Throwed An Error: ", error)
                return
            }
            
            guard let getJson = data else { return }
            
            for coin in getJson.data {
                let coin = SimpleCoinData(coinId: coin.id, coinName: coin.name, coinSymbol: coin.symbol)
                
                if let coin = coin {
                    self.coinId.append(coin)
                }
                self.tableView.reloadData()
            }
        }
        return statusCode
    }
    
    func getNetworkResponse(response: HTTPURLResponse, url: URL) -> Int {
        let statusCode = response.statusCode
        let url = url
        print("fetchExchangeData - HTTP request to URL: ", url, "\nresponded with status code: \(statusCode)")
        return statusCode
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchBarUI = UISearchBar()

        searchBarUI.backgroundColor = .blue
        searchBarUI.showsCancelButton = true
        let textFieldInsideSearchBar = searchBarUI.value(forKey: "searchField") as? UITextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor.blue
        searchBarUI.delegate = self
        
        if let cancelButton = searchBarUI.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
        view.addSubview(searchBarUI)
        }
        
        return searchBarUI
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filteredCoins.count
        } else {
        return coinId.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/12
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if searching {
            cell.textLabel?.text = filteredCoins[indexPath.row].coinName + " " + filteredCoins[indexPath.row].coinSymbol
        } else {
            cell.textLabel?.text = coinId[indexPath.row].coinName + " " + coinId[indexPath.row].coinSymbol
        }
    
        return cell
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = self.coinId[indexPath.row]
        let selectedRow = indexPath.row
        print("SELECTD ROW ER ", selectedRow)
        print("SELECTED COIN ER :", selectedCoin.coinId)
        let addTransactionVC = AddTransactionTableViewController(someService: coinCapService)
        addTransactionVC.delegate = self
        let coin = SimpleCoinData(coinId: selectedCoin.coinId, coinName: selectedCoin.coinName, coinSymbol: selectedCoin.coinSymbol)
        if let coin = coin {
            addTransactionVC.coinData.buyPair = coin.coinSymbol
            addTransactionVC.coinData.coinNameBuy = coin.coinName
            addTransactionVC.coinData.coinId = coin.coinId
            print("NAME ER :",  coin.coinId + "SYMBOL ER,", coin.coinSymbol)
        }
        self.navigationController?.pushViewController(addTransactionVC, animated: true)
    }
}

extension SelectCoinTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
        filteredCoins = self.coinId.filter( {$0.coinName.localizedCaseInsensitiveContains(searchText) ||  $0.coinSymbol.localizedCaseInsensitiveContains(searchText)} )
            //||  $0.coinSymbolForAddCoin.prefix(searchText.count) == searchText} )
        searching = true
        tableView.reloadData()
        } else {
        searching = false
        tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectCoinTableViewController: sendDataToSelectCoinDelegate {
    func sendTransactionDataToSelectCoin(transactionData: AllCoinData) {
        delegate?.sendTransactionDataToHome(transactionData: transactionData)
    }
}
