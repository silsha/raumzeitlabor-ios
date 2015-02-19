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
    @IBOutlet weak var mitgliederLabel: UILabel!
    @IBOutlet weak var kontostandLabel: UILabel!
    @IBOutlet weak var temperaturLabel: UILabel!
    @IBOutlet var table: UITableView!
    
    func refresh(sender:AnyObject)
    {
        getData()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStatus()
        getData()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        if var mitglieder: AnyObject = parseJSON(getJSON("https://xively.com/feeds/42055/datastreams/Mitglieder/graph.json"))["current_value"] as? NSString{
            mitgliederLabel.text = mitglieder as? String;
        }
        
        if var kontostand: AnyObject = parseJSON(getJSON("https://xively.com/feeds/42055/datastreams/Kontostand/graph.json"))["current_value"] as? NSString{
            kontostandLabel.text = kontostand as String + " €";
        }
        
        if var temperatur: AnyObject = parseJSON(getJSON("https://xively.com/feeds/42055/datastreams/Temperatur_Raum_Tafel/graph.json"))["current_value"] as? NSString{
            temperaturLabel.text = temperatur as String + "°C";
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
