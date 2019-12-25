//
//  StocksMO+CoreDataProperties.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//
//

import Foundation
import CoreData


extension StocksMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StocksMO> {
        return NSFetchRequest<StocksMO>(entityName: "Stocks")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var currentValue: String?
    @NSManaged public var change: String?
    @NSManaged public var relationship: UserMO?

}
