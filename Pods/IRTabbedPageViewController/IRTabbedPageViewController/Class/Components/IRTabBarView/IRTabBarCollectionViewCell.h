//
//  IRTabBarCollectionViewCell.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRTabStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRTabBarCollectionViewCell : UICollectionViewCell

/**
 The style of the tab.
 */
@property (nonatomic, assign, readonly) IRTabStyle tabStyle;
/**
 The image displayed in the tab cell.
 
 NOTE - only visible when using IRTabStyleImage.
 */
@property (nonatomic, strong, nullable) UIImage *image;
/**
 The text displayed in the tab cell.
 
 NOTE - only visible when using IRTabStyleText.
 */
@property (nonatomic, copy, nullable) NSString *title;

@property (nonatomic, strong, nullable) UIView* customView;

@end


NS_ASSUME_NONNULL_END
