//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by Cristian Lucania on 09/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
    }
    
    func configureWithComment(comment: JSON) {
        _ = comment["user_portrait_url"].string! // let userPortraitUrl
        let userDisplayName = comment["user_display_name"].string!
        let userJob = comment["user_job"].string!
        let createdAt = comment["created_at"].string!
        let voteCount = comment["vote_count"].int!
        let body = comment["body"].string!
        
        avatarImageView.image = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle(voteCount.description, forState: UIControlState.Normal)
        commentTextView.text = body
    }
}
