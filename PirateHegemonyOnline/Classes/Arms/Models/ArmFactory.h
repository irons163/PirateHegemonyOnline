//
//  ArmFactory.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arm+CoreDataClass.h"
#import "ArmCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArmFactory : NSObject

+ (Arm *)createNewMusketeer;
+ (Arm *)createNewMusketeerWithSpecificCategory:(ArmCategory)category;

@end

NS_ASSUME_NONNULL_END
