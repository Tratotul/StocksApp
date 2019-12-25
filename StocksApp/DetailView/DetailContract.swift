//
//  DetailContract.swift
//  StocksApp
//
//  Created by  E.Tratotul on 09.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

protocol IDetailViewController: AnyObject {
    func setUpInitialState()
}

protocol IDetailViewPresenter: AnyObject {
    func onViewReadyEvent()
}
