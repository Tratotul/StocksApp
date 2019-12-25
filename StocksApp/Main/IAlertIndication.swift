//
//  IAlertIndication.swift
//  StocksApp
//
//  Created by  E.Tratotul on 19.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit
protocol IAlertIndication {
    
     func showAlert(title: String, message: String, actions: [UIAlertAction])
}
