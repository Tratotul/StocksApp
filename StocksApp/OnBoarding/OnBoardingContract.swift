//
//  OnBoardingContract.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

protocol IOnBoardingView: AnyObject {
    func setupInitialState()
}

protocol IOnBoardingPresenter: AnyObject {
    func onViewReadyEvent()
    func signUp(login: String, password: String) -> Bool
//    func userCheck(login:String, password:String) -> Bool
    
}
