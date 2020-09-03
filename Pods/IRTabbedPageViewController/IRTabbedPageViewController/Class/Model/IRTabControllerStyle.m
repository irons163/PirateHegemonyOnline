//
//  IRTabControllerStyle.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRTabControllerStyle.h"

@implementation IRTabControllerStyle

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(IRTabStyle)tabStyle
                  sizingStyle:(IRTabSizingStyle)sizingStyle
                 numberOfTabs:(NSInteger)numberOfTabs {
    return [[self class]styleWithName:name
                             tabStyle:tabStyle
                          sizingStyle:sizingStyle
                      transitionStyle:IRTabTransitionStyleProgressive
                         numberOfTabs:numberOfTabs];
}

+ (instancetype)styleWithName:(NSString *)name
                     tabStyle:(IRTabStyle)tabStyle
                  sizingStyle:(IRTabSizingStyle)sizingStyle
              transitionStyle:(IRTabTransitionStyle)transitionStyle
                 numberOfTabs:(NSInteger)numberOfTabs {
    return [[[self class]alloc]initWithName:name
                                   tabStyle:tabStyle
                                sizingStyle:sizingStyle
                            transitionStyle:transitionStyle
                               numberOfTabs:numberOfTabs];
}

- (instancetype)initWithName:(NSString *)name
                    tabStyle:(IRTabStyle)tabStyle
                 sizingStyle:(IRTabSizingStyle)sizingStyle
             transitionStyle:(IRTabTransitionStyle)transitionStyle
                numberOfTabs:(NSInteger)numberOfTabs {
    
    if (self = [super init]) {
        _name = name;
        _tabStyle = tabStyle;
        _sizingStyle = sizingStyle;
        _numberOfTabs = numberOfTabs;
        _transitionStyle = transitionStyle;
    }
    return self;
}

@end
