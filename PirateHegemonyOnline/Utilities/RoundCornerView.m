//
//  RoundCornerView.m
//  PirateHegemonyOnline
//
//  Created by Phil on 2019/5/21.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "RoundCornerView.h"

@implementation RoundCornerView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self invalidateIntrinsicContentSize];
        self.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
        [self setNeedsLayout];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self invalidateIntrinsicContentSize];
        self.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
        [self setNeedsLayout];
    }
    
    return self;
}

- (void)prepareForInterfaceBuilder {
    self.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
}

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}

-(void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.rasterizationScale = YES;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}

-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = [borderColor CGColor];
}

@end
