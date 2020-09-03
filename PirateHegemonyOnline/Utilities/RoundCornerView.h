//
//  RoundCornerView.h
//  PirateHegemonyOnline
//
//  Created by Phil on 2019/5/21.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface RoundCornerView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@end

NS_ASSUME_NONNULL_END
