//
//  FeedsViewModel.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 22/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import Foundation

protocol FeedsViewModelInterface {
    weak var delegate: FeedsViewModelDelegate? { get }
    var twitterService: TwitterServiceInterface { get }
    init(delegate: FeedsViewModelDelegate)
    init(delegate: FeedsViewModelDelegate, twitterService: TwitterServiceInterface)
    func viewWillAppear(animated: Bool)
    var tweetCount: Int { get }
    func tweet(at index: Int) -> TWTRTweet?
    func willDisplayTweet(at index: Int)
    func didSelect(url: URL)
}

class FeedsViewModel: FeedsViewModelInterface {
    weak var delegate: FeedsViewModelDelegate?
    var twitterService: TwitterServiceInterface
    
    private var isLoadingMoreTweet = false
    private var lastCursor: TWTRTimelineCursor?
    private var tweets = [TWTRTweet]() {
        didSet {
            self.delegate?.tweetsUpdated()
        }
    }
    
    convenience required init(delegate: FeedsViewModelDelegate) {
        self.init(delegate: delegate, twitterService: TwitterService())
    }
    
    required init(delegate: FeedsViewModelDelegate, twitterService: TwitterServiceInterface) {
        self.delegate = delegate
        self.twitterService = twitterService
    }
    
    func viewWillAppear(animated: Bool) {
        self.loadMoreTweet(since: nil)
    }
    
    var tweetCount: Int {
        get {
            return self.tweets.count
        }
    }
    
    func tweet(at index: Int) -> TWTRTweet? {
        if index < self.tweetCount {
            return self.tweets[index]
        }
        return nil
    }
    
    func willDisplayTweet(at index: Int) {
        if self.lastCursor == nil || self.tweets.count-3 < index {
            self.loadMoreTweet(since: self.lastCursor)
        }
    }
    
    func didSelect(url: URL) {
        self.delegate?.showWebView(for: url)
    }
    
    private func loadMoreTweet(since lastCursor: TWTRTimelineCursor?) {
        if !self.isLoadingMoreTweet {
            self.isLoadingMoreTweet = true
            self.twitterService.loadPreviousTweets(beforeCursor: lastCursor) { [weak self] (tweets, cursor, error) in
                self?.isLoadingMoreTweet = false
                if let error = error {
                    // TODO show error
                    return
                }
                guard let tweets = tweets else {
                    return
                }
                
                self?.lastCursor = cursor
                self?.tweets.append(contentsOf: tweets)
            }
        }
    }
}

protocol FeedsViewModelDelegate: class {
    func tweetsUpdated()
    func showWebView(for url: URL)
}
