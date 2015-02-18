//
//  FirstViewController.swift
//  RaumZeitLabor
//
//  Created by silsha on 15/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        getStatus()
        getData()
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
                self.navigationController?.navigationBar.barTintColor = UIColor.greenColor()
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
            mitgliederLabel.text = mitglieder as String;
        }
        
        if var kontostand: AnyObject = parseJSON(getJSON("https://xively.com/feeds/42055/datastreams/Kontostand/graph.json"))["current_value"] as? NSString{
            kontostandLabel.text = kontostand as String + " €";
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

