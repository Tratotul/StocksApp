//
//  RegistrationView.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class RegistrationView: UIViewController, IRegistrationView {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    private lazy var presenter: IRegistrationPresenter = {
        let presenter = RegistrationPresenter(view: self)
        return presenter
    }()
    
    func setupInitialState() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewReadyEvent()
       
    }
    
    @IBAction func doneEdditingLogin(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func doneEdditingPassword(_ sender: UITextField) {
        sender.resignFirstResponder()
        self.registerButtonTapper(registerButton)
        
    }
    @IBAction func registerButtonTapper(_ sender: UIButton) {
        
        let loginInput = loginTextField.text
        let passwordInput = passwordTextField.text
        
        guard let login = loginInput, !login.isEmpty, let password = passwordInput, !password.isEmpty else {
            return
        }
        
        let result = presenter.registerNewUser(login: login, password: password, stocks: [])
        if result {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainViewController")
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return }
        scene.windows.first?.rootViewController = vc
        } else {
            let alert = UIAlertController(title: "Already exist such user", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert,animated: true)
            
    }
}
}
