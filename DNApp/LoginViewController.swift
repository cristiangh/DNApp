//
//  LoginViewController.swift
//  DNApp
//
//  Created by Cristian Lucania on 05/01/16.
//  Copyright © 2016 Cristian Lucania. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerDidLogin(controller: LoginViewController)
}

class LoginViewController: UIViewController {
    weak var delegate: LoginViewControllerDelegate?
    @IBOutlet weak var dialogView: DesignableView!
    @IBOutlet weak var emailTextField: DesignableTextField!
    @IBOutlet weak var passwordTextField: DesignableTextField!
    
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
        DNService.loginWithEmail(emailTextField.text!, password: passwordTextField.text!) { (token) -> () in
            if let token = token {
                LocalStore.saveToken(token)
                self.delegate?.loginViewControllerDidLogin(self)
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.dialogView.animation = "shake"
                self.dialogView.animate()
            }
        }
    }
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "zoomOut"
        dialogView.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}
