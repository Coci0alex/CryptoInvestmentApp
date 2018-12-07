//
//  AddTransactionExtensions.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit


/// Receive selected exchange id from SelectExchangeVC ///
extension AddTransactionTableViewController: returnExchangeIdDelegate {
    func returnExchangeId(exchangeId: String) {
        let marketPairsUrl = "https://api.coincap.io/v2/markets?exchangeId=" + exchangeId + "&baseSymbol=" + coinData.buyPair
        self.coinData.exchangeId = exchangeId
        
        if getMarketsPairs(url: marketPairsUrl) == 200 {
        }
        tableView.reloadData()
    }
}

/// Receive selected marketPair from SelectMarketPairVC ///
extension AddTransactionTableViewController: returnMarketPairDelegate {
    func returnMarketPair(marketPair: String) {
        self.coinData.sellPair = marketPair.cutString(myString: marketPair, charToCutFrom: "/", cutAfter: true)
        let getExchangeMarketPair = self.exchangeDataContainer.marketPair
        
        if getExchangeMarketPair.contains(marketPair) {
            guard let index = getExchangeMarketPair.firstIndex(of: marketPair) else { return }
            self.coinData.coinCost = String(exchangeDataContainer.priceUSD[index])
        }
        tableView.reloadData()
    }
}

extension AddTransactionTableViewController: addTransactionDelegate {
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let text = Double(text) {
            coinData.quantity = text
            }
        }
    }
}

protocol sendDataToSelectCoinDelegate: class  {
    func sendTransactionDataToSelectCoin(transactionData: AllCoinData)
}

///// delegate transaction data to HomeTableViewVC ///
extension AddTransactionTableViewController {
    @objc func didTapSaveBuyTransaction() {
        if let quantity = coinData.quantity {
            if quantity > 0 {
                DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                }
                self.delegate?.sendTransactionDataToSelectCoin(transactionData: self.coinData)
                return
            } 
        }
        let errorPopUp = errorModal.showModal("Invalid Input", "Please enter a valid quantity")
        self.present(errorPopUp, animated: false, completion: nil)
        return
    }
}

extension AddTransactionTableViewController {
    func checkNetworkErrors(statusCode: Int) {
            if statusCode != 200 {
            let header = "Error"
            let message = "Apoligies something went wrong. Please try again later..."
            let errorPopUp = errorModal.showModal(header, message)
            self.present(errorPopUp, animated: false, completion: nil)
        }
    }
}
