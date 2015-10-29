//
//  groupConversionVC.swift
//  ChatApp
//
//  Created by TangWeichang on 10/27/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

var groupConversationVC_title = ""

class groupConversionVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet var resultScrollView: UIScrollView!
    
    @IBOutlet var frameMessageView: UIView!
    
    @IBOutlet var lineLabel: UILabel!
    //@IBOutlet var blockBtn: UIBarButtonItem!
    
    @IBOutlet var messageTextView: UITextView!
    
    @IBOutlet var sendButton: UIButton!
    
    var myImg:UIImage? = UIImage()
    
    var resultImageFiles = [PFFile]()
    var resultImageFiles2 = [PFFile]()
    
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    let mlabel = UILabel(frame: CGRectMake(5,10,200,20))
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    
    var messageArray = [String]()
    var senderArray = [String]()
    
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

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        mlabel.text = "Type a message..."
        mlabel.backgroundColor = UIColor.clearColor()
        mlabel.textColor = UIColor.lightGrayColor()
        messageTextView.addSubview(mlabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultScrollView.addGestureRecognizer(tapScrollViewGesture)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.title = groupConversationVC_title
        
        var query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        self.resultImageFiles.removeAll(keepCapacity: false)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in objects! {
                self.resultImageFiles.append(object["photo"] as! PFFile)
                self.resultImageFiles[0].getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                    if error == nil {
                        self.myImg = UIImage(data: imageData!)
                        self.refreshResults()
                    }
                })
            }
        }
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
        
        
        
        var query = PFQuery(className: "GroupMessages")
        query.whereKey("group", equalTo: groupConversationVC_title)
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
                        
                        var query = PFQuery(className: "_User")
                        self.resultImageFiles2.removeAll(keepCapacity: false)
                        query.whereKey("username", equalTo: self.senderArray[i])
                        var objects = query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            for object in objects! {
                                self.resultImageFiles2.append(object["photo"] as! PFFile)
                                self.resultImageFiles2[0].getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                                    if error == nil {
                                        img.image = UIImage(data: imageData!)
                                        
                                    }
                                })
                            }
                        })
                        
                        
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
    
    func didTapScrollView() {
        self.view.endEditing(true)
    }
    
    @IBAction func sendBtn_click(sender: AnyObject) {
        
        if messageTextView.text == "" {
            print("no text")
        } else {
            var groupMessageTable = PFObject(className: "GroupMessages")
            groupMessageTable["group"] = groupConversationVC_title
            groupMessageTable["sender"] = userName
            groupMessageTable["message"] = self.messageTextView.text
            groupMessageTable.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success == true {
                    
                    var senderSet = Set([""])
                    senderSet.removeAll(keepCapacity: false)
                    
                    for var i = 0; i <= self.senderArray.count - 1; i++ {
                        if self.senderArray[i] != userName {
                            senderSet.insert(self.senderArray[i])
                        }
                    }
                    
                    var senderSetArray: NSArray = Array(senderSet)
                    
                    for var i2 = 0; i2 <= senderSetArray.count - 1; i2++ {
                        print(senderSetArray[i2])
                    }
                    
                    print("message sent")
                    
                    self.messageTextView.text == ""
                    self.mlabel.hidden = false
                    self.refreshResults()   
                }
            })
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
