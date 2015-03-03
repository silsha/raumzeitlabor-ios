//
//  KassensystemController.swift
//  RaumZeitLabor
//
//  Created by silsha on 17/02/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import Foundation
import UIKit

class KassensystemController : UITableViewController {
    
    var transactions = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCredit();
    }
    
    func getCredit() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let fnordcredituser: AnyObject = userDefaults.valueForKey("fnordcredituser") {
            var user = fnordcredituser as String
            var json = JSON(url: "http://cashdesk.rzl:8000/transactions/" + user);
            if json.type != "NSError" {
                for (key, transaction) in json {
                    self.transactions.append(transaction)
                }
                self.transactions.sort({
                    item1, item2 in
                    return item1["time"].asString > item2["time"].asString
                })
                userDefaults.setValue(self.transactions[0]["credit"].toString(), forKey: "fnordcreditcredit")
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    self.tableView.reloadData()
                }
            }
        }
        }
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return transactions.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath) as UITableViewCell
                (cell.viewWithTag(10) as UILabel).text = "Hej, silsha"
            }
            if indexPath.row == 1 {
                var userDefaults = NSUserDefaults.standardUserDefaults()
                cell = self.tableView.dequeueReusableCellWithIdentifier("balanceCell") as UITableViewCell
                if let credit = userDefaults.valueForKey("fnordcreditcredit") as? String {
                    (cell.viewWithTag(14) as UILabel).text = credit + " €"
                }
            }
            if indexPath.row == 2 {
                cell = self.tableView.dequeueReusableCellWithIdentifier("scanCell") as UITableViewCell
            }else
                if indexPath.row == 3 {
                    cell = self.tableView.dequeueReusableCellWithIdentifier("newTransactionCell") as UITableViewCell
            }
        }
        if indexPath.section == 1 {
            var formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle
            cell = self.tableView.dequeueReusableCellWithIdentifier("transactionCell") as UITableViewCell
            if let timeLabel = cell.viewWithTag(11) as? UILabel {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let date = dateFormatter.dateFromString(transactions[indexPath.row as Int]["time"].toString())
                dateFormatter.dateStyle = .FullStyle
                dateFormatter.timeStyle = .MediumStyle
                timeLabel.text = dateFormatter.stringFromDate(date!)
            }
            if let amountLabel = cell.viewWithTag(12) as? UILabel {
                amountLabel.text = formatter.stringFromNumber(transactions[indexPath.row as Int]["delta"].asNumber!)
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return CGFloat(50)
            }
            if indexPath.row == 1 {
                return CGFloat(150)
            }
            if indexPath.row == 2 {
                return CGFloat(50)
            }
            if indexPath.row == 3 {
                return CGFloat(50)
            }
        }
        return CGFloat(60)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Transactions"
        default:
            return ""
        }
    }
    
    
    
    
}
