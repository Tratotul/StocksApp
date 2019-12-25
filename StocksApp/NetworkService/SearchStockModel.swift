//
//  SearchStockModel.swift
//  StocksApp
//
//  Created by  E.Tratotul on 07.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

final class SearchStockModel: Codable {
    let symbol: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }
    init(from decoder: Decoder){
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.symbol = try! container.decode(String.self, forKey: .symbol)
        self.name = try! container.decode(String.self, forKey: .name)
    }
}
