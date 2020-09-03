//
//  UIView+IRAutoLayout.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "UIView+IRAutoLayout.h"

NSInteger const IRViewDefaultZIndex = -1;

@implementation UIView (IRAutoLayout)

- (void)IR_addExpandingSubview:(UIView *)subview {
    [self IR_addExpandingSubview:subview edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)IR_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets {
    [self IR_addExpandingSubview:subview edgeInsets:insets atZIndex:IRViewDefaultZIndex];
}

- (void)IR_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index {
    if([self.subviews containsObject:subview]) {
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (constraint.firstItem == subview || constraint.secondItem == subview) {
                [self removeConstraint:constraint];
            }
        }
    }
    
    [self addView:subview atZIndex:index];
    
    //    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self);
    //    }];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-%f-[subview]-%f-|", insets.top, insets.bottom];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-%f-[subview]-%f-|", insets.left, insets.right];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    
}

- (void)IR_addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height {
    [self addView:subview atZIndex:IRViewDefaultZIndex];
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    
    NSDictionary *metrics = @{@"viewHeight":@(height)};
    NSString *verticalConstraints = [NSString stringWithFormat:@"V:|-[subview(viewHeight)]"];
    NSString *horizontalConstraints = [NSString stringWithFormat:@"H:|-[subview]-|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraints
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraints
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
}

#pragma mark - Utils

- (void)IR_clearSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - Internal

- (void)addView:(UIView *)subview atZIndex:(NSInteger)index {
    if (subview.superview) {
        [subview removeFromSuperview];
    }
    if (index >= 0) {
        [self insertSubview:subview atIndex:index];
    } else {
        [self addSubview:subview];
    }
    subview.translatesAutoresizingMaskIntoConstraints = NO;
}

@end

