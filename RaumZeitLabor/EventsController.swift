//
//  EventsController.swift
//  RaumZeitLabor
//
//  Created by silsha on 02/03/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class EventsController : UITableViewController {
    var events = Array<Dictionary<String, String>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        getEvents()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row as Int
        var cell = UITableViewCell();
        cell = tableView.dequeueReusableCellWithIdentifier("eventsCell", forIndexPath: indexPath) as UITableViewCell
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var date = dateFormatter.dateFromString(events[row]["start"]!)
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .FullStyle
        
        (cell.viewWithTag(4) as UILabel).text = dateFormatter.stringFromDate(date!)
        (cell.viewWithTag(2) as UILabel).text = events[row]["title"]?
        (cell.viewWithTag(3) as UILabel).text = events[row]["description"]?
        
        return cell
    }
    
    
    func getEvents(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let date = NSDate()
            let startdate = String(Int64(date.timeIntervalSince1970))
            let enddate = String(Int64(date.timeIntervalSince1970 + 604800*5))
            let json = JSON(url:"https://raumzeitlabor.de/events/ical?accept=jcal&expand=true&start=" + startdate + "&end=" + enddate)
            if json.type != "NSError"  {
                for (key, fields) in json[2] {
                    var thisevent = Dictionary<String, String>()
                    for (key, event) in fields[1] {
                        switch event[0].asString! {
                        case "dtstart":
                            thisevent["start"] = event[3].asString!
                        case "dtend":
                            thisevent["end"] = event[3].asString!
                        case "location":
                            thisevent["location"] = event[3].asString!
                        case "description":
                            thisevent["description"] = event[3].asString!
                        case "summary":
                            thisevent["title"] = event[3].asString!
                        default:
                            continue
                        }
                    }
                    self.events.append(thisevent)
                }
                self.events.sort() {$0["start"] < $1["start"]};
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "eventDetailSegue") {
            let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let detailsVC = segue.destinationViewController as EventDetailController
            detailsVC.eventTitle = events[indexPath.row]["title"]!
            detailsVC.eventDate = events[indexPath.row]["start"]!
            detailsVC.eventDesc = events[indexPath.row]["description"]!
        }
    }
}
