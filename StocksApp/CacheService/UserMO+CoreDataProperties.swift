//
//  UserMO+CoreDataProperties.swift
//  StocksApp
//
//  Created by  E.Tratotul on 19.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        return NSFetchRequest<UserMO>(entityName: "User")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var stocks: NSSet?

}

// MARK: Generated accessors for stocks
extension UserMO {

    @objc(addStocksObject:)
    @NSManaged public func addToStocks(_ value: StocksMO)

    @objc(removeStocksObject:)
    @NSManaged public func removeFromStocks(_ value: StocksMO)

    @objc(addStocks:)
    @NSManaged public func addToStocks(_ values: NSSet)

    @objc(removeStocks:)
    @NSManaged public func removeFromStocks(_ values: NSSet)

}
