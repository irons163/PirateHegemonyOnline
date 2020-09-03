//
//  IRTabBarAppearance.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const _Nonnull IRTabTextColor __attribute__((deprecated("Use NSForegroundColorAttributeName instead")));
extern NSString *const _Nonnull IRTabTextFont __attribute__((deprecated("Use NSFontAttributeName instead")));

extern NSString *const _Nonnull IRTabTextOffset;

/**
 The alpha value for the tab title label.
 */
extern NSString *const _Nonnull IRTabTitleAlpha;

/**
 The height of the tab indicator line.
 */
extern NSString *const _Nonnull IRTabIndicatorLineHeight;
/**
 The image to use for the tab indicator.
 */
extern NSString *const _Nonnull IRTabIndicatorImage;
/**
 The tint color to use for the tab indicator image.
 */
extern NSString *const _Nonnull IRTabIndicatorImageTintColor;

/**
 Whether the crossfading alpha effect is enabled for tab transitions.
 */
extern NSString *const _Nonnull IRTabTransitionAlphaEffectEnabled;

NS_ASSUME_NONNULL_END
