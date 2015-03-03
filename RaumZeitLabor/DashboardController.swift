//
//  DashboardController.swift
//  RaumZeitLabor
//
//  Created by silsha on 17/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class DashboardController : UITableViewController {
    
    func refresh(sender:AnyObject)
    {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    var presentMembers : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var json = JSON(url:"http://s.rzl.so/api/full.json")
            if json.type != "NSError" {
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    for v in json["details"]["laboranten"] {
                        self.presentMembers.append(v.1.toString())
                    }
                    self.tableView.reloadData();
                    return
                }
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    override func tableView(tableView: UITableView?, titleForHeaderInSection section: Int) -> String {
        switch section {
        case 0:
            return "Status";
        case 1:
            return "Present Members";
        default:
            return "";
        }
        
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3;
        case 1:
            return presentMembers.count;
        default:
            return 0;
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell = UITableViewCell();
        if (section == 0 && row == 0){
            cell = tableView.dequeueReusableCellWithIdentifier("membersCell", forIndexPath: indexPath) as UITableViewCell
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var json = JSON(url:"https://xively.com/feeds/42055/datastreams/Mitglieder/graph.json")
                if json.type != "NSError" {
                    NSOperationQueue.mainQueue().addOperationWithBlock(){
                        cell.textLabel?.text = json["current_value"].toString();
                        return
                    }
                }
            }
        }
        else if (section == 0 && row == 1){
            cell = tableView.dequeueReusableCellWithIdentifier("accountCell", forIndexPath: indexPath) as UITableViewCell
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var json = JSON(url:"https://xively.com/feeds/42055/datastreams/Kontostand/graph.json")
                if json.type != "NSError" {
                    NSOperationQueue.mainQueue().addOperationWithBlock(){
                        cell.textLabel?.text = json["current_value"].toString() + " €";
                        return
                    }
                }
            }
        }
        else if (section == 0 && row == 2){
            cell = tableView.dequeueReusableCellWithIdentifier("temperatureCell", forIndexPath: indexPath) as UITableViewCell
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var json = JSON(url:"https://xively.com/feeds/42055/datastreams/Temperatur_Raum_Tafel/graph.json")
                if json.type != "NSError" {
                    NSOperationQueue.mainQueue().addOperationWithBlock(){
                        cell.textLabel?.text = json["current_value"].toString() + "°C";
                        return
                    }
                }
            }
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = presentMembers[indexPath.row];
        }
        return cell
    }
    
    
}