//
//  DetailViewPresenter.swift
//  StocksApp
//
//  Created by  E.Tratotul on 09.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

final class DetailViewPresenter: IDetailViewPresenter {
    
    private weak var view: IDetailViewController?
    
    init(view: IDetailViewController){
        self.view = view
    }
    
    func onViewReadyEvent(){
        view?.setUpInitialState()
    }
}
