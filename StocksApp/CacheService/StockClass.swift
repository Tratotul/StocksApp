//
//  StockClass.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.

// MARK: - APIKey
// HLAXOLUI42Y5HOPX

import Foundation

final class StockDTO: Codable  {
    let symbol: String
    let currentValue: String
    let change: String
    
    enum CodingKeys:String, CodingKey{
        case symbol = "01. symbol"
        case currentValue = "05. price"
        case change = "09. change"
    }
    
    init(symbol: String, currentValue:String, change: String) {
        self.symbol = symbol
        self.currentValue = currentValue
        self.change = change
    }
    
    init(managedStock: StocksMO){
        self.currentValue = managedStock.currentValue ?? "-"
        self.change = managedStock.change ?? "-"
        self.symbol = managedStock.symbol ?? "-"
    }
    init(from decoder: Decoder){
        
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try! container.decode(String.self, forKey: .symbol)
        self.change = try! container.decode(String.self, forKey: .change)
        self.currentValue = try! container.decode(String.self, forKey: .currentValue)
    }
}
