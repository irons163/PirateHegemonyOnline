//
//  DrawCardViewController.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArmCategory.h"
#import "Arm+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DrawCardViewControllerDelegate <NSObject>

- (void)didClose;

@end

@interface DrawCardViewController : UIViewController

@property (weak) id<DrawCardViewControllerDelegate> delegate;
@property (nullable) Arm *displayArm;
@property BOOL drawSClassCard;

@end

NS_ASSUME_NONNULL_END
