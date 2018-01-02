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
    
    private var viewModel: FeedsViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = FeedsViewModel(delegate: self)
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear(animated: animated)
    }
}

extension FeedsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tweetCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let index = indexPath.row
        if index < self.viewModel.tweetCount, let tweet = self.viewModel.tweet(at: index) {
            cell.configure(for: tweet, with: self)
        }
        return cell
    }
}

extension FeedsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        self.viewModel.willDisplayTweet(at: index)
    }
}

extension FeedsViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        self.viewModel.didSelect(url: url)
    }
}

extension FeedsViewController: FeedsViewModelDelegate {
    func tweetsUpdated() {
        self.tableView.reloadData()
    }
    
    func showWebView(for url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        self.present(safariViewController, animated: true, completion: nil)
    }
}
