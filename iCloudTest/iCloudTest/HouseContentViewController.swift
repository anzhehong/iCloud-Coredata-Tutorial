//
//  HouseContentViewController.swift
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

import UIKit
import CoreData

class HouseContentViewController: UIViewController {
    
    var selectedHouse: House!
    var titleTextField: UITextField!
    
    var moc: NSManagedObjectContext!
    
    @IBOutlet weak var contentText: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        titleTextField = UITextField(frame: CGRectMake(0, 0, 200, 22))
        titleTextField.font = UIFont.boldSystemFontOfSize(20)
        titleTextField.textAlignment = .Center
        
        self.navigationItem.titleView = titleTextField
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(HouseContentViewController.dissMissVC))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(HouseContentViewController.saveHouse))
        
        if let content = selectedHouse.address {
            titleTextField.text = content
        }else {
            titleTextField.text = "INSERT Title Here"
        }
        
        if let date = selectedHouse.cratedDate {
            contentText.text = "\(date)"
        } else {
            contentText.text = ""
        }
    }


    func dissMissVC() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveHouse() {
        selectedHouse.address = titleTextField.text
        selectedHouse.cratedDate = NSDate()
        
        do {
            try moc.save()
            print("SACE DETAIL SUCCESS")
        } catch {
            print("SACE ERROR")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
