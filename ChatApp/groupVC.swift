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
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:groupCell = tableView.dequeueReusableCellWithIdentifier("groupCell") as! groupCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! groupCell
    }

}
