//
//  IRTabbedPageViewController.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRPageViewController.h"
#import "IRTabNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@class IRTabbedPageViewControllerImp;

@protocol IRTabbedPageViewControllerDelegate <NSObject>
@optional
- (void)IR_tabbedController:(IRTabbedPageViewControllerImp *_Nullable)tabbedPageViewController didSelectIndex:(NSInteger)index;
@end

@interface IRTabbedPageViewControllerImp : IRPageViewController <IRTabBarViewDataSource, IRTabBarViewDelegate>

/**
 The tab bar view.
 */
@property (nonatomic, weak, nullable) IBOutlet IRTabBarView *tabBarView;
@property (weak, nullable) IBOutlet id<IRTabbedPageViewControllerDelegate> tabbedDelegate;
@end


NS_ASSUME_NONNULL_END
