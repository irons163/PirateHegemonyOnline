//
//  Arm+CoreDataProperties.h
//  
//
//  Created by irons on 2020/9/3.
//
//

#import "Arm+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Arm (CoreDataProperties)

+ (NSFetchRequest<Arm *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t atk;

@end

NS_ASSUME_NONNULL_END
