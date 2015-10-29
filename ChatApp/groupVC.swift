//
//  groupVC.swift
//  ChatApp
//
//  Created by TangWeichang on 10/26/15.
//  Copyright © 2015 TangWeichang. All rights reserved.
//

import UIKit

class groupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var resultsTable: UITableView!
    
    var resultsNameArray = Set([""])
    var resultsNameArray2 = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var theWidth = view.frame.size.width
        var theHeight = view.frame.size.height
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight - 64)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        groupConversationVC_title = ""
        
        self.resultsNameArray.removeAll(keepCapacity: false)
        self.resultsNameArray2.removeAll(keepCapacity: false)
        
        var query = PFQuery(className: "GroupMessages")
        query.addAscendingOrder("group")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for object in objects! {
                    self.resultsNameArray.insert(object.objectForKey("group") as! String)
                    self.resultsNameArray2 = Array(self.resultsNameArray)
                    self.resultsTable.reloadData()
                }
            }
        }
    }

    @IBAction func addGroup_clicked(sender: AnyObject) {
        
        var alert = UIAlertController(title: "New Group", message: "Type the name of the group", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            
        }
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            print("ok pressed")
            let textF = alert.textFields![0] as! UITextField
            
            var groupMessageObj = PFObject(className: "GroupMessages")
            let theUser:String = PFUser.currentUser()!.username!
            groupMessageObj["sender"] = theUser
            groupMessageObj["message"] = "\(theUser) created a new Group"
            groupMessageObj["group"] = textF.text
            
            groupMessageObj.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    print("groupMessageObj saved successfully")
                }
            })
            print("group created")
            groupConversationVC_title = textF.text!
            
            self.performSegueWithIdentifier("goToGroupConversionVCFromGroupVC", sender: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsNameArray2.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:groupCell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! groupCell
        cell.groupNameLbl.text = resultsNameArray2[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! groupCell
        
        groupConversationVC_title = resultsNameArray2[indexPath.row]
        self.performSegueWithIdentifier("goToGroupConversionVCFromGroupVC", sender: self)
    }

}
