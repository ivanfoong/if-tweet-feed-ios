//
//  LoginViewModel.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 22/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

protocol LoginViewModelInterface {
    weak var delegate: LoginViewModelDelegate? { get }
    var twitterService: TwitterServiceInterface { get }
    init(delegate: LoginViewModelDelegate)
    init(delegate: LoginViewModelDelegate, twitterService: TwitterServiceInterface)
    func loginButtonTapped()
}

class LoginViewModel: LoginViewModelInterface {
    weak var delegate: LoginViewModelDelegate?
    var twitterService: TwitterServiceInterface
    
    convenience required init(delegate: LoginViewModelDelegate) {
        self.init(delegate: delegate, twitterService: TwitterService())
    }
    
    required init(delegate: LoginViewModelDelegate, twitterService: TwitterServiceInterface) {
        self.delegate = delegate
        self.twitterService = twitterService
    }
    
    func loginButtonTapped() {
        self.login()
    }
    
    private func login() {
        let sessions = self.twitterService.existingSessions()
        if sessions.count > 0 {
            sessions.forEach { session in
                print(session.userID)
            }
            self.delegate?.showApp()
        } else {
            self.twitterService.logIn { [weak self] (session, error) in
                if let error = error {
                    self?.delegate?.showLoginError(with: error.localizedDescription)
                    return
                }
                if let session = session {
                    self?.delegate?.showApp()
                }
            }
        }
    }
}

protocol LoginViewModelDelegate: class {
    func showApp()
    func showLoginError(with message: String)
}
