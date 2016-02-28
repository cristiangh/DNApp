//
//  StoryTableViewCell.swift
//  DNApp
//
//  Created by Cristian Lucania on 06/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

protocol StoryTableViewCellDelegate : class {
    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject)
    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject)
}

class StoryTableViewCell: UITableViewCell {
    
    weak var delegate: StoryTableViewCellDelegate?
    
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var commentButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!

    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        upvoteButton.animation = "pop"
        upvoteButton.force = 3
        upvoteButton.animate()
        
        delegate?.storyTableViewCellDidTouchUpvote(self, sender: sender)
    }
    
    @IBAction func commentButtonDidTouch(sender: AnyObject) {
        commentButton.animation = "pop"
        commentButton.force = 3
        commentButton.animate()
        
        delegate?.storyTableViewCellDidTouchComment(self, sender: sender)
    }
    
    func configureWithStory(story: JSON) {
        let title = story["title"].string ?? ""
        let badge = story["badge"].string ?? ""
        _ = story["user_portrait_url"].string ?? "" // let userPortraitUrl
        let userDisplayName = story["user_display_name"].string ?? ""
        let userJob = story["user_job"].string ?? ""
        let createdAt = story["created_at"].string ?? ""
        let voteCount = story["vote_count"].int!
        let commentCount = story["comment_count"].int!
        
        titleLabel.text = title
        badgeImageView.image = UIImage(named: "badge-" + badge)
        avatarImageView.image = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle(voteCount.description, forState: UIControlState.Normal)
        commentButton.setTitle(commentCount.description, forState: UIControlState.Normal)
        
        let comment = story["comment"].string ?? ""
        if let commentTextView = commentTextView {
            commentTextView.text = comment
        }

        let storyId = story["id"].int!
        if LocalStore.isStoryUpvoted(storyId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount + 1), forState: UIControlState.Normal)
        } else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount), forState: UIControlState.Normal)
        }

    }
}
