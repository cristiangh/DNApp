//
//  StoriesTableViewController.swift
//  DNApp
//
//  Created by Cristian Lucania on 05/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

class StoriesTableViewController: UITableViewController, StoryTableViewCellDelegate, MenuViewControllerDelegate, LoginViewControllerDelegate {
    
    @IBOutlet weak var loginButton: UIBarButtonItem!

    var stories: JSON! = []
    var isFirstTime = true
    var section = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        loadStories("", page: 1)
        
        if LocalStore.getToken() == nil {
            loginButton.title = "Login"
            loginButton.enabled = true
        } else {
            loginButton.title = ""
            loginButton.enabled = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if isFirstTime {
            view.showLoading()
            isFirstTime = false
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func menuButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("MenuSegue", sender: self)
    }
    
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("LoginSegue", sender: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryCell") as! StoryTableViewCell
        
        let story = stories[indexPath.row]
        
        cell.configureWithStory(story)
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("WebSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: StoryTableViewCellDelegate
    
    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject) {
        // TODO: implement Upvote
    }
    
    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject) {
        performSegueWithIdentifier("CommentsSegue", sender: cell)
    }
    
    // MARK: Misc
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentsSegue" {
            let toView = segue.destinationViewController as! CommentsTableViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
            let story = stories[indexPath.row]
            toView.story = story
        }
        if segue.identifier == "MenuSegue" {
            let toView = segue.destinationViewController as! MenuViewController
            toView.delegate = self
        }
        if segue.identifier == "LoginSegue" {
            let toView = segue.destinationViewController as! LoginViewController
            toView.delegate = self
        }
    }
    
    func loadStories(section: String, page: Int) {
        DNService.storiesForSection(section, page: page){(JSON)->() in
            self.stories = JSON["stories"]
            self.tableView.reloadData()
            self.view.hideLoading()
        }
    }
    
    // MARK: MenuViewControllerDelegate
    
    func menuViewControllerDidTouchTop(controller: MenuViewController) {
        view.showLoading()
        loadStories("", page: 1)
        navigationItem.title = "Top Stories"
        section = ""
    }
    
    func menuViewControllerDidTouchRecent(controller: MenuViewController) {
        view.showLoading()
        loadStories("recent", page: 1)
        navigationItem.title = "Recent Stories"
        section = "recent"
    }
    
    func menuViewControllerDidTouchLogout(controller: MenuViewController) {
        loadStories(section, page: 1)
        view.showLoading()
    }
    
    // MARK: LoginViewControllerDelegate
    
    func loginViewControllerDidLogin(controller: LoginViewController) {
        loadStories(section, page: 1)
        view.showLoading()
    }
}









