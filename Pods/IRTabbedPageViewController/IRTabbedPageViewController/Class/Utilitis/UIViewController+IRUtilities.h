//
//  UIViewController+IRUtilities.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (IRUtilities)

- (void)IR_addToParentViewController:(UIViewController *)parentViewController;

- (void)IR_addToParentViewController:(UIViewController *)parentViewController atZIndex:(NSInteger)index;

- (void)IR_addToParentViewController:(UIViewController *)parentViewController edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index;

- (void)IR_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view edgeInsets:(UIEdgeInsets)insets;

@end

NS_ASSUME_NONNULL_END
