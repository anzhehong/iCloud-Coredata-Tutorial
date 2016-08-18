//
//  CoreDataHelper.swift
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {

    class func insertManagedObject(className: String, managedObjectContext: NSManagedObjectContext) -> AnyObject {
        let managedObject = NSEntityDescription.insertNewObjectForEntityForName(className, inManagedObjectContext: managedObjectContext) as NSManagedObject
        
        return managedObject
    }
    
    class func fetchEntities(className: String, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?) -> NSArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName(className, inManagedObjectContext: managedObjectContext)
        
        fetchRequest.entity = entityDescription
        
        if let pre = predicate {
            fetchRequest.predicate = pre
        }
        
        fetchRequest.returnsObjectsAsFaults = false
        
        var items = []
        do {
            items = try managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            print("fetch error")
        }
        
        return items
    }
}
