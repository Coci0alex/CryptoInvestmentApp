//
//  CoinData+CoreDataProperties.swift
//  CryptoInvestmentApp
//
//  Created by Alexander Carlsen on 17/11/2018.
//  Copyright © 2018 Alexander Carlsen. All rights reserved.
//
//

import Foundation
import CoreData


extension CoinData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinData> {
        return NSFetchRequest<CoinData>(entityName: "CoinDataCMC")
    }

    @NSManaged public var logo: NSData?
    @NSManaged public var marketCap: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rank: Int32
    @NSManaged public var rate: Double
    @NSManaged public var symbol: String?

}
