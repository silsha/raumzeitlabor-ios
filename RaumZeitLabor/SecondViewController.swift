//
//  DashboardController.swift
//  RaumZeitLabor
//
//  Created by silsha on 17/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class LichtsteuerungController : UITableViewController {
    
    var devices = [Int: [String: String]]()
    
    func refresh(sender:AnyObject)
    {
        getData()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStatus()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        // Dispose of any resources that can be recreated.
    }
    
    func getStatus() {
        var json = getJSON("https://status.raumzeitlabor.de/api/full.json")
        if var status: AnyObject? = parseJSON(json)["details"]?["tuer"] {
            if status! as NSObject == "1" {
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 38/255, green: 166/255, blue: 91/255, alpha: 1);
            }
            if status! as NSObject == "0" {
                self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
            }
            if status! as NSObject == "?" {
                self.navigationController?.navigationBar.barTintColor = UIColor.orangeColor()
            }
        }
    }
    
    func getData() {
        devices = [:]
        let json = JSON(url:"http://infra.rzl:8083/fhem?cmd=jsonlist&XHR=1")
        if json.type != "NSError"  {
            var i = 0;
            for (k, v) in json["Results"] {
                if(v["list"].asString == "PCA301"){
                    for (id, device) in v["devices"] {
                        if(device["NAME"].toString() != "PCA301_07363D"){
                            devices[i] = ["alias": device["ATTR"]["alias"].toString(),
                                "room": device["ATTR"]["room"].toString(),
                                "name": device["NAME"].toString(),
                                "state": device["STATE"].toString()];
                            i++
                        }
                    }
                }
            }
        }else{
            
        }
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("deviceCell") as UITableViewCell
        
        if var device = devices[indexPath.row]? {
            cell.textLabel?.text = device["alias"]
            if device["state"] == "on" {
                cell.accessoryType = .Checkmark
            }else{
                cell.accessoryType = .None
            }
        }
        
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getData();
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false;
        let urlToRequest = "http://infra.rzl:8083/fhem?cmd." + devices[indexPath.row]!["name"]! + "=set%20" + devices[indexPath.row]!["name"]! + "%20toggle"
        if (NSData(contentsOfURL: NSURL(string: urlToRequest)!)? != nil) {
            if devices[indexPath.row]!["state"]! == "on"{
                self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            }else{
                self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            }
        }
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.getData();
        }
    }
    
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }
}
