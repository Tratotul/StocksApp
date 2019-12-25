//
//  UserPlain.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

final class UserPlain {
    let login: String
    let password: String
    let isActive: Bool
    let stocks: [StockDTO]
    
    init(login:String, password: String, isActive: Bool, stocks: [StockDTO]){
        self.login = login
        self.password = password
        self.isActive = isActive
        self.stocks = stocks
        
    }
    
    init(withMO managedUser: UserMO){
        self.login = managedUser.login ?? ""
        self.password = managedUser.password ?? ""
        self.isActive = managedUser.isActive
        self.stocks = managedUser.stocks?.allObjects.map {StockDTO(managedStock: $0 as! StocksMO)} ?? []
    }
}
