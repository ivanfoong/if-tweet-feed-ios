//
//  TwitterService.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 22/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

protocol TwitterServiceInterface {
    func existingSessions() -> [TWTRAuthSession]
    func logIn(with completion: @escaping TWTRLogInCompletion)
    func logOut()
    func loadPreviousTweets(beforeCursor: TWTRTimelineCursor?, with completion: @escaping TWTRLoadTimelineCompletion)
}

class TwitterService: TwitterServiceInterface {
    func existingSessions() -> [TWTRAuthSession] {
        guard let sessions = Twitter.sharedInstance().sessionStore.existingUserSessions() as? [TWTRAuthSession] else {
            return []
        }
        return sessions
    }
    
    func logIn(with completion: @escaping TWTRLogInCompletion) {
        Twitter.sharedInstance().logIn(completion: completion)
    }
    
    func logOut() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
        }
    }
    
    func loadPreviousTweets(beforeCursor: TWTRTimelineCursor?, with completion: @escaping TWTRLoadTimelineCompletion) {
        let position: String? = beforeCursor?.minPosition
        guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID  else {
            completion(nil, nil, NSError(domain: "", code: -1, userInfo: nil))
            return
        }
        let client = TWTRAPIClient(userID: userID)
        client.loadUser(withID: userID) { (user, error) -> Void in
            if let user = user {
                let dataSource = TWTRUserTimelineDataSource(screenName: user.screenName, apiClient: client)
                dataSource.loadPreviousTweets(beforePosition: position, completion: completion)
            } else {
                completion(nil, nil, NSError(domain: "", code: -1, userInfo: nil))
            }
        }
    }
}
