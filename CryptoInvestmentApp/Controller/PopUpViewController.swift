//
//  PopUpViewController.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 17/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    var getPopUpUI: PopUpErrorHandlerView!
    var headerText = ""
    var errorMessageLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPopUpUI = PopUpErrorHandlerView(frame: CGRect.zero)
        getPopUpUI.delegate = self
        getPopUpUI.headerLabel.text = headerText
        getPopUpUI.errorMessageLabel.text = errorMessageLabelText
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.addSubview(getPopUpUI)
    }
}

extension PopUpViewController: popUpDelegate {
    func didTapOk() {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
}
