//
//  ViewController.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 12/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if let error = error {
                print("error: \(error.localizedDescription)");
                return
            }
            if let session = session {
                print("signed in as \(session.userName)");
            }
        })
    }
    
}

