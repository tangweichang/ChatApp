//
//  conversationController.swift
//  ChatApp
//
//  Created by TangWeichang on 10/7/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

var otherName = ""
var otherProfileName = ""

class conversationController: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet var resultScrollView: UIScrollView!

    @IBOutlet var frameMessageView: UIView!
    
    @IBOutlet var lineLabel: UILabel!
    //@IBOutlet var blockBtn: UIBarButtonItem!
    
    @IBOutlet var messageTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    var blockBtn = UIBarButtonItem()
    var reportBtn = UIBarButtonItem()
    
    
    var isBlocked = false
    
    @IBAction func sendbtn_clicked(sender: AnyObject) {
        if isBlocked == true {
            print("You are blocked")
            return
        }
        
        if blockBtn.title == "Unblock" {
            print("You have blocked this User!!! unblock to send message")
            return
        }
        
        if messageTextView.text == "" {
            print("no text")
        } else {
            var messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success == true {
                    print("message sent")
                    self.messageTextView.text == ""
                    self.mlabel.hidden = false
                    self.refreshResults()
                    
                }
            })
        }
        
    }
    
    func blockBtn_clicked() {
        if blockBtn.title == "Block" {
            var addBlock = PFObject(className: "Block")
            addBlock.setObject(userName, forKey: "user")
            addBlock.setObject(otherName, forKey: "blocked")
            addBlock.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print("addBlock succeed")
                }
            })
            self.blockBtn.title = "Unblock"
        } else {
            var query:PFQuery = PFQuery(className: "Block")
            query.whereKey("user", equalTo: userName)
            query.whereKey("blocked", equalTo: otherName)
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                    
                    self.blockBtn.title = "Block"
                }
            })
            
        }
        
    }
    
    func reportBtn_clicked() {
        print("report pressed")
        var addReport = PFObject(className: "Report")
        addReport.setObject(userName, forKey: "user")
        addReport.setObject(otherName, forKey: "reported")
        addReport.saveInBackgroundWithBlock { (success, error) -> Void in
            if error != nil {
                print("report successfully")
            }
        }
    }
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var messageArray = [String]()
    var senderArray = [String]()
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3
    
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    
    var myImg:UIImage? = UIImage()
    var otherImg:UIImage? = UIImage()
    
    var resultImageFiles = [PFFile]()
    var resultImageFiles2 = [PFFile]()
    
    let mlabel = UILabel(frame: CGRectMake(5,8,200,20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultScrollView.frame = CGRectMake(0, 64, theWidth, theHeight - 114)
        resultScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRectMake(0, resultScrollView.frame.maxY, theWidth, 50)
        lineLabel.frame = CGRectMake(0, 0, theWidth, 1)
        messageTextView.frame = CGRectMake(2, 1, self.frameMessageView.frame.size.width-52, 48)
        sendButton.center = CGPointMake(frameMessageView.frame.size.width-30, 24)
        
        scrollViewOriginalY = self.resultScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        self.title = otherProfileName
        mlabel.text = "Type a message..."
        mlabel.backgroundColor = UIColor.clearColor()
        mlabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mlabel)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        
        blockBtn.title = ""
        
        blockBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("blockBtn_clicked"))
        reportBtn = UIBarButtonItem(title: "Report", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("reportBtn_clicked"))
        var buttonArray = NSArray(objects: blockBtn, reportBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
        
    }
    
    func didTapScrollView() {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        if !messageTextView.hasText() {
            self.mlabel.hidden = false
        } else {
            self.mlabel.hidden = true
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if !messageTextView.hasText() {
            self.mlabel.hidden = false
        } 
    }
    
    func keyboardWasShown(notification:NSNotification) {
        let dict:NSDictionary = notification.userInfo!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.CGRectValue()
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            let bottomOffset:CGPoint = CGPointMake(0, self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })

    }
    
    func keyboardWillHide(notification:NSNotification) {
        //let dict:NSDictionary = notification.userInfo!
        //let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {
            
            self.resultScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            let bottomOffset:CGPoint = CGPointMake(0, self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
            self.resultScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var checkQuery = PFQuery(className: "Block")
        checkQuery.whereKey("user", equalTo: otherName)
        checkQuery.whereKey("blocked", equalTo: userName)
        var objects2 = checkQuery.findObjectsInBackgroundWithBlock { (objects2, error) -> Void in
            if let objects2 = objects2 {
                if objects2.count > 0 {
                    self.isBlocked = true
                } else {
                    self.isBlocked = false
                    
                }
                
            }
        }
        
        var blockQuery = PFQuery(className: "Block")
        blockQuery.whereKey("user", equalTo: userName)
        blockQuery.whereKey("blocked", equalTo: otherName)
        
        blockQuery.findObjectsInBackgroundWithBlock { (objects0, error) -> Void in
            if let objects0 = objects0 {
                if objects0.count > 0 {
                    self.blockBtn.title = "Unblock"
                    
                } else {
                    self.blockBtn.title = "Block"
                }
                
            }
        }
        
        
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        self.resultImageFiles.removeAll(keepCapacity: false)

        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                for object in objects as! [PFUser] {
                    self.resultImageFiles.append(object["photo"] as! PFFile)
                    self.resultImageFiles[0].getDataInBackgroundWithBlock({ (imageData , error) -> Void in
                        self.myImg = UIImage(data: imageData!)
                        var query2 = PFQuery(className: "_User")
                        query2.whereKey("username", equalTo: otherName)
                        self.resultImageFiles2.removeAll(keepCapacity: false)
                        
                        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                            if let objects = objects {
                                for object in objects as! [PFUser] {
                                    self.resultImageFiles2.append(object["photo"] as! PFFile)
                                    
                                    self.resultImageFiles2[0].getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                        if error == nil {
                                            self.otherImg = UIImage(data: imageData!)
                                            self.refreshResults()
                                        }
                                    })
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
                                
          
        
        

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshResults() {
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3
        
        messageArray.removeAll(keepCapacity: false)
        senderArray.removeAll(keepCapacity: false)
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherName)
        var innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName, userName)
        var innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1,innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    self.senderArray.append(object.objectForKey("sender") as! String)
                    self.messageArray.append(object.objectForKey("message") as! String)
                }
                
                for subview in self.resultScrollView.subviews {
                    subview.removeFromSuperview()
                }
                
                for var i = 0; i <= self.messageArray.count - 1; i++ {
                    if self.senderArray[i] == userName {
                        var messageLabel:UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultScrollView.frame.width - 94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.blackColor()
                        messageLabel.text = self.messageArray[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = (self.resultScrollView.frame.size.width - self.messageX) - messageLabel.frame.size.width
                        messageLabel.frame.origin.y = self.messageY
                        self.resultScrollView.addSubview(messageLabel)
                        self.messageY += messageLabel.frame.size.height + 30
                        
                        var frameLabel:UILabel = UILabel()
                        frameLabel.frame.size = CGSizeMake(messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
                        frameLabel.frame.origin.x = (self.resultScrollView.frame.size.width - self.frameX) - frameLabel.frame.size.width
                        frameLabel.frame.origin.y = self.frameY
                        frameLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        var img:UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSizeMake(34, 34)
                        img.frame.origin.x = (self.resultScrollView.frame.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        self.imgY += frameLabel.frame.size.height + 20
                        
                        self.resultScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    } else {
                        var messageLabel:UILabel = UILabel()
                        messageLabel.frame = CGRectMake(0, 0, self.resultScrollView.frame.width - 94, CGFloat.max)
                        messageLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        messageLabel.textAlignment = NSTextAlignment.Left
                        messageLabel.numberOfLines = 0
                        messageLabel.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLabel.textColor = UIColor.blackColor()
                        messageLabel.text = self.messageArray[i]
                        messageLabel.sizeToFit()
                        messageLabel.layer.zPosition = 20
                        messageLabel.frame.origin.x = self.messageX
                        messageLabel.frame.origin.y = self.messageY
                        self.resultScrollView.addSubview(messageLabel)
                        self.messageY += messageLabel.frame.size.height + 30
                        
                        var frameLabel:UILabel = UILabel()
                        frameLabel.frame = CGRectMake(self.frameX, self.frameY, messageLabel.frame.size.width + 10, messageLabel.frame.size.height + 10)
                        
                        frameLabel.backgroundColor = UIColor.groupTableViewBackgroundColor()
                        frameLabel.layer.masksToBounds = true
                        frameLabel.layer.cornerRadius = 10
                        self.resultScrollView.addSubview(frameLabel)
                        self.frameY += frameLabel.frame.size.height + 20
                        
                        var img:UIImageView = UIImageView()
                        img.image = self.otherImg
                        img.frame = CGRectMake(self.imgX, self.imgY, 34, 34)
                        
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width / 2
                        img.clipsToBounds = true
                        self.resultScrollView.addSubview(img)
                        self.imgY += frameLabel.frame.size.height + 20
                        
                        self.resultScrollView.contentSize = CGSizeMake(theWidth, self.messageY)
                        
                    }
                    
                    var bottomOffset:CGPoint = CGPointMake(0 , self.resultScrollView.contentSize.height - self.resultScrollView.bounds.size.height)
                    self.resultScrollView.setContentOffset(bottomOffset, animated: false)
                }
            }
        }
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
