//
//  LoginViewController.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 12/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = LoginViewModel(delegate: self)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.viewModel.loginButtonTapped()
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func showApp() {
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
    
    func showLoginError(with message: String) {
        let controller = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}
