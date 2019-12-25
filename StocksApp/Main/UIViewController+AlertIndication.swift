//
//  UIViewController+AlertIndication.swift
//  StocksApp
//
//  Created by  E.Tratotul on 17.12.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

extension UIViewController: IAlertIndication {
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { alertController.addAction($0) }
        self.present(alertController, animated: true, completion: nil)
    }
}
