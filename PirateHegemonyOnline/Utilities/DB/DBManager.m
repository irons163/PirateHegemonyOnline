//
//  DBManager.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "DBManager.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation DBManager

+ (instancetype)sharedInstance {
    static DBManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self setupCoreDataStack];
    }
    return self;
}

- (void)setupCoreDataStack {
    if ([NSPersistentStoreCoordinator MR_defaultStoreCoordinator] != nil)
    {
        return;
    }
    
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.irons.PirateHegemonyOnline"];
    storeURL = [storeURL URLByAppendingPathComponent:@"PirateHegemonyOnline.sqlite"];
    
    [psc MR_addAutoMigratingSqliteStoreAtURL:storeURL];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:psc];
    [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:psc];
}

- (Arm *)createArmWithName:(NSString *)name WithAtk:(NSInteger)atk {
    Arm *arm = [Arm MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    arm.name = name;
    arm.atk = atk;
    [self save];
    return arm;
}

- (NSArray *)getAllArms {
    NSArray *readFromDB = [Arm MR_findAllSortedBy:@"atk" ascending:NO];
    return readFromDB;
}

- (NSInteger)getTotalPower {
    NSArray *arms = [self getAllArms];
    NSInteger totalPower = 0;
    for (Arm *arm in arms) {
        totalPower += arm.atk;
    }
    return totalPower;
}

- (void)save {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
