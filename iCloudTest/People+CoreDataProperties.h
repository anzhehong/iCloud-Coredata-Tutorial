//
//  People+CoreDataProperties.h
//  iCloudTest
//
//  Created by An, Fowafolo on 16/8/18.
//  Copyright © 2016年 An, Fowafolo. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "People.h"

NS_ASSUME_NONNULL_BEGIN

@interface People (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nullable, nonatomic, retain) NSSet<House *> *house;

@end

@interface People (CoreDataGeneratedAccessors)

- (void)addHouseObject:(House *)value;
- (void)removeHouseObject:(House *)value;
- (void)addHouse:(NSSet<House *> *)values;
- (void)removeHouse:(NSSet<House *> *)values;

@end

NS_ASSUME_NONNULL_END
