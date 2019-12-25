//
//  RegistrationPresenter.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation


final class RegistrationPresenter: IRegistrationPresenter {
    private weak var view: IRegistrationView?
    
    private let cacheService: ICasheService
    
    init(view: IRegistrationView, cacheService: ICasheService = CacheService()) {
        self.view = view
        self.cacheService = cacheService
    }
    
    func onViewReadyEvent(){
        view?.setupInitialState()
    }
    func registerNewUser(login:String, password: String,stocks: [StockDTO]) -> Bool {
        if cacheService.userExists(with: login) {
            return false
        }
        let stock1 = StockDTO(symbol: "USDRUB", currentValue: "65.1", change: "0")
        let stock2 = StockDTO(symbol: "EURRUB", currentValue: "75.1", change: "-1")
        let stock3 = StockDTO(symbol: "BTCUSD", currentValue: "7818.65", change: "57.41")
        let stocks = [stock1,stock2,stock3]
        
        let user = UserPlain(login: login, password: password,isActive: true, stocks: stocks)
        cacheService.cache(user: user)
        return true
}
}
