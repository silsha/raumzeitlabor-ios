//
//  KassensystemController.swift
//  RaumZeitLabor
//
//  Created by silsha on 17/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class KassensystemController : UITableViewController {
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCredit();
    }
    
    func getCredit() {
        var json = JSON(url: "http://cashdesk.rzl:8000/users/all");
        if json.type != "NSError"  {
            
            var userDefaults = NSUserDefaults.standardUserDefaults()
            if let fnordcredituser: AnyObject = userDefaults.valueForKey("fnordcredituser") {
            
                for (k, user) in json {
                    if user["name"].toString() == fnordcredituser as String {
                        creditLabel.text = user["credit"].toString() + " €";
                        usernameLabel.text = "Hej, " + user["name"].toString();
                    }
                }
            }else{
                let myAlert = UIAlertView(title: "Please choose your user account",
                    message: "Please choose your user account in settings",
                    delegate: nil, cancelButtonTitle: "Okay")
                myAlert.show()
                self.tabBarController?.selectedIndex = 4;
            }
        }else{
            let myAlert = UIAlertView(title: "You are not in RaumZeitLabor",
                message: "Fnordcredit works only in the RaumZeitLabor network",
                delegate: nil, cancelButtonTitle: "Cancel")
            myAlert.show()
            self.tabBarController?.selectedIndex = 0;
        }
    }

    
}
