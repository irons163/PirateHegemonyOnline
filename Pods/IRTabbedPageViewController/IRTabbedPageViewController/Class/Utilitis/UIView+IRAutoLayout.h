//
//  UIView+IRAutoLayout.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const IRViewDefaultZIndex;

@interface UIView (IRAutoLayout)

- (void)IR_addExpandingSubview:(UIView *)subview;

- (void)IR_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets;

- (void)IR_addExpandingSubview:(UIView *)subview edgeInsets:(UIEdgeInsets)insets atZIndex:(NSInteger)index;

- (void)IR_addPinnedToTopAndSidesSubview:(UIView *)subview withHeight:(CGFloat)height;

- (void)IR_clearSubviews;

@end

NS_ASSUME_NONNULL_END
