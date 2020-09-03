//
//  IRTabNavigationBar.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCustomHeightNavigationBar.h"
#import "IRTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

NS_EXTENSION_UNAVAILABLE_IOS("IRTabNavigationBar is unavailable in app extensions.")
@interface IRTabNavigationBar : IRCustomHeightNavigationBar

/**
 The tab bar view in the navigation bar.
 */
@property (nonatomic, strong, readonly) IRTabBarView *tabBarView;

/**
 The height for the tab bar in the navigation bar.
 
 Default: 44px.
 */
@property (nonatomic, assign) IBInspectable CGFloat tabBarHeight;
/**
 The padding to use between the bottom of the tab bar and navigation bar.
 
 Default: 4px.
 */
@property (nonatomic, assign) IBInspectable CGFloat tabBarBottomPadding;

@end


NS_ASSUME_NONNULL_END
