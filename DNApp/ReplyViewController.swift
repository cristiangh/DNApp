//
//  ReplyViewController.swift
//  DNApp
//
//  Created by Cristian Lucania on 28/02/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}

class ReplyViewController: UIViewController {
    weak var delegate: ReplyViewControllerDelegate?
    var story: JSON = []
    var comment: JSON = []
    
    @IBOutlet weak var replyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.becomeFirstResponder()
    }
    
    @IBAction func sendButtonDidTouch(sender: AnyObject) {
        view.showLoading()
        let token = LocalStore.getToken()
        let body = replyTextView.text
        if let storyId = story["id"].int {
            DNService.replyStoryWithId(storyId, token: token!, body: body, response:{(successful)->() in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.showAlert()
                }
            })
        }
        if let commentId = comment["id"].int {
            DNService.replyCommentWithId(commentId, token: token!, body: body, response: {(successful)->() in
                self.view.hideLoading()
                if successful {
                    self.delegate?.replyViewControllerDidSend(self)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.showAlert()
                }
            })
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oh noes", message: "Something get wrong", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
