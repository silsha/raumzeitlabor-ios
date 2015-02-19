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
            fnordcredituser.text = user as? String;
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
            fnordcredituser.text = user as? String;
        }
    }
}
