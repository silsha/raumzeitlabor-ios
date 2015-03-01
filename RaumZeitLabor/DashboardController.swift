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
        self.getData();
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if var mitglieder: AnyObject = self.parseJSON(self.getJSON("https://xively.com/feeds/42055/datastreams/Mitglieder/graph.json"))["current_value"] as? NSString{
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.mitgliederLabel.text = mitglieder as? String;
                }
                
            }
            
            if var kontostand: AnyObject = self.parseJSON(self.getJSON("https://xively.com/feeds/42055/datastreams/Kontostand/graph.json"))["current_value"] as? NSString{
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.kontostandLabel.text = kontostand as String + " €";
                }
            }
            
            if var temperatur: AnyObject = self.parseJSON(self.getJSON("https://xively.com/feeds/42055/datastreams/Temperatur_Raum_Tafel/graph.json"))["current_value"] as? NSString{
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.temperaturLabel.text = temperatur as String + "°C";
                }
            }
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
