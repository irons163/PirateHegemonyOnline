//
//  IRSingleButtonGroup.h
//  IRSingleButtonGroup
//
//  Created by Phil on 2019/7/23.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IRSingleButtonGroupDelegate <NSObject>

- (void)didSelectedButton:(UIButton*)button;
- (void)didDeselectedButton:(UIButton*)button;

@end

@interface IRSingleButtonGroup : NSObject

@property (nonatomic) NSArray* buttons;
@property BOOL canSelectWhenSelected; // default = NO
@property BOOL canMultiSelected; // default = NO
@property (weak) id<IRSingleButtonGroupDelegate> delegate;

- (void)selected:(UIButton*)selectedButton;
- (void)deselected:(UIButton*)selectedButton;
- (void)setInitSelected:(UIButton*)selectedButton;
@end

NS_ASSUME_NONNULL_END
