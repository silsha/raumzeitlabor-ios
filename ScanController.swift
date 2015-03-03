//
//  ScanController.swift
//  RaumZeitLabor
//
//  Created by silsha on 01/03/15.
//  Copyright (c) 2015 fnordcordia. All rights reserved.
//

import UIKit
import RSBarcodes
import AVFoundation

class ScanController: RSCodeReaderViewController {
    
    @IBAction func LightButton(sender: AnyObject) {
        toggleFlash()
    }
    var i = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        let types = NSMutableArray(array: ["org.gs1.EAN-13", "org.gs1.EAN-8"])
        types.removeObject(AVMetadataObjectTypeQRCode)
        self.output.metadataObjectTypes = NSArray(array: types)
        
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            println(point)
        }
        
        self.barcodesHandler = { barcodes in
            var bought: Bool = false
            for barcode in barcodes {
                if(self.i == 0){
                    self.i++
                    let jsonurl = "https://gist.githubusercontent.com/silsha/6c2a80b0cc36466b667a/raw/rzl-preisliste"
                    let json = JSON(url: jsonurl);
                    if json.type != "NSError"  {
                        for (k,v) in json {
                            if k as NSString == barcode.stringValue {
                                self.buyItem(v["price"].asString!)
                                bought = true
                            }
                        }
                        if bought == false {
                            let myAlert = UIAlertView(title: "Product not found",
                                message: "Please mail EAN-Code to hallo@silsha.me",
                                delegate: nil, cancelButtonTitle: "Cancel")
                            dispatch_async(dispatch_get_main_queue()) {
                                myAlert.show();
                                self.navigationController?.popViewControllerAnimated(true)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.i = 0;
    }
    
    func buyItem(price: String)
    {
        var userDefaults = NSUserDefaults.standardUserDefaults()
        if let fnordcredituser: AnyObject = userDefaults.valueForKey("fnordcredituser") {
            var request = NSMutableURLRequest(URL: NSURL(string: "http://cashdesk.rzl:8000/user/credit")!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            let delta = "-" + price
            var params = ["username":fnordcredituser as String, "delta":delta] as Dictionary<String, String>
            
            var err: NSError?
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                println("Response: \(response)")
                var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Body: \(strData)")
                var err: NSError?
                var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                
                // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                if(err != nil) {
                    println(err!.localizedDescription)
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: '\(jsonStr)'")
                }
                else {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        var success = parseJSON["success"] as? Int
                        println("Succes: \(success)")
                        dispatch_async(dispatch_get_main_queue()) {
                            self.navigationController?.popViewControllerAnimated(true)
                            return
                        }
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: \(jsonStr)")
                    }
                }
            })
            
            task.resume()
            
        }
    }
    
    func toggleFlash() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            device.lockForConfiguration(nil)
            if (device.torchMode == AVCaptureTorchMode.On) {
                device.torchMode = AVCaptureTorchMode.Off
            } else {
                device.setTorchModeOnWithLevel(1.0, error: nil)
            }
            device.unlockForConfiguration()
        }
    }
}
