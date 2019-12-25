//
//  NetworkManager.swift
//  StocksApp
//
//  Created by  E.Tratotul on 30.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//
// MARK: - APIKey
// HLAXOLUI42Y5HOPX

import Foundation

protocol INetworkManager:AnyObject {
    func loadData(symbol: String, completion: @escaping(Result<StockDTO,Error>) -> Void)
    func searchTask(symbol:String, completion: @escaping(Result<[SearchStockModel], Error>) -> Void)
}

final class NetworkManager: INetworkManager{
    let session: URLSession
    let apiKey = "HLAXOLUI42Y5HOPX"
    init(){
        let sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func loadData(symbol: String, completion: @escaping(Result<StockDTO,Error>) -> Void) {
        let urlString = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="+symbol+"&apikey="+apiKey
        guard let url = URL(string: urlString) else {return}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
            }
            
            guard let data = data else { return }
            guard let result = try? JSONDecoder().decode(GlobalQuote.self,from: data) else {
                completion(.failure(NSError(domain: "Network", code: -12345, userInfo: nil)))
                return
            }
            completion(.success(result.globalQuote))
            
        }
        task.resume()
    }
    
    func searchTask(symbol: String, completion: @escaping(Result<[SearchStockModel],Error>) -> Void){
    let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords="+symbol+"&apikey="+apiKey
        guard let url = URL(string: urlString) else {
            assertionFailure("Can't make url from string")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            if let response = response as? HTTPURLResponse{
                print(response.statusCode)
            }
            guard let data = data else {return}
            
         
             let responce = try! JSONDecoder().decode(SearchStockResponce.self, from: data)
            
            completion(.success(responce.bestMatches))
        }
        task.resume()
    }
    
}
