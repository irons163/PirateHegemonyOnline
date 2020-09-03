//
//  UIViewController+IRUtilities.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "UIViewController+IRUtilities.h"
#import "UIView+IRAutoLayout.h"

@implementation UIViewController (IRUtilities)

- (void)IR_addToParentViewController:(UIViewController *)parentViewController {
    [self IR_addToParentViewController:parentViewController atZIndex:IRViewDefaultZIndex];
}

- (void)IR_addToParentViewController:(UIViewController *)parentViewController atZIndex:(NSInteger)index {
    [self IR_addToParentViewController:parentViewController withView:parentViewController.view edgeInsets:UIEdgeInsetsZero atZIndex:index];
}

- (void)IR_addToParentViewController:(UIViewController *)parentViewController edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index {
    [self IR_addToParentViewController:parentViewController withView:parentViewController.view edgeInsets:insets atZIndex:index];
}

- (void)IR_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view edgeInsets:(UIEdgeInsets)insets {
    [self IR_addToParentViewController:parentViewController withView:view edgeInsets:insets atZIndex:IRViewDefaultZIndex];
}

- (void)IR_addToParentViewController:(UIViewController *)parentViewController withView:(UIView *)view edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index {
    if (self.parentViewController) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    
    [parentViewController addChildViewController:self];
    [view IR_addExpandingSubview:self.view edgeInsets:insets atZIndex:index];
    [self didMoveToParentViewController:parentViewController];
}

@end

