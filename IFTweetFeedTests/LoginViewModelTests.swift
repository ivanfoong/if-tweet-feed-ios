//
//  LoginViewModelTests.swift
//  IFTweetFeedTests
//
//  Created by Ivan Foong on 22/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import XCTest
@testable import IFTweetFeed

class LoginViewModelTests: XCTestCase {
    
    func testInit() {
        let expectedDelegate = LoginViewModelDelegateImpl()
        let loginViewModel = LoginViewModel(delegate: expectedDelegate)
        
        guard let delegate = loginViewModel.delegate else {
            XCTFail("Expected loginViewModel.delegate to not be nil")
            return
        }
        XCTAssert(expectedDelegate === delegate)
    }
    
    func testLoginButtonTapped() {
        let loginViewModelDelegate = LoginViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        twitterService.loginSessionToReturn = TWTRSession(authToken: "", authTokenSecret: "", userName: "", userID: "")
        let loginViewModel = LoginViewModel(delegate: loginViewModelDelegate, twitterService: twitterService)
        let showAppDidCalledExpectation = XCTestExpectation(description: "showApp did called")
        loginViewModelDelegate.showAppDidCalledExpectation = showAppDidCalledExpectation
        
        loginViewModel.loginButtonTapped()
        wait(for: [showAppDidCalledExpectation], timeout: 1)
    }
    
    class LoginViewModelDelegateImpl: LoginViewModelDelegate {
        var showAppDidCalledExpectation: XCTestExpectation?
        var showLoginErrorDidCalledExpectation: XCTestExpectation?
        var showLoginErrorMessage: String?
        
        func showApp() {
            self.showAppDidCalledExpectation?.fulfill()
        }
        
        func showLoginError(with message: String) {
            showLoginErrorMessage = message
            self.showLoginErrorDidCalledExpectation?.fulfill()
        }
    }
    
    class MockTwitterService: TwitterServiceInterface {
        var loginSessionToReturn: TWTRSession?
        var loginErrorToReturn: Error?
        func existingSessions() -> [TWTRAuthSession] {
            return []
        }
        
        func logIn(with completion: @escaping TWTRLogInCompletion) {
            completion(self.loginSessionToReturn, self.loginErrorToReturn)
        }
        
        func logOut() {
            
        }
        
        func loadPreviousTweets(beforeCursor: TWTRTimelineCursor?, with completion: @escaping TWTRLoadTimelineCompletion) {
            
        }
    }
}
