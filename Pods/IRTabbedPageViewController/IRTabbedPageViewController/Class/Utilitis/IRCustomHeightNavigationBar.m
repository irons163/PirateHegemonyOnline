//
//  IRCustomHeightNavigationBar.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRCustomHeightNavigationBar.h"

CGFloat const IRStandardBarHeightInvalid = -1.0f;

#define IR_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface IRCustomHeightNavigationBar ()

@property (nonatomic, assign) CGFloat standardBarHeight;

@end

@implementation IRCustomHeightNavigationBar

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.standardBarHeight = IRStandardBarHeightInvalid;
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = IR_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0") ? @[@"_UIBarBackground"] : @[@"_UINavigationBarBackground"];
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
            CGFloat heightIncrease = self.heightIncreaseRequired ? [self heightIncreaseValue] : 0.0f;
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarHidden ? 0.0f : statusBarFrame.size.height;
            
            if (!CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
                frame.origin.y = bounds.origin.y + heightIncrease - statusBarHeight;
                frame.size.height = bounds.size.height + statusBarHeight;
            } else {
                frame.origin.y = -statusBarHeight;
                frame.size.height = bounds.size.height + statusBarHeight + heightIncrease;
            }
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize originalSize = [super sizeThatFits:size];
    
    // capture original size
    if (self.standardBarHeight == IRStandardBarHeightInvalid) {
        self.standardBarHeight = originalSize.height;
    }
    
    // if a transform is active always account for the height increase
    if (!CGAffineTransformIsIdentity(self.transform)) {
        originalSize.height += [self heightIncreaseValue];
    } else {
        originalSize.height += [self safeHeightIncreaseValue];
    }
    return originalSize;
}

#pragma mark - Public

- (CGFloat)heightIncreaseValue {
    return 0.0f;
}

- (BOOL)heightIncreaseRequired {
    return YES;
}

- (void)setOffsetTransformRequired:(BOOL)required {
    if (required) {
        [self setTransform:CGAffineTransformMakeTranslation(0, -([self heightIncreaseValue]))];
    } else {
        [self setTransform:CGAffineTransformIdentity];
    }
}

#pragma mark - Internal

- (CGFloat)safeHeightIncreaseValue {
    if (self.heightIncreaseRequired && self.frame.size.height == self.standardBarHeight) {
        return [self heightIncreaseValue];
    }
    return 0.0f;
}

@end
