//
//  ArmFactory.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "ArmFactory.h"
#import "DBManager.h"

@implementation ArmFactory

+ (Arm *)createNewMusketeer {
    ArmCategory category = [ArmFactory getRandomCategory];
    return [ArmFactory createNewMusketeerWithSpecificCategory:category];
}

+ (Arm *)createNewMusketeerWithSpecificCategory:(ArmCategory)category {
    NSInteger atk = [ArmFactory getRandomATKWithSpecificCategory:category];
    Arm *arm = [[DBManager sharedInstance] createArmWithName:@"Musketeer" WithAtk:atk];
    return arm;
}

+ (ArmCategory)getRandomCategory {
    ArmCategory category = E_Class;
    NSInteger random = arc4random_uniform(10000000);
    if (random < 99) {
        category = S_Class;
    } else if (random < 999) {
        category = A_Class;
    } else if (random < 9999) {
        category = B_Class;
    } else if (random < 99999) {
        category = C_Class;
    } else if (random < 999999) {
        category = D_Class;
    } else {
        category = E_Class;
    }
    return category;
}

+ (NSInteger)getRandomATKWithSpecificCategory:(ArmCategory)category {
    NSInteger atk = 0;
    uint32_t minBound = 0;
    uint32_t maxBound = 0;
    switch (category) {
        case S_Class:
            minBound = 999999;
            maxBound = 9999999;
            break;
        case A_Class:
            minBound = 99999;
            maxBound = 999999;
            break;
        case B_Class:
            minBound = 9999;
            maxBound = 99999;
            break;
        case C_Class:
            minBound = 999;
            maxBound = 9999;
            break;
        case D_Class:
            minBound = 99;
            maxBound = 999;
            break;
        case E_Class:
            minBound = 1;
            maxBound = 99;
            break;
    }
    
    atk = arc4random_uniform(1 + maxBound - minBound) + minBound;
    return atk;
}

@end
