//
//  ArmUtility.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/4.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "ArmUtility.h"
#import "UIColor+Helper.h"

@implementation ArmUtility

+ (UIColor *)getArmCategoryColorFromArm:(Arm *)arm {
    UIColor *color = nil;
    switch (arm.category) {
        case S_Class:
            color = [UIColor redColor];
            break;
        case A_Class:
            color = [UIColor colorWithColorCodeString:@"e5cc80"];
            break;
        case B_Class:
            color = [UIColor colorWithColorCodeString:@"c600ff"];
            break;
        case C_Class:
            color = [UIColor colorWithColorCodeString:@"0081ff"];
            break;
        case D_Class:
            color = [UIColor colorWithColorCodeString:@"1eff00"];
            break;
        case E_Class:
            color = [UIColor colorWithColorCodeString:@"ffffff"];
            break;
    }
    
    return color;
}

@end
