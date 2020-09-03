//
//  Arm+CoreDataProperties.m
//  
//
//  Created by irons on 2020/9/3.
//
//

#import "Arm+CoreDataProperties.h"

@implementation Arm (CoreDataProperties)

+ (NSFetchRequest<Arm *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Arm"];
}

@dynamic name;
@dynamic atk;

@end
