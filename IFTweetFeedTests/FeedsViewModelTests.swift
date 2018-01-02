//
//  FeedsViewModelTests.swift
//  IFTweetFeedTests
//
//  Created by Ivan Foong on 2/1/18.
//  Copyright © 2018 Ivan Foong. All rights reserved.
//

import XCTest
import TwitterKit
@testable import IFTweetFeed

class FeedsViewModelTests: XCTestCase {
    
    func testInit() {
        let expectedDelegate = FeedsViewModelDelegateImpl()
        let viewModel = FeedsViewModel(delegate: expectedDelegate)
        
        guard let delegate = viewModel.delegate else {
            XCTFail("Expected viewModel.delegate to not be nil")
            return
        }
        XCTAssert(expectedDelegate === delegate)
    }
    
    func testViewWillAppear() {
        // expects that first sets of tweets be available after tweetsUpdated is called
        let delegate = FeedsViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        let viewModel = FeedsViewModel(delegate: delegate, twitterService: twitterService)
        
        let expectedTweets: [TWTRTweet] = [
            self.generateTweet(with: 1),
            self.generateTweet(with: 2),
            self.generateTweet(with: 3),
            self.generateTweet(with: 4),
            self.generateTweet(with: 5),
            self.generateTweet(with: 6),
            self.generateTweet(with: 7),
            self.generateTweet(with: 8),
            self.generateTweet(with: 9),
            self.generateTweet(with: 10),
        ]
        let expectedCursor = TWTRTimelineCursor(maxPosition: "10", minPosition: "1")!
        twitterService.defaultTimelineCompletionParametersToReturn = (expectedTweets, expectedCursor, nil)
        twitterService.timelineCompletionParametersToReturn = [
            expectedCursor: (expectedTweets, TWTRTimelineCursor(maxPosition: "20", minPosition: "11"), nil)
        ]
        
        XCTAssertEqual(0, viewModel.tweetCount)
        
        let tweetsUpdatedDidCalledExpectation = XCTestExpectation(description: "tweetsUpdated did call")
        delegate.tweetsUpdatedDidCalledExpectation = tweetsUpdatedDidCalledExpectation
        viewModel.viewWillAppear(animated: true)
        wait(for: [tweetsUpdatedDidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedTweets.count, viewModel.tweetCount)
    }
    
    func testTweetCount() {
        // expects that correct tweet count to be returned
        let delegate = FeedsViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        let viewModel = FeedsViewModel(delegate: delegate, twitterService: twitterService)
        
        let expectedTweets: [TWTRTweet] = [
            self.generateTweet(with: 1),
            self.generateTweet(with: 2),
            self.generateTweet(with: 3),
            self.generateTweet(with: 4),
            self.generateTweet(with: 5),
            self.generateTweet(with: 6),
            self.generateTweet(with: 7),
            self.generateTweet(with: 8),
            self.generateTweet(with: 9),
            self.generateTweet(with: 10),
        ]
        let expectedCursor = TWTRTimelineCursor(maxPosition: "10", minPosition: "1")!
        twitterService.defaultTimelineCompletionParametersToReturn = (expectedTweets, expectedCursor, nil)
        twitterService.timelineCompletionParametersToReturn = [
            expectedCursor: (expectedTweets, TWTRTimelineCursor(maxPosition: "20", minPosition: "11"), nil)
        ]
        
        XCTAssertEqual(0, viewModel.tweetCount)
        
        let tweetsUpdatedDidCalledExpectation = XCTestExpectation(description: "tweetsUpdated did call")
        delegate.tweetsUpdatedDidCalledExpectation = tweetsUpdatedDidCalledExpectation
        viewModel.willDisplayTweet(at: 0)
        wait(for: [tweetsUpdatedDidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedTweets.count, viewModel.tweetCount)
    }
    
    func testTweetAt() {
        // expects that correct tweet will be returned
        let delegate = FeedsViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        let viewModel = FeedsViewModel(delegate: delegate, twitterService: twitterService)
        
        let expectedTweets: [TWTRTweet] = [
            self.generateTweet(with: 1),
            self.generateTweet(with: 2),
            self.generateTweet(with: 3),
            self.generateTweet(with: 4),
            self.generateTweet(with: 5),
            self.generateTweet(with: 6),
            self.generateTweet(with: 7),
            self.generateTweet(with: 8),
            self.generateTweet(with: 9),
            self.generateTweet(with: 10),
        ]
        let expectedCursor = TWTRTimelineCursor(maxPosition: "10", minPosition: "1")!
        twitterService.defaultTimelineCompletionParametersToReturn = (expectedTweets, expectedCursor, nil)
        twitterService.timelineCompletionParametersToReturn = [
            expectedCursor: (expectedTweets, TWTRTimelineCursor(maxPosition: "20", minPosition: "11"), nil)
        ]
        
        let tweetsUpdatedDidCalledExpectation = XCTestExpectation(description: "tweetsUpdated did call")
        delegate.tweetsUpdatedDidCalledExpectation = tweetsUpdatedDidCalledExpectation
        viewModel.willDisplayTweet(at: 0)
        wait(for: [tweetsUpdatedDidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedTweets[0], viewModel.tweet(at: 0))
    }
    
    func testWillDisplayTweetAt() {
        // expects that more tweets is available after tweetsUpdated is called
        let delegate = FeedsViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        let viewModel = FeedsViewModel(delegate: delegate, twitterService: twitterService)
        
        let expectedTweets: [TWTRTweet] = [
            self.generateTweet(with: 1),
            self.generateTweet(with: 2),
            self.generateTweet(with: 3),
            self.generateTweet(with: 4),
            self.generateTweet(with: 5),
            self.generateTweet(with: 6),
            self.generateTweet(with: 7),
            self.generateTweet(with: 8),
            self.generateTweet(with: 9),
            self.generateTweet(with: 10),
            ]
        let expectedCursor = TWTRTimelineCursor(maxPosition: "10", minPosition: "1")!
        twitterService.defaultTimelineCompletionParametersToReturn = (expectedTweets, expectedCursor, nil)
        twitterService.timelineCompletionParametersToReturn = [
            expectedCursor: (expectedTweets, TWTRTimelineCursor(maxPosition: "20", minPosition: "11"), nil)
        ]
        
        let tweetsUpdatedDidCalledExpectation = XCTestExpectation(description: "tweetsUpdated did call")
        delegate.tweetsUpdatedDidCalledExpectation = tweetsUpdatedDidCalledExpectation
        viewModel.willDisplayTweet(at: 0)
        wait(for: [tweetsUpdatedDidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedTweets.count, viewModel.tweetCount)
        
        let tweetsUpdated2DidCalledExpectation = XCTestExpectation(description: "tweetsUpdated did call second time")
        delegate.tweetsUpdatedDidCalledExpectation = tweetsUpdated2DidCalledExpectation
        viewModel.willDisplayTweet(at: 8)
        wait(for: [tweetsUpdated2DidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedTweets.count * 2, viewModel.tweetCount)
    }
    
    func testDidSelectUrl() {
        let delegate = FeedsViewModelDelegateImpl()
        let twitterService = MockTwitterService()
        let expectedUrl = URL(string: "http://example.com/")!
        let viewModel = FeedsViewModel(delegate: delegate, twitterService: twitterService)
        
        let showWebViewDidCalledExpectation = XCTestExpectation(description: "showWebView did called")
        delegate.showWebViewDidCalledExpectation = showWebViewDidCalledExpectation
        
        viewModel.didSelect(url: expectedUrl)
        wait(for: [showWebViewDidCalledExpectation], timeout: 1)
        XCTAssertEqual(expectedUrl, delegate.showWebViewUrl)
    }
    
    private func generateTweet(with id: Int) -> TWTRTweet {
        let json = """
{"created_at":"Thu Apr 06 15:28:43 +0000 2017","id":\(id),"id_str":"\(id)","text":"RT @TwitterDev: 1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP","truncated":false,"entities":{"hashtags":[],"symbols":[],"user_mentions":[{"screen_name":"TwitterDev","name":"TwitterDev","id":2244994945,"id_str":"2244994945","indices":[3,14]}],"urls":[{"url":"https://t.co/XweGngmxlP","expanded_url":"https://cards.twitter.com/cards/18ce53wgo4h/3xo1c","display_url":"cards.twitter.com/cards/18ce53wg…","indices":[94,117]}]},"source":"<a href=\\"http://twitter.com\\" rel=\\"nofollow\\">Twitter Web Client</a>","in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":6253282,"id_str":"6253282","name":"Twitter API","screen_name":"twitterapi","location":"San Francisco, CA","description":"The Real Twitter API. I tweet about API changes, service issues and happily answer questions about Twitter and our API. Don't get an answer? It's on my website.","url":"http://t.co/78pYTvWfJd","entities":{"url":{"urls":[{"url":"http://t.co/78pYTvWfJd","expanded_url":"https://dev.twitter.com","display_url":"dev.twitter.com","indices":[0,22]}]},"description":{"urls":[]}},"protected":false,"followers_count":6172353,"friends_count":46,"listed_count":13091,"created_at":"Wed May 23 06:01:13 +0000 2007","favourites_count":26,"utc_offset":-25200,"time_zone":"Pacific Time (US & Canada)","geo_enabled":true,"verified":true,"statuses_count":3583,"lang":"en","contributors_enabled":false,"is_translator":false,"is_translation_enabled":false,"profile_background_color":"C0DEED","profile_background_image_url":"http://pbs.twimg.com/profile_background_images/656927849/miyt9dpjz77sc0w3d4vj.png","profile_background_image_url_https":"https://pbs.twimg.com/profile_background_images/656927849/miyt9dpjz77sc0w3d4vj.png","profile_background_tile":true,"profile_image_url":"http://pbs.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png","profile_image_url_https":"https://pbs.twimg.com/profile_images/2284174872/7df3h38zabcvjylnyfe3_normal.png","profile_banner_url":"https://pbs.twimg.com/profile_banners/6253282/1431474710","profile_link_color":"0084B4","profile_sidebar_border_color":"C0DEED","profile_sidebar_fill_color":"DDEEF6","profile_text_color":"333333","profile_use_background_image":true,"has_extended_profile":false,"default_profile":false,"default_profile_image":false,"following":true,"follow_request_sent":false,"notifications":false,"translator_type":"regular"},"geo":null,"coordinates":null,"place":null,"contributors":null,"retweeted_status":{"created_at":"Thu Apr 06 15:24:15 +0000 2017","id":850006245121695744,"id_str":"850006245121695744","text":"1/ Today we’re sharing our vision for the future of the Twitter API platform!nhttps://t.co/XweGngmxlP","truncated":false,"entities":{"hashtags":[],"symbols":[],"user_mentions":[],"urls":[{"url":"https://t.co/XweGngmxlP","expanded_url":"https://cards.twitter.com/cards/18ce53wgo4h/3xo1c","display_url":"cards.twitter.com/cards/18ce53wg…","indices":[78,101]}]},"source":"<a href=\\"http://twitter.com\\" rel=\\"nofollow\\">Twitter Web Client</a>","in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"in_reply_to_user_id":null,"in_reply_to_user_id_str":null,"in_reply_to_screen_name":null,"user":{"id":2244994945,"id_str":"2244994945","name":"TwitterDev","screen_name":"TwitterDev","location":"Internet","description":"Your official source for Twitter Platform news, updates & events. Need technical help? Visit https://t.co/mGHnxZCxkt ⌨️  #TapIntoTwitter","url":"https://t.co/66w26cua1O","entities":{"url":{"urls":[{"url":"https://t.co/66w26cua1O","expanded_url":"https://dev.twitter.com/","display_url":"dev.twitter.com","indices":[0,23]}]},"description":{"urls":[{"url":"https://t.co/mGHnxZCxkt","expanded_url":"https://twittercommunity.com/","display_url":"twittercommunity.com","indices":[93,116]}]}},"protected":false,"followers_count":465425,"friends_count":1523,"listed_count":1168,"created_at":"Sat Dec 14 04:35:55 +0000 2013","favourites_count":2098,"utc_offset":-25200,"time_zone":"Pacific Time (US & Canada)","geo_enabled":true,"verified":true,"statuses_count":3031,"lang":"en","contributors_enabled":false,"is_translator":false,"is_translation_enabled":false,"profile_background_color":"FFFFFF","profile_background_image_url":"http://abs.twimg.com/images/themes/theme1/bg.png","profile_background_image_url_https":"https://abs.twimg.com/images/themes/theme1/bg.png","profile_background_tile":false,"profile_image_url":"http://pbs.twimg.com/profile_images/530814764687949824/npQQVkq8_normal.png","profile_image_url_https":"https://pbs.twimg.com/profile_images/530814764687949824/npQQVkq8_normal.png","profile_banner_url":"https://pbs.twimg.com/profile_banners/2244994945/1396995246","profile_link_color":"0084B4","profile_sidebar_border_color":"FFFFFF","profile_sidebar_fill_color":"DDEEF6","profile_text_color":"333333","profile_use_background_image":false,"has_extended_profile":false,"default_profile":false,"default_profile_image":false,"following":true,"follow_request_sent":false,"notifications":false,"translator_type":"regular"},"geo":null,"coordinates":null,"place":null,"contributors":null,"is_quote_status":false,"retweet_count":284,"favorite_count":399,"favorited":false,"retweeted":false,"possibly_sensitive":false,"lang":"en"},"is_quote_status":false,"retweet_count":284,"favorite_count":0,"favorited":false,"retweeted":false,"possibly_sensitive":false,"lang":"en"}
"""
        let jsonDictionary = try! JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as! [String: Any]
        return TWTRTweet(jsonDictionary: jsonDictionary)!
    }
    
    class FeedsViewModelDelegateImpl: FeedsViewModelDelegate {
        var tweetsUpdatedDidCalledExpectation: XCTestExpectation?
        var showWebViewDidCalledExpectation: XCTestExpectation?
        var showWebViewUrl: URL?
        
        func tweetsUpdated() {
            self.tweetsUpdatedDidCalledExpectation?.fulfill()
        }
        
        func showWebView(for url: URL) {
            self.showWebViewUrl = url
            self.showWebViewDidCalledExpectation?.fulfill()
        }
    }
    
    class MockTwitterService: TwitterServiceInterface {
        var existingSessionsToReturn = [TWTRSession]()
        var defaultTimelineCompletionParametersToReturn: ([TWTRTweet]?, TWTRTimelineCursor?, NSError?)?
        var timelineCompletionParametersToReturn: [TWTRTimelineCursor: ([TWTRTweet]?, TWTRTimelineCursor?, NSError?)] = [:]
        
        func existingSessions() -> [TWTRAuthSession] {
            return existingSessionsToReturn
        }
        
        func logIn(with completion: @escaping TWTRLogInCompletion) {
        }
        
        func logOut() {
            
        }
        
        func loadPreviousTweets(beforeCursor: TWTRTimelineCursor?, with completion: @escaping TWTRLoadTimelineCompletion) {
            if let cursor = beforeCursor, let parameters = self.timelineCompletionParametersToReturn[cursor] {
                completion(parameters.0, parameters.1, parameters.2)
            } else if let parameters = self.defaultTimelineCompletionParametersToReturn {
                completion(parameters.0, parameters.1, parameters.2)
            }
        }
    }
}
