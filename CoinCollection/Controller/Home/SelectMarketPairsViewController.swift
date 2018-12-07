//
//  SelectMarketPairsViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 30/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol returnMarketPairDelegate: class  {
    func returnMarketPair(marketPair: String)
}

final class SelectMarketPairsViewController: UITableViewController {

    
    private let dataSource = ListViewDataSource()
    var exchangeData = ExchangeData()
    private var filteredMarketPairs = [String]()
    private var searching = false
    private let searchBarUI = UISearchBar()

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        tableView.dataSource = dataSource
        renderTableView()
}
    
    private func renderTableView() {
        dataSource.list = exchangeData.marketPair
        tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBarUI.endEditing(true)
        if let cancelButton = searchBarUI.value(forKey: "cancelButton") as? UIButton {
            cancelButton.isEnabled = true
            view.addSubview(searchBarUI)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMarketPair = self.exchangeData.marketPair[indexPath.row]
        returnMarketPair(marketPair: selectedMarketPair)
    }
    
    weak var delegate: returnMarketPairDelegate?
    
    func returnMarketPair(marketPair: String) {
        delegate?.returnMarketPair(marketPair: marketPair)
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectMarketPairsViewController: UISearchBarDelegate {
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredMarketPairs = self.exchangeData.marketPair.filter( {$0.localizedCaseInsensitiveContains(searchText) ||  $0.localizedCaseInsensitiveContains(searchText)} )
            searching = true
            dataSource.list = filteredMarketPairs
            tableView.reloadData()
        } else {
            searching = false
            dataSource.list = exchangeData.marketPair
            tableView.reloadData()
        }
    }
    
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}

