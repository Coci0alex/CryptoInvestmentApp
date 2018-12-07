//
//  CoinData+CoreDataProperties.swift
//  
//
//  Created by Alexander Carlsen on 07/12/2018.
//
//

import Foundation
import CoreData


extension CoinData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoinData> {
        return NSFetchRequest<CoinData>(entityName: "CoinData")
    }

    @NSManaged public var logo: NSData?
    @NSManaged public var marketCap: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var rank: Int32
    @NSManaged public var rate: Double
    @NSManaged public var symbol: String?

}
