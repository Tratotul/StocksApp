//
//  MainContract.swift
//  StocksApp
//
//  Created by  E.Tratotul on 28.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import Foundation

protocol IMainViewController: AnyObject{
    func setupInitialState()
    
}

protocol IMainVCPresenter: AnyObject{
    func onViewReadyEvent()
    func downloadData(stocks: [StockDTO], completion: @escaping (Result<[StockDTO],(NSError)>) -> Void)
    func searchData(symbol: String, completion: @escaping (Result<[SearchStockModel], Error>)->Void)
    func addNewStock(symbol: String, completion: @escaping (Result<StockDTO,Error>)-> Void)
    var stocks: [StockDTO]{get}
    func logoutPressed()
}
