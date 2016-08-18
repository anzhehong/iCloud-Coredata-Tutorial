//
//  HouseTableViewController.swift
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

import UIKit
import CoreData

class HouseTableViewController: UITableViewController {
    
    var moc: NSManagedObjectContext!
    var selectedPeople: People!
    var houseArray = [House]()
    var newHosue: House? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop,
                                                                target: self, action: #selector(HouseTableViewController.dismissVC))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add,
                                                                 target: self, action: #selector(HouseTableViewController.addHouse))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        newHosue = nil
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PeopleTableViewController.persistentStoreDidChanged),
                                                         name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PeopleTableViewController.persistentStoreWillChange(_:)),
                                                         name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PeopleTableViewController.receiveICloudChanges(_:)),
                                                         name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc)
        loadData()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: moc)
        NSNotificationCenter.defaultCenter().removeObserver(self,
                                                            name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: moc)
    }
    
    func persistentStoreDidChanged() {
        print("persistentStoreDidChanged")
        
        // reenable UI and fetch data
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.title = "iCloud ready"
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        loadData()
    }
    
    func persistentStoreWillChange(notification: NSNotification) {
        print("persistentStoreWillChange")
        
        // disable UI
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.title = "Changes in progess"
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
        moc.performBlock {
            if self.moc.hasChanges {
                do {
                    try self.moc.save()
                    // drop any managed object references
                    self.moc.reset()
                } catch {
                    //TODO : How to catch the error type
                    print("Save error: ")
                }
            }
        }
    }
    
    func receiveICloudChanges(notification: NSNotification) {
        print("Receive iCloud Changes")
        moc.performBlock {
            self.moc.mergeChangesFromContextDidSaveNotification(notification)
            self.loadData()
        }
    }
    
    func loadData() {
        houseArray = [House]()
        
        let unsortedHouses = NSMutableArray()
        
        if let houses = selectedPeople.house {
            for house in houses {
                unsortedHouses.addObject(house)
            }
        }
        
        let sortDescriptor = NSSortDescriptor(key: "cratedDate", ascending: true)
        houseArray = unsortedHouses.sortedArrayUsingDescriptors([sortDescriptor]) as! [House]
        
        self.tableView.reloadData()
    }
    
    func dismissVC() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addHouse() {
        let house = CoreDataHelper.insertManagedObject(NSStringFromClass(House), managedObjectContext: moc) as! House
        house.cratedDate = NSDate()
        selectedPeople.addHouseObject(house)
        
        newHosue = house
        
        do {
            try moc.save()
            print("Save success")
        } catch {
            print("save error")
        }
        
        self.performSegueWithIdentifier("ShowDetail", sender: self)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return houseArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HouseCell", forIndexPath: indexPath)

        cell.textLabel?.text = houseArray[indexPath.row].address

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let vc = segue.destinationViewController as! HouseContentViewController
            
            if let segueHouse = newHosue {
                vc.selectedHouse = segueHouse
            } else {
                if let index = self.tableView.indexPathForSelectedRow {
                    vc.selectedHouse = houseArray[index.row]
                }
            }
            
        }
    }

}
