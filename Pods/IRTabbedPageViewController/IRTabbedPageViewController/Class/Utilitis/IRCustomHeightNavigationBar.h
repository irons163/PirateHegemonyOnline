//
//  IRCustomHeightNavigationBar.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_EXTENSION_UNAVAILABLE_IOS("IRCustomHeightNavigationBar is unavailable in app extensions.")
@interface IRCustomHeightNavigationBar : UINavigationBar

@property (nonatomic, assign) BOOL offsetTransformRequired;

- (void)baseInit;

- (CGFloat)heightIncreaseValue;

- (BOOL)heightIncreaseRequired;

@end

NS_ASSUME_NONNULL_END
