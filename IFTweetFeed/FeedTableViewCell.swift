//
//  FeedTableViewCell.swift
//  IFTweetFeed
//
//  Created by Ivan Foong on 12/12/17.
//  Copyright © 2017 Ivan Foong. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    @IBOutlet weak var timestampLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
