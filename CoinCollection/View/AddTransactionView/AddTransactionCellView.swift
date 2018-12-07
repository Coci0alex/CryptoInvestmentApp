//
//  AddTransactionCellView.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 24/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

protocol addTransactionDelegate: class {
    func textFieldDidChange(_ textField: UITextField)
    func didTapBackButton()
    
}

class AddTransactionCellView: UITableViewCell {
    
    
    let keyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.textAlignment = .left
     //   label.backgroundColor = .green
      //  label.sizeToFit()
        return label
    }()
    
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .center
   //     label.baselineAdjustment = .alignCenters
     //   label.backgroundColor = .blue
      //  label.sizeToFit()
        return label
    }()
    
    let totalCostLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .center
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100)
        label.textAlignment = .center
        return label
    }()
    
    
    let quantityTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 8
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        field.textAlignment = .center
        field.isEnabled = false
        field.isHidden = true
        field.keyboardType = .decimalPad
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return field
    }()
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        
        let keypadToolbar: UIToolbar = UIToolbar()
        
        // add a done button to the numberpad
        keypadToolbar.items = [
            UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: textField, action: #selector(UITextField.resignFirstResponder)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        ]
        keypadToolbar.sizeToFit()
        // add a toolbar with a done button above the number pad
        textField.inputAccessoryView = keypadToolbar

    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPushed) , for: .touchUpInside)
        return button
    }()
    
    

    weak var delegate: addTransactionDelegate?
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChange(textField)
    }
    
    
    @objc func backButtonPushed() {
        delegate?.didTapBackButton()
    }

    func setupViews() {
        addDoneButtonOnNumpad(textField: quantityTextField)
        addSubview(containerView)
        containerView.addSubview(topLine)
        containerView.addSubview(bottomLine)
        containerView.addSubview(keyLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(totalCostLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(quantityTextField)
        setupCellConstraints()
    }
    
    func setupCellConstraints(){
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        
        topLine.translatesAutoresizingMaskIntoConstraints = false
        topLine.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        topLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        topLine.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.01 ).isActive = true
        topLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10 ).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.01 ).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        let keyLabelScale: (CGFloat, CGFloat) = (height: 0.2, width: 0.3)
        let valueLabelScale: (CGFloat, CGFloat) = (height: 0.25, width: 0.4)
        let totalCostScale: (CGFloat, CGFloat) = (height: 0.40, width: 0.4)

        let scaleArray: [(height: CGFloat, width: CGFloat)] = [keyLabelScale, valueLabelScale, totalCostScale]

        let labelArray: [UILabel] = [keyLabel, valueLabel, totalCostLabel]

        for index in 0..<labelArray.count {
            labelArray[index].translatesAutoresizingMaskIntoConstraints = false
            labelArray[index].adjustsFontSizeToFitWidth = true
            labelArray[index].numberOfLines = 0
            labelArray[index].minimumScaleFactor = 0.1
            labelArray[index].lineBreakMode = NSLineBreakMode.byClipping
            labelArray[index].baselineAdjustment = UIBaselineAdjustment.alignCenters
            labelArray[index].heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: scaleArray[index].height).isActive = true
            labelArray[index].widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            labelArray[index].centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            labelArray[index].sizeToFit()
        }
        // Unique Constraints //
        keyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true

        valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        quantityTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        quantityTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        quantityTextField.adjustsFontSizeToFitWidth = true
        quantityTextField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65).isActive = true
        quantityTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        totalCostLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}



class selectExchangeCell: UITableViewCell {


    let keyLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 100)
    label.textAlignment = .left
    //   label.backgroundColor = .green
    //  label.sizeToFit()
        
    return label
    }()

    let valueLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 100)
    label.textAlignment = .left
    //     label.baselineAdjustment = .alignCenters
    //   label.backgroundColor = .blue
    //  label.sizeToFit()
        
    return label
    }()
    
}
