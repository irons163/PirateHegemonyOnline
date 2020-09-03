//
//  Arm+CoreDataClass.h
//  
//
//  Created by irons on 2020/9/3.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ArmCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface Arm : NSManagedObject

- (ArmCategory)category;

@end

NS_ASSUME_NONNULL_END

#import "Arm+CoreDataProperties.h"
