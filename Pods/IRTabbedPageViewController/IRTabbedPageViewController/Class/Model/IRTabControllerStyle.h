//
//  IRTabControllerStyle.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRTabControllerStyle : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) IRTabStyle tabStyle;
@property (nonatomic, assign) IRTabSizingStyle sizingStyle;
@property (nonatomic, assign) IRTabTransitionStyle transitionStyle;
@property (nonatomic, assign) NSInteger numberOfTabs;

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(IRTabStyle)tabStyle
                  sizingStyle:(IRTabSizingStyle)sizingStyle
                 numberOfTabs:(NSInteger)numberOfTabs;

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(IRTabStyle)tabStyle
                  sizingStyle:(IRTabSizingStyle)sizingStyle
              transitionStyle:(IRTabTransitionStyle)transitionStyle
                 numberOfTabs:(NSInteger)numberOfTabs;

@end

NS_ASSUME_NONNULL_END
