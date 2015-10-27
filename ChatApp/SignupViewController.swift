//
//  SignupViewController.swift
//  ChatApp
//
//  Created by TangWeichang on 10/4/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate  {
    @IBAction func addPhotoButton(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImg.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        profileNameTxt.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if UIScreen.mainScreen().bounds.height == 500 {
            if textField == self.profileNameTxt {
                UIView.animateWithDuration(0.3, delay: 0, options:  .CurveLinear, animations: { () -> Void in
                    self.view.center = CGPointMake(theWidth / 2, (theHeight / 2) - 40)
                    }, completion: nil)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if UIScreen.mainScreen().bounds.height == 500 {
            if textField == self.profileNameTxt {
                UIView.animateWithDuration(0.3, delay: 0, options:  .CurveLinear, animations: { () -> Void in
                    self.view.center = CGPointMake(theWidth / 2, (theHeight / 2))
                    }, completion: nil)
            }
        }
    }
    @IBAction func signUpAction(sender: AnyObject) {
        
        var user = PFUser()
        user.username = emailTxt.text
        user.password = passwordTxt.text
        user.email = emailTxt.text
        user["profileName"] = profileNameTxt.text
        
        let imageData = UIImagePNGRepresentation(self.profileImg.image!)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData!)
        user["photo"] = imageFile
        user.signUpInBackgroundWithBlock { (succeeded , signUpError) -> Void in
            if signUpError == nil {
                print("signUp")
                
                var installation:PFInstallation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                self.performSegueWithIdentifier("goToUsersVC2", sender: self)
                
            } else {
                print("cannot signup")
            }
        }
        
    }

    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var addImage: UIButton!
    
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var profileNameTxt: UITextField!
    @IBOutlet var signUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height

        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        profileImg.center = CGPointMake(theWidth / 2, 140)
        
        addImage.center = CGPointMake(self.profileImg.frame.maxX+50,140)
        emailTxt.frame = CGRectMake(16, 230, theWidth - 32, 30)
        passwordTxt.frame = CGRectMake(16, 270, theWidth - 32, 30)
        profileNameTxt.frame = CGRectMake(16, 310, theWidth - 32, 30)
        signUp.center = CGPointMake(theWidth / 2, 380)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
