//
//  StockMO+DTO.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation


extension StocksMO {
    func fillWithDTO(item: StockDTO){
        
        self.currentValue = item.currentValue
        self.symbol = item.symbol
        self.change = item.change
        }
    
}
