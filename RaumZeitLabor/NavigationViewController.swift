//
//  NavigationViewController.swift
//  RaumZeitLabor
//
//  Created by silsha on 28/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewController : UITableViewController {
    @IBOutlet weak var FnordcreditCell: UITableViewCell!
    @IBOutlet weak var LightControlCell: UITableViewCell!
    @IBOutlet weak var FnordcreditLabel: UILabel!
    @IBOutlet weak var LightControlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let json = JSON(url:"http://s.rzl.so/api/full.json")
        if json.type != "NSError"  {
            if let status = json["status"].asString{
                if status == "1" {
                        navigationController?.navigationBar.barTintColor = UIColor(red: 0x4c/255, green: 0xd9/255, blue: 0x64/255, alpha: 1.0)
                }
                if status == "0" {
                    navigationController?.navigationBar.barTintColor = UIColor(red: 0xff/255, green: 0x2a/255, blue: 0x68/255, alpha: 1.0)
                }
                if status == "?" {
                    navigationController?.navigationBar.barTintColor = UIColor(red: 0xff/255, green: 0x95/255, blue: 0x00/255, alpha: 1.0)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        let json = JSON(url:"http://infra.rzl:8083/fhem?cmd=jsonlist&XHR=1")
        if json.type == "NSError"  {
            LightControlLabel.enabled = false;
            FnordcreditLabel.enabled = false;
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == "lightcontrolsegue" || identifier == "fnordcreditsegue") {
            let json = JSON(url:"http://infra.rzl:8083/fhem?cmd=jsonlist&XHR=1")
            if json.type != "NSError"  {
                return true;
            }else{
                if identifier == "lightcontrolsegue" {
                    let myAlert = UIAlertView(title: "You are not in RaumZeitLabor",
                        message: "Light control works only in the RaumZeitLabor network",
                        delegate: nil, cancelButtonTitle: "Cancel")
                        myAlert.show();
                }
                if identifier == "fnordcreditsegue" {
                    let myAlert = UIAlertView(title: "You are not in RaumZeitLabor",
                        message: "fnordcredit works only in the RaumZeitLabor network",
                        delegate: nil, cancelButtonTitle: "Cancel")
                    myAlert.show();
                }
                
                return false;
            }
        }
        
        return true;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false;
    }

}