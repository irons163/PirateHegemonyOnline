//
//  IRTabBarCollectionViewCell+Private.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRTabStyle.h"
#import "IRTabBarCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRTabBarCollectionViewCell ()

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic) UIOffset textOffset;
@property (nonatomic, strong) UIColor *tabBackgroundColor;

@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIFont *selectedTextFont;
@property (nonatomic, strong) UIColor *selectedTabBackgroundColor;

@property (nonatomic, assign) CGFloat selectionProgress;

@property (nonatomic, assign) BOOL alphaEffectEnabled;

- (void)setTabStyle:(IRTabStyle)tabStyle;

- (void)setContentBottomMargin:(CGFloat)contentBottomMargin;

@end

NS_ASSUME_NONNULL_END
