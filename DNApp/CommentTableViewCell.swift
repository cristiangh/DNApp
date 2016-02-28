//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by Cristian Lucania on 09/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate: class {
    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell)
    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell)
}

class CommentTableViewCell: UITableViewCell {
    
    weak var delegate: CommentTableViewCellDelegate?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchUpvote(self)
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchComment(self)
    }
    
    func configureWithComment(comment: JSON) {
        _ = comment["user_portrait_url"].string! // let userPortraitUrl
        let userDisplayName = comment["user_display_name"].string!
        let userJob = comment["user_job"].string!
        let createdAt = comment["created_at"].string!
        let voteCount = comment["vote_count"].int!
        let body = comment["body"].string!
        let commentId = comment["id"].int!
        
        avatarImageView.image = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle(voteCount.description, forState: UIControlState.Normal)
        commentTextView.text = body
        if LocalStore.isCommentUpvoted(commentId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount+1), forState: UIControlState.Normal)
        } else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount), forState: UIControlState.Normal)
        }
    }
}
