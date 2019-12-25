//
//  RegistrationContract.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

protocol IRegistrationView:AnyObject {
    func setupInitialState()
}

protocol IRegistrationPresenter:AnyObject {
   func onViewReadyEvent()
    func registerNewUser(login:String, password:String, stocks: [StockDTO]) -> Bool
}
