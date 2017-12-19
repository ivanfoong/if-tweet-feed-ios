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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else {
            return
        }
        switch segueIdentifier {
        case "showApp":
            return
        default:
            return
        }
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.login()
    }
    
    private func login() {
        if let sessions = Twitter.sharedInstance().sessionStore.existingUserSessions() as? [TWTRAuthSession], sessions.count > 0 {
            sessions.forEach { session in
                print(session.userID)
            }
            self.showApp()
        } else {
            Twitter.sharedInstance().logIn { [weak self] (session, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)");
                    return
                }
                if let session = session {
                    print("signed in as \(session.userName)");
                    self?.showApp()
                }
            }
        }
    }
    
    private func showApp() {
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
}

