//
//  IRTabNavigationBar+Private.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRTabNavigationBar.h"

@class IRTabbedPageViewController;

NS_ASSUME_NONNULL_BEGIN

@interface IRTabNavigationBar ()

@property (nonatomic, assign) BOOL tabBarRequired;

- (void)tabbedPageViewController:(IRTabbedPageViewController *)tabbedPageViewController
                  viewWillAppear:(BOOL)animated
                       isInitial:(BOOL)isInitial;

- (void)tabbedPageViewController:(IRTabbedPageViewController *)tabbedPageViewController
               viewWillDisappear:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
