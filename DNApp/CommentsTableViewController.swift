//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by Cristian Lucania on 09/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate, ReplyViewControllerDelegate {

    var story = JSON!()
    var comments: [JSON]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        comments = flattenComments(story["comments"].array ?? [])
        
        refreshControl?.addTarget(self, action: "reloadStory", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell!
        if let storyCell = cell as? StoryTableViewCell {
            storyCell.delegate = self
            storyCell.configureWithStory(story)
        }
        if let commentCell = cell as? CommentTableViewCell {
            commentCell.delegate = self
            let comment = comments[indexPath.row-1]
            commentCell.configureWithComment(comment)
        }
        
        return cell
    }
    
    func reloadStory() {
        view.showLoading()
        DNService.storyForId(story["id"].int!, response:{(JSON)->() in
            self.view.hideLoading()
            self.story = JSON["story"]
            self.comments = self.flattenComments(JSON["story"]["comments"].array ?? [])
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: CommentTableViewCellDelegate
    
    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: self)
        }
    }
    
    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell) {
        if let token = LocalStore.getToken() {
            let indexPath = tableView.indexPathForCell(cell)
            let comment = comments[indexPath!.row-1]
            let commentId = comment["id"].int!
            DNService.upvoteCommentWithId(commentId, token: token, response: {successful->() in
                // Do something
            })
            LocalStore.saveUpvotedComment(commentId)
            cell.configureWithComment(comment)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    // MARK: StoryTableViewCellDelegate
    
    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            performSegueWithIdentifier("ReplySegue", sender: self)
        }
    }
    
    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject) {
        if let token = LocalStore.getToken() {
            let storyId = story["id"].int!
            DNService.upvoteStoryWithId(storyId, token: token, response: {successful ->() in
                // Do something
            })
            LocalStore.saveUpvotedStory(storyId)
            cell.configureWithStory(story)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ReplySegue" {
            let toView = segue.destinationViewController as! ReplyViewController
            if let cell = sender as? CommentTableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                let comment = comments[indexPath!.row-1]
                toView.comment = comment
                toView.delegate = self
            }
            if let _ = sender as? StoryTableViewCell {
                toView.story = story
            }
        }
    }
    
    // MARK: ReplyViewControllerDelegate
    
    func replyViewControllerDidSend(controller: ReplyViewController) {
        reloadStory()
    }
    
    func flattenComments(comments: [JSON]) -> [JSON] {
        let flattenedComments = comments.map(commentsForComment).reduce([],combine: +)
        return flattenedComments
    }
    func commentsForComment(comment: JSON) -> [JSON] {
        let comments = comment["comments"].array ?? []
        return comments.reduce([comment]){acc, x in
            acc + self.commentsForComment(x)
        }
    }
}
