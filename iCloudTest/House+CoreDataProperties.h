//
//  House+CoreDataProperties.h
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "House.h"

NS_ASSUME_NONNULL_BEGIN

@interface House (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSDate *cratedDate;
@property (nullable, nonatomic, retain) People *people;

@end

NS_ASSUME_NONNULL_END
