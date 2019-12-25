//
//  MainViewController.swift
//  LoginScreen
//
//  Created by  E.Tratotul on 28.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, IMainViewController{
    
    var stocks = [StockDTO]()
    var searchStock = [SearchStockModel]()
    let cacheService = CacheService()
    var refreshControl = UIRefreshControl()
    let color = #colorLiteral(red: 0.4140962362, green: 0.6936558485, blue: 0.8813936114, alpha: 1)
    var searchTable: UITableView?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private lazy var presenter: IMainVCPresenter = {
        let presenter = MainVCPresenter(view: self)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()      
        
        presenter.onViewReadyEvent()
        stocks = presenter.stocks
        self.tableView.register(UINib(nibName: "CellView", bundle: nil), forCellReuseIdentifier: "CellID")
        let attributedString = NSMutableAttributedString(string:"Pull to update")
        let range : NSRange = ("Pull to update" as NSString).range(of: "Pull to update")
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        refreshControl.attributedTitle = attributedString
        refreshControl.tintColor = color
        refreshControl.addTarget(self, action: #selector(checkSelector),for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        searchBar.delegate = self
        
        
        
    }
    
    func setupInitialState() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let date = Date()
        let stringdate = dateFormatter.string(from: date)
        navigationBar.topItem?.title = stringdate
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) {[weak self] action in
            self?.logout()
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        self.showAlert(title: "Warning", message: "Are you sure?", actions: [logoutAction, cancelAction])
    }
    
    @IBAction func checkSelector() {
        presenter.downloadData(stocks: stocks) { (result) in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            case let .success(newStocks):
            self.stocks = newStocks
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
//                self.refreshControl.removeFromSuperview()
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) { [weak self] in
//                    guard let self = self else {
//                        return
//                    }
//                    self.tableView.addSubview(self.refreshControl)
//               }
                }
                
            }
        }
    }
    
    func logout(){
        presenter.logoutPressed()
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "OnBoardingView")
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        scene.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return stocks.count
        } else if tableView == searchTable {
            return searchStock.count
        } else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! StocksTableViewCell
            let item = stocks[indexPath.row]
            cell.configureCell(stock: item)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCellID") as! SearchTableViewCell
           let stock = searchStock[indexPath.row]
            cell.configureCell(stock: stock)
            return cell
        }
    }
}
extension MainViewController: UISearchBarDelegate{
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        guard self.searchTable == nil else {
            return
        }
        
        searchTable = UITableView(frame: CGRect(x: 0.0,
                                                y: self.searchBar.frame.maxY,
                                                width: self.view.frame.width,
                                                height: self.view.frame.height - self.navigationBar.frame.height - self.searchBar.frame.height))
        searchTable?.allowsSelection = true
        searchTable?.backgroundColor = .black
        searchTable?.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchCellID")
        searchTable?.dataSource = self
        searchTable?.delegate = self
        
        self.view.addSubview(searchTable!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let symbol = searchBar.text, symbol != "" else {return}
        self.presenter.searchData(symbol: symbol) { [weak self] in
            switch $0 {
            case .success(let stocks):
                self?.searchStock = stocks
                
                DispatchQueue.main.async {
                    self?.searchTable?.reloadData()
                }
            case .failure:
                return
            }
            
        }
        searchBar.text = ""
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchTable?.removeFromSuperview()
        self.searchTable = nil
        tableView.reloadData()
        searchBar.resignFirstResponder()
        
    }
    
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cacheService = CacheService()
        if editingStyle == .delete{
            stocks.remove(at: indexPath.row)
            cacheService.updateStocks(stocksDTO: stocks)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTable {
        
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let self = self else {return}
                let dispatchGroup = DispatchGroup()
                dispatchGroup.enter()
                self.presenter.addNewStock(symbol: (self.searchStock[indexPath.row].symbol), completion: {
                    switch $0 {
                    case .success(let stock):
                        self.stocks.append(stock)
                    case .failure(_):
                        print("Too much requests")
                    }
                    dispatchGroup.leave()
                })
                dispatchGroup.wait()
                self.cacheService.updateStocks(stocksDTO: self.stocks)
                self.searchBarCancelButtonClicked(self.searchBar)
            }
           
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            self.showAlert(title: "Add?", message: searchStock[indexPath.row].symbol, actions: [addAction,cancelAction])
        }
    }
}

