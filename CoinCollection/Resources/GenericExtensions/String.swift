//
//  GenericExtensions.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 01/12/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//

import UIKit

extension String {

    func cutString(myString: String, charToCutFrom: Character, cutAfter: Bool) -> String {
       
        var chars = Array(myString)
        var modifiedString = ""
        var foundChar = false

        if !cutAfter {
        let string = String(myString.reversed())
        chars = Array(string)
        }
        
        for i in chars {
            
                if foundChar == true {
                    modifiedString.append(i)
                }
                if i == charToCutFrom {
                    foundChar = true
                }
        }
        if !cutAfter {
            print("MODIFIED STRING ER:", modifiedString)
            return String(modifiedString.reversed())
        } else {
            return modifiedString
        }
    }
    
    func getDateAndTime(date: Date) -> String{
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .long
        dateFormatter.dateFormat = "hh:mm a"
        let getDate = dateFormatter.string(from: date)
        let time = timeFormatter.string(from: date)
        let result = time + " " + getDate
        return result
    }

}
