//
//  fnordcreditAccountController.swift
//  RaumZeitLabor
//
//  Created by silsha on 19/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class fnordcreditAccountController : UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers();
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var users = [String]()
    
    func getUsers() {
        var json = JSON(url: "http://cashdesk.rzl:8000/users/all");
        if json.type != "NSError"  {
            var i = 0;
            for (k, user) in json {
                users.insert(user["name"].toString(), atIndex: i);
                i++;
            }
        }else{
            let myAlert = UIAlertView(title: "You are not in RaumZeitLabor",
                message: "fnordcredit works only in the RaumZeitLabor network",
                delegate: nil, cancelButtonTitle: "Cancel")
            myAlert.show()
        }
        users.sort() {$0.0 < $1.0};
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("creditaccounts") as UITableViewCell
        
        cell.textLabel?.text = users[indexPath.row];
        
        
        return cell
    }
    
    var checked = NSIndexPath();

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        let user = users[indexPath.row];
        
        var userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(user, forKey: "fnordcredituser")
        userDefaults.synchronize()
        if(checked.length != 0){
            tableView.cellForRowAtIndexPath(checked)?.accessoryType = .None
        }
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        checked = indexPath;
    }

    
}
