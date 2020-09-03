//
//  IRPageViewController+Private.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRPageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRPageViewController ()

/**
 The default page index of the page view controller.
 */
@property (nonatomic, assign, readonly) NSInteger defaultPageIndex;

- (void)setUpViewController:(nonnull UIViewController *)viewController
                      index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
