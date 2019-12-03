//
//  EventDetailController.swift
//  RaumZeitLabor
//
//  Created by silsha on 05/03/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class EventDetailController : UITableViewController {
    
    @IBOutlet weak var nameCell: UITableViewCell!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    var eventTitle = String()
    var eventDate = String()
    var eventDesc = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        var date = dateFormatter.dateFromString(eventDate)
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .ShortStyle
        
        nameCell.textLabel?.text = eventTitle
        dateCell.textLabel?.text = dateFormatter.stringFromDate(date!)
        descriptionCell.textLabel?.text = eventDesc
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 3){
            let eventStore = EKEventStore()
            eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
                granted, error in
                if granted {
                    var event:EKEvent = EKEvent(eventStore: eventStore)
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    var date = dateFormatter.dateFromString(self.eventDate)
                    
                    event.title = self.eventTitle
                    event.startDate = date
                    event.endDate = date?.dateByAddingTimeInterval(7200)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    event.notes = self.eventDesc
                    eventStore.saveEvent(event, span: EKSpanThisEvent, error: nil)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.cellForRowAtIndexPath(indexPath)?.selected = false;
                        let myAlert = UIAlertView(title: "Saved event",
                            message: "The event has been added to your calendar",
                            delegate: nil, cancelButtonTitle: "Thanks!")
                        myAlert.show();
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
