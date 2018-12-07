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
        homeTableView.reloadData()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.checkNetworkErrors(statusCode: self.updateCoinData())
        })
    }
}

extension HomeTableViewController: deleteCoinDelegate {
    func didTapDeleteCoin(coinData: PortFolio ) {
        coreData.context.delete(coinData)
        coreData.saveContext()
        fetchCoins()
        homeTableView.reloadData()
        updateCoinData()
    }
}

