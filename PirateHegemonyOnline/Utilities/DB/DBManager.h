//
//  DBManager.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arm+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBManager : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)sharedInstance;

- (Arm *)createArmWithName:(NSString *)name WithAtk:(NSInteger)atk;
- (NSArray *)getAllArms;
- (NSInteger)getTotalPower;

@end

NS_ASSUME_NONNULL_END
