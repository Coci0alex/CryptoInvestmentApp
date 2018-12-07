//
//  SelectExchangeViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 25/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol returnExchangeIdDelegate: class  {
    func returnExchangeId(exchangeId: String)
}

final class SelectExchangeViewController: UITableViewController {
    
    
    private let dataSource = ListViewDataSource()
    private var filteredExchanges = [String]()
    private var searching  = false
    private let searchBarUI = UISearchBar()
    
    var exchangeData = ExchangeData()

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
        dataSource.list = exchangeData.exchangeId
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exchangeId = self.exchangeData.exchangeId[indexPath.row]
        returnExchangeId(exchangeId: exchangeId)
    }
    
    weak var delegate: returnExchangeIdDelegate?
    
    func returnExchangeId(exchangeId: String) {
        delegate?.returnExchangeId(exchangeId: exchangeId)
        self.navigationController?.popViewController(animated: true)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1).capitalized)
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func lowerCaseFirstLetter() -> String {
        let first = String(prefix(1).lowercased())
        let other = String(dropFirst())
        return first + other
    }
    
    mutating func lowerCaseFirstLetter() {
    self = self.lowerCaseFirstLetter()
    }
}

extension SelectExchangeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredExchanges = self.exchangeData.exchangeId.filter( {$0.localizedCaseInsensitiveContains(searchText) ||  $0.localizedCaseInsensitiveContains(searchText)} )
            searching = true
            dataSource.list = filteredExchanges
            tableView.reloadData()
        } else {
            searching = false
            dataSource.list = exchangeData.exchangeId
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: true)
    }
}


