//
//  Arm+CoreDataClass.m
//  
//
//  Created by irons on 2020/9/3.
//
//

#import "Arm+CoreDataClass.h"

@implementation Arm

- (ArmCategory)category {
    ArmCategory category = E_Class;
    
    if (self.atk <= 99) {
        category = E_Class;
    } else if (self.atk <= 999) {
        category = D_Class;
    } else if (self.atk <= 9999) {
        category = C_Class;
    } else if (self.atk <= 99999) {
        category = B_Class;
    } else if (self.atk <= 999999) {
        category = A_Class;
    } else {
        category = S_Class;
    }
    return category;
}

@end
