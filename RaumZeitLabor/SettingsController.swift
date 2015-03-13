//
//  SettingsController.swift
//  RaumZeitLabor
//
//  Created by silsha on 19/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class SettingsController : UITableViewController {
    @IBOutlet weak var fnordcredituser: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let user: AnyObject = userDefaults.valueForKey("fnordcredituser") {
            dispatch_async(dispatch_get_main_queue()) {
                self.fnordcredituser.text = user as? String;
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let user: AnyObject = userDefaults.valueForKey("fnordcredituser") {
            dispatch_async(dispatch_get_main_queue()) {
                self.fnordcredituser.text = user as? String;
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "settingsaccountsegue") {
            let json = JSON(url:"http://infra.rzl:8083/fhem?cmd=jsonlist&XHR=1")
            if json.type != "NSError"  {
                return true;
            }else{
                let myAlert = UIAlertView(title: "No connectivity",
                    message: "fnordcredit can only be used when connected to the RaumZeitLabor WiFi",
                    delegate: nil, cancelButtonTitle: "Cancel")
                myAlert.show();
                
                return false;
            }
        }
        
        return true;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false;
        if ((indexPath.section == 1 && indexPath.row == 0)) {
            let url = NSURL(string: "https://github.com/silsha/raumzeitlabor-ios/issues");
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
        }
        if ((indexPath.section == 1 && indexPath.row == 1)) {
            let url = NSURL(string: "https://fnordserver.eu");
            if UIApplication.sharedApplication().canOpenURL(url!) {
                UIApplication.sharedApplication().openURL(url!)
            }
        }
    }
}
