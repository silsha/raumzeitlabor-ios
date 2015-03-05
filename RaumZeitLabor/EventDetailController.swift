//
//  EventDetailController.swift
//  RaumZeitLabor
//
//  Created by silsha on 05/03/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}