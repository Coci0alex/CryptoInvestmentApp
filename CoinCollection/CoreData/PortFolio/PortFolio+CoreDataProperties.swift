//
//  PortFolio+CoreDataProperties.swift
//  
//
//  Created by Alexander Carlsen on 07/12/2018.
//
//

import Foundation
import CoreData


extension PortFolio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortFolio> {
        return NSFetchRequest<PortFolio>(entityName: "PortFolio")
    }

    @NSManaged public var buyPair: String?
    @NSManaged public var close24h: Double
    @NSManaged public var coinCost: Double
    @NSManaged public var coinId: String?
    @NSManaged public var coinNameBuy: String?
    @NSManaged public var coinNameSell: String?
    @NSManaged public var currentPrice: Double
    @NSManaged public var data: String?
    @NSManaged public var exchangeId: String?
    @NSManaged public var holdingsCoins: Double
    @NSManaged public var holdingsUsd: Double
    @NSManaged public var logo: NSData?
    @NSManaged public var open24h: Double
    @NSManaged public var rateChange: Double
    @NSManaged public var sellPair: String?
    @NSManaged public var totalCoinCost: Double

}
