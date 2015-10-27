//
//  ViewController.swift
//  ChatApp
//
//  Created by TangWeichang on 10/4/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func login(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTxt.text!, password: passwordTxt.text!) { (user, error) -> Void in
            if error == nil {
                print("log in")
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                
                self.performSegueWithIdentifier("goToUserVC", sender: self)
            } else {
                print("error log in")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    @IBOutlet var welcomeLable: UILabel!
    
    @IBOutlet var usernameTxt: UITextField!
    
    @IBOutlet var passwordTxt: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var Signup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        welcomeLable.center = CGPointMake(theWidth / 2, 130)
        usernameTxt.frame = CGRectMake(16 , 200, theWidth - 32, 30)
        passwordTxt.frame = CGRectMake(16, 240, theWidth - 32, 30)
        loginButton.center = CGPointMake(theWidth / 2, 330)
        Signup.center = CGPointMake(theWidth / 2, theHeight - 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


}

