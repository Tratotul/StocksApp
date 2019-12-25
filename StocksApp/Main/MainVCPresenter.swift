//
//  MainVCPresenter.swift
//  StocksApp
//
//  Created by  E.Tratotul on 28.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

final class MainVCPresenter: IMainVCPresenter {
    
    private weak var view: (IMainViewController & IAlertIndication)?
    private let networkManager = NetworkManager()
    private let cacheService = CacheService()
    private let queue = DispatchQueue.global(qos: .default)
    private let okAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
    public var stocks: [StockDTO]{
        guard let user = cacheService.activeUser() else {return []}
        return cacheService.retrieve(login: user.login)
    }
    
    init(view: (IMainViewController & IAlertIndication)){
        self.view = view
    }
    
    func onViewReadyEvent(){
        view?.setupInitialState()
    }
    
    func downloadData(stocks: [StockDTO], completion: @escaping (Result<[StockDTO],(NSError)>) -> Void) {
        queue.async {
            
            var resultStocks = [StockDTO]()
            let group = DispatchGroup()
            for stock in stocks {
                let symbol = stock.symbol.replacingOccurrences(of: " ", with: "")
                group.enter()
                self.networkManager.loadData(symbol: symbol) { (result) in
                    switch result {
                    case let .failure(error as NSError):
                        if error.code == -12345 {
                            DispatchQueue.main.async{
                                self.view?.showAlert(title: "Failure", message: "Exceeded quota of queriese", actions: [self.okAction])
                            }
                            print("Превышение квоты запросов")
                            completion(.failure(error))
                            
                        }
                    case let .success(resultStock):
                        print(resultStock.symbol, resultStock.currentValue)
                        group.leave()
                        
                        resultStocks.append(resultStock)
                    }
                }
            }
            group.wait()
            completion(.success(resultStocks))
        }
    }
    
    func searchData(symbol: String, completion: @escaping (Result<[SearchStockModel], Error>)->Void) {
        let symbol = symbol.replacingOccurrences(of: " ", with: "")
        
        self.networkManager.searchTask(symbol: symbol) { (result) in
            switch result {
            case .failure(_):
                fatalError()
            case let .success(searchResult):
                
                completion(.success(searchResult))
            }
        }
        
        
    }
    func addNewStock(symbol: String, completion: @escaping (Result<StockDTO, Error>) -> Void) {
        networkManager.loadData(symbol: symbol) { (result) in
            switch result {
            case .success(let stock):
                completion(.success(stock))
            case .failure(let error as NSError):
                if error.code == -12345 {
                    DispatchQueue.main.async {
                        self.view?.showAlert(title: "Failure", message: "Exceeded quota of queriese", actions: [self.okAction])
                    }
                        completion(.failure(error))
                }
            }
        }
        
    }
    func logoutPressed() {
        guard let activeUser = cacheService.activeUser() else {return}
        cacheService.toggleUserActivity(isActive: false, login: activeUser.login)
    
    }
}
