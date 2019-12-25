//
//  OnBoardingPresenter.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit


final class OnBoardingPresenter: IOnBoardingPresenter {
    
    private weak var view: IOnBoardingView?
    private var cacheService: ICasheService
    init(view: IOnBoardingView, cacheService: ICasheService = CacheService()) {
        self.view = view
        self.cacheService = cacheService
    }
    func onViewReadyEvent(){
        view?.setupInitialState()
        if cacheService.activeUser() != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(identifier: "MainViewController")
            
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            scene.windows.first?.rootViewController = vc
        }
    }
    
    //    func userCheck(login: String, password:String) -> Bool{
    //        return true
    //    }
    func signUp(login: String, password: String) -> Bool{
        return cacheService.checkForSigninnigIn(login: login, password: password)
    }
}
