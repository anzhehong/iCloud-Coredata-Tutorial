//
//  PeopleTableViewController.swift
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController {

    var moc: NSManagedObjectContext!
    var peopleArray = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Waiting for icloud"
        self.navigationItem.rightBarButtonItem?.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
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
    
    @IBAction func addPeople(sender: UIBarButtonItem) {
        let addPeopleAlert = UIAlertController(title: "New People", message: "Enter name for this person", preferredStyle: .Alert)
        addPeopleAlert.addTextFieldWithConfigurationHandler(nil)
        addPeopleAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action) in
            if let textField = addPeopleAlert.textFields?.last {
                if let text = textField.text {
                    let people = CoreDataHelper.insertManagedObject(NSStringFromClass(People), managedObjectContext: self.moc) as! People
                    people.name = text
                    people.createdDate = NSDate()
//                    try! self.moc.save()
                    do {
                        try self.moc.save()
                        print("New People save Success")
                    } catch {
                        print("New People save Error")
                    }
                    self.loadData()
                }
            }
            
        }))
        
        addPeopleAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(addPeopleAlert, animated: true, completion: nil)
    }
    
    func loadData() {
        peopleArray = [People]()
        peopleArray = CoreDataHelper.fetchEntities(NSStringFromClass(People), managedObjectContext: self.moc, predicate: nil) as! [People]
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationItem.title = "iCloud ready"
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peopleArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PeopleCell")! as UITableViewCell
        cell.textLabel?.text = peopleArray[indexPath.row].name
        return cell
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowHouse" {
            let houseVC = segue.destinationViewController as! HouseTableViewController
            if let index = self.tableView.indexPathForSelectedRow {
                houseVC.selectedPeople = peopleArray[index.row]
            }
        }
    }
    
}
