//
//  HomeTableViewExtensions.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 07/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

extension HomeTableViewController: navigationItemDelegate {
    func didTapAddCoin() {
        let addCoinTableViewController = SelectCoinTableViewController(someService: coinCapService)
        addCoinTableViewController.delegate = self
        self.navigationController?.pushViewController(addCoinTableViewController, animated: true)
    }
    
    func refreshButtonPushed() {
        checkNetworkErrors(statusCode: updateCoinData())
    }
}

extension HomeTableViewController: sendDataToHomeDelegate {
    func sendTransactionDataToHome(transactionData: AllCoinData) {
        
        let saveCoinData = PortFolio(context: self.coreData.context)
        saveCoinData.coinNameBuy = transactionData.coinNameBuy
        saveCoinData.coinNameSell = transactionData.coinNameSell
        saveCoinData.coinId = transactionData.coinId
        saveCoinData.buyPair = transactionData.buyPair
        saveCoinData.sellPair = transactionData.sellPair
        
        if let coinCost = Double(transactionData.coinCost) {
            saveCoinData.coinCost = coinCost
        }
        
        saveCoinData.data = transactionData.date
        saveCoinData.exchangeId = transactionData.exchangeId
        
        if let holdingsUsd = Double(transactionData.totalCost) {
            saveCoinData.totalCoinCost = holdingsUsd
            saveCoinData.holdingsUsd = holdingsUsd
        }
        
        if let coinCost = Double(transactionData.coinCost) {
            saveCoinData.currentPrice = coinCost
            saveCoinData.coinCost = coinCost
        }
        
        if let holdingsCoins = transactionData.quantity {
            saveCoinData.holdingsCoins = holdingsCoins
        }
        
        saveCoinData.logo = nil
        self.coreData.saveContext()
        fetchCoins()
        homeTableView.reloadData()
    }
}

extension HomeTableViewController: deleteCoinDelegate {
    func didTapDeleteCoin(coinData: PortFolio ) {
        coreData.context.delete(coinData)
        coreData.saveContext()
        fetchCoins()
        homeTableView.reloadData()
    }
}

extension HomeTableViewController: sortHomeHeaderDelegate {
    
    // Sorting Functions //
    func didTapCoinNameBtn() {
        self.coreDataCoins.sort(by: { Ascending[0] ? $0.coinNameBuy! > $1.coinNameBuy! : $0.coinNameBuy! < $1.coinNameBuy! })
        Ascending[0] = !Ascending[0]
        homeTableView.reloadData()
    }
    
    func didTapPriceBtn() {
        self.coreDataCoins.sort(by: { Ascending[1] ? $0.currentPrice > $1.currentPrice : $0.currentPrice < $1.currentPrice })
        Ascending[1] = !Ascending[1]
        homeTableView.reloadData()
    }
    
    func didTapHoldingsBtn() {
        self.coreDataCoins.sort(by: { Ascending[2] ? $0.holdingsUsd > $1.holdingsUsd : $0.holdingsUsd < $1.holdingsUsd })
        Ascending[2] = !Ascending[2]
        homeTableView.reloadData()
    }
}

