//
//  MenuViewController.swift
//  DNApp
//
//  Created by Cristian Lucania on 06/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
    func menuViewControllerDidTouchLogout(controller: MenuViewController)
}

class MenuViewController: UIViewController {
    weak var delegate: MenuViewControllerDelegate?
    
    @IBOutlet weak var designView: DesignableView!
    @IBOutlet weak var loginLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LocalStore.getToken() == nil {
            loginLabel.text = "Login"
        } else {
            loginLabel.text = "Logout"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        designView.animation = "fall"
        designView.animate()
    }

    @IBAction func topButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func recentButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        if LocalStore.getToken() == nil {
            performSegueWithIdentifier("LoginSegue", sender: self)
        } else {
            LocalStore.deleteToken()
            self.closeButtonDidTouch(self)
            delegate?.menuViewControllerDidTouchLogout(self)
        }
    }
}
