//
//  ArmUtility.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/4.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Arm+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArmUtility : NSObject

+ (UIColor *)getArmCategoryColorFromArm:(Arm *)arm;

@end

NS_ASSUME_NONNULL_END
