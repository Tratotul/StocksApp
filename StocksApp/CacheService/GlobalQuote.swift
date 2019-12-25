//
//  GlobalQuote.swift
//  StocksApp
//
//  Created by  E.Tratotul on 09.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

final class GlobalQuote:Codable {
    let globalQuote: StockDTO
    
    enum CodingKeys: String, CodingKey{
        case globalQuote = "Global Quote"
    }
}
