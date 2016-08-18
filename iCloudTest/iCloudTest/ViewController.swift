//
//  ViewController.swift
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let lKey = "LabelKey"
    let NOTFOUND = "NOTFOUND"
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    let notification = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        notification.addObserver(self,
                                 selector: #selector(ViewController.updateKeyValuePairs(_:)), name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification,
                                 object: icloudStore)
        
        icloudStore.synchronize()
        load()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button1Clicked(sender: UIButton) {
        save()
        load()
    }
    
    let userdefault = NSUserDefaults.standardUserDefaults()
    let icloudStore = NSUbiquitousKeyValueStore.defaultStore()
    
    func save() {
        userdefault.setObject(textField.text, forKey: lKey)
        icloudStore.setObject(textField.text, forKey: lKey)
        icloudStore.synchronize()
        print("icloud saved")
    }
    
    func load() {
        if let value = userdefault.objectForKey(lKey) as? String{
            label.text = value
        } else {
            // donothing
            label.text = NOTFOUND
        }
    }

    func updateKeyValuePairs(notification: NSNotification) {
        print("updateKeyValuePairs")
        let userInfo = notification.userInfo
        let changeReason: AnyObject? = userInfo?["NSUbiquitousKeyValueStoreChangeReasonKey"]
        var reason = -1
        
        if (changeReason == nil) {
            return
        } else {
            reason = changeReason as! Int
            print("reason is: \(reason)")
        }
        
        if (reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange) {
            let changeKeys = userInfo?["NSUbiquitousKeyValueStoreChangedKeysKey"] as! NSArray
            
            for key in changeKeys {
                if key.isEqualToString(lKey) {
                    // Update Data Source
                    let trackedData = icloudStore.objectForKey(lKey)
                    print("track volume from store: \(trackedData)")
                    userdefault.setObject(trackedData, forKey: lKey)
                    load()
                }
            }
        }
    }
    
}

