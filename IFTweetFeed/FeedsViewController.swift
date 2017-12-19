//
//  FeedsViewController.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 12/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import UIKit
import TwitterKit
import TTTAttributedLabel
import SafariServices

class FeedsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [TWTRTweet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var client: TWTRAPIClient?
    private var dataSource: TWTRUserTimelineDataSource?
    private var lastCursor: TWTRTimelineCursor?
    private var isLoadingMoreTweet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUser(withID: userID) { (user, error) -> Void in
                if let user = user {
                    let dataSource = TWTRUserTimelineDataSource(screenName: user.screenName, apiClient: client)
                    dataSource.loadPreviousTweets(beforePosition: nil) { [weak self] (tweets, cursor, error) in
                        if let error = error {
                            // TODO show error
                            return
                        }
                        guard let tweets = tweets else {
                            return
                        }
                        
                        self?.lastCursor = cursor
                        self?.tweets = tweets
                    }
                    self.dataSource = dataSource
                }
            }
            self.client = client
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
        }
    }

}

extension FeedsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        if indexPath.row < self.tweets.count {
            let tweet = self.tweets[indexPath.row]
            cell.usernameLabel.text = "@\(tweet.author.screenName)"
            cell.contentLabel.text = tweet.text
            cell.contentLabel.delegate = self
            let dateFormatter = DateFormatter()
            cell.timestampLabel.text = dateFormatter.timeSince(from: tweet.createdAt)
        }
        return cell
    }
}

extension FeedsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastCursor = self.lastCursor, self.tweets.count-3 < indexPath.row {
            self.loadMoreTweet(since: lastCursor)
        }
    }
    
    private func loadMoreTweet(since lastCursor: TWTRTimelineCursor) {
        if !self.isLoadingMoreTweet {
            print("loadMoreTweet")
            self.isLoadingMoreTweet = true
            self.dataSource?.loadPreviousTweets(beforePosition: lastCursor.minPosition) { [weak self] (tweets, cursor, error) in
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

extension FeedsViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
}
