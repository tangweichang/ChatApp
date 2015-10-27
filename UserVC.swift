//
//  UserVC.swift
//  ChatApp
//
//  Created by TangWeichang on 10/4/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit
var userName = ""
class UserVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBOutlet var resultTbl: UITableView!
    
    
    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultTbl.frame = CGRectMake(0, 0, theWidth, theHeight - 64)
        
        let messageBarBtn = UIBarButtonItem(title: "Messages", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("messageBtn_clicked"))
        
        let groupBartn = UIBarButtonItem(title: "Group", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("groupBtn_click"))
        var buttonArray = NSArray(objects: messageBarBtn,groupBartn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
        
        userName = PFUser.currentUser()!.username!
        
        
    }
    
    func messageBtn_clicked() {
        print("messages")
        self.performSegueWithIdentifier("goToMessagesVCFromUsersVC", sender: self)
    }
    
    func groupBtn_click() {
        print("group")
        self.performSegueWithIdentifier("goToGroupVCFromUserVC", sender: self)
    }

    
    override func viewDidAppear(animated: Bool) {
        let predicate = NSPredicate(format: "username != '" + userName+"'")
        var query = PFQuery(className: "_User", predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let objects = objects {
                for object in objects as! [PFUser] {
                    //self.usernames.append(result.username!)
                    self.resultsUsernameArray.append(object.username!)
                    self.resultsProfileNameArray.append(object["profileName"] as! String)
                    self.resultsImageFiles.append(object["photo"] as! PFFile)
                }
                self.resultTbl.reloadData()
            }
        }
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! resultCell
        otherName = cell.usernameLabel.text!
        otherProfileName = cell.profilenameLable.text!
        self.performSegueWithIdentifier("goToConversation", sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: resultCell = tableView.dequeueReusableCellWithIdentifier("cell") as! resultCell
        
        cell.usernameLabel.text = self.resultsUsernameArray[indexPath.row]
        print(resultsProfileNameArray[indexPath.row])
        cell.profilenameLable.text = self.resultsProfileNameArray[indexPath.row]
        resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.profileImage.image = image
            }
        }
        
        return cell
        
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
