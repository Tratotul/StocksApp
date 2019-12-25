//
//  DetailViewController.swift
//  StocksApp
//
//  Created by  E.Tratotul on 09.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, IDetailViewController {

    private lazy var presenter: IDetailViewPresenter = {
        let presenter = DetailViewPresenter(view: self)
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewReadyEvent()
     }
    func setUpInitialState() {
        
    }
}
