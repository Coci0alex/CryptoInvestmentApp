//
//  InsertCoinDataViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 24/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class AddTransactionTableViewController: UITableViewController, UITextFieldDelegate {

    
    let binanceService: CoinCapServices
    
    init(someService: CoinCapServices) {
        self.binanceService = someService
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    /// Using 2D array for tableview to handle custom cell view ///
    private var cellKeys = [
        ["Exchange"],
        ["Market Pair"],
        ["Quantity"],
        ["Price USD"],
        ["Total Cost"],
        ["Date"]
    ]
    
    var getBackButton: AddTransactionCellView!
    var exchangeDataContainer = ExchangeData()
    
    var coinData = AllCoinData(coinId: "", coinNameBuy: "", coinNameSell: "", exchangeId: "", buyPair: "", sellPair: "", priceUSD: "0", totalCost: "0.00", date: "")
    
    weak var delegate: sendDataToSelectCoinDelegate?

    
    private let datePicker = UIDatePicker()
    let errorModal = NetworkErrorHandling()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       // self.navigationItem.leftBarButtonItem = getBackButton.backButton
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        coinData.date = coinData.date.getDateAndTime(date: Date())
        self.title = "Add " + coinData.coinNameBuy
        
        tableView.separatorStyle = .none
        tableView.register(AddTransactionCellView.self, forCellReuseIdentifier: "cellId")
        tableView.register(AddTransactionHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.reloadData()
        
        if !Reachability.isConnectedToNetwork() {
            let modal = errorModal.noInternetModal()
            self.present(modal, animated: false, completion: nil)
        } else {
            // deleteAllCoins()
            checkNetworkErrors(statusCode: fetchData())
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 30 } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {

        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! AddTransactionHeaderView
                return headerView
        }
        let headerView = UIView()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 5 { return 45 } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView {
        
        if section == 5 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! AddTransactionHeaderView
            return headerView.saveBtn
        }
        let headerView = UIView()
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellKeys[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! AddTransactionCellView
    
        cell.selectionStyle = .none
        let cellValues = [
            [coinData.exchangeId],
            [coinData.buyPair + "/" + coinData.sellPair],
            [""],
            [coinData.coinCost],
            [""],
            [coinData.date]
        ]
        
        let valueLabelText = cellValues[indexPath.section][indexPath.row]
        let keyLabelText = cellKeys[indexPath.section][indexPath.row]
        
        if indexPath.section == 2 {
            if let quantity = coinData.quantity {
                cell.quantityTextField.text = String(quantity)
            }
            cell.quantityTextField.isEnabled = true
            cell.quantityTextField.isHidden = false
            cell.quantityTextField.delegate = self
            
        }
    
        cell.keyLabel.text = keyLabelText
        if indexPath.section == 3 {
            cell.valueLabel.text = "$" + valueLabelText
        } else {
            cell.valueLabel.text = valueLabelText.capitalizingFirstLetter()
            }
        
        if indexPath.section == 4 {
            if let price = Double(coinData.coinCost), let quantity = coinData.quantity {
                let rounded = myRoundings(number: price * quantity)
            coinData.totalCost = String(rounded)
            }
            cell.totalCostLabel.text = "$" + coinData.totalCost
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let selectedRow = self.cellKeys[indexPath.section][indexPath.row]
        if selectedRow == "Exchange" {
        
            let selectExchangeVC = SelectExchangeViewController()
            selectExchangeVC.delegate = self
            selectExchangeVC.exchangeData = exchangeDataContainer
            self.navigationController?.pushViewController(selectExchangeVC, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        if selectedRow == "Market Pair" {
            let selectMarketPairVC = SelectMarketPairsViewController()
            selectMarketPairVC.exchangeData = exchangeDataContainer
            selectMarketPairVC.delegate = self
            self.navigationController?.pushViewController(selectMarketPairVC, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
        if selectedRow == "Date" {
            renderDatePicker()
        }
    }
    
    func setupToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton =  UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(AddTransactionTableViewController.dismissPicker))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([doneButton, spaceButton], animated: false)
        return toolBar
    }
    
    func setupDatePickerContainer() -> UIView {
        let datePickerContainer = UIView(frame: CGRect(x: 0, y: self.view.bounds.size.height/2 , width: self.view.bounds.size.width, height: self.view.bounds.size.height/2))
        datePickerContainer.backgroundColor = .white
        return datePickerContainer
    }
    
    func setupTextField(toolBar: UIToolbar) -> UITextField {
        let textField = UITextField()
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        textField.tintColor = UIColor.clear
        textField.becomeFirstResponder()
        return textField
    }
    
    func renderDatePicker() {
        let container = setupDatePickerContainer()
        let toolBar = setupToolBar()
        let textField = setupTextField(toolBar: toolBar)
        datePicker.backgroundColor = .white
        container.addSubview(textField)
        container.tag = 1
        tableView.addSubview(container)
    }
    
    
    @objc func dismissPicker() {
        coinData.date = coinData.date.getDateAndTime(date: datePicker.date)
        self.view.endEditing(true)
        self.view.viewWithTag(1)?.removeFromSuperview()
        tableView.reloadData()
    }
    
    func myRoundings(number: Double) -> String {
        if number <= 1 {
            let roundedNumber = number.rounded(toPlaces: 5)
            return String(roundedNumber)
        }
        else {
            let roundedNumber = number.rounded(toPlaces: 2)
            return String(roundedNumber)
        }
    }
}

