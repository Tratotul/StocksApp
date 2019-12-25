//
//  OnBoardingView.swift
//  StocksApp
//
//  Created by  E.Tratotul on 27.11.2019.
//  Copyright © 2019  E.Tratotul. All rights reserved.
//

import UIKit

class OnBoardingView: UIViewController, IOnBoardingView {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let cacheService = CacheService()
    
    
    private lazy var presenter: IOnBoardingPresenter = {
        let presenter = OnBoardingPresenter(view: self)
        return presenter
    }()
    
    func setupInitialState() {

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationItem.title = "Welcome"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewReadyEvent()
        
    }


    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let loginInput = loginTextField.text
        let passwordInput = passwordTextField.text
        
        guard let login = loginInput, !login.isEmpty, let password = passwordInput, !password.isEmpty else {
            return
        }
        let checker = presenter.signUp(login: login, password: password)
        
        if checker {
            cacheService.toggleUserActivity(isActive: true, login: login)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(identifier: "MainViewController")
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        scene.windows.first?.rootViewController = vc
        } else {
            let okAction = UIAlertAction(title: "Ok.", style: .cancel, handler: nil)
            self.showAlert(title: "No such user", message: "Try again", actions: [okAction])
        }
    }
    
    
    @IBAction func sugnUpButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RegistrationView") as! RegistrationView
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func doneEdditingLogin(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func doneEdditingPassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}

