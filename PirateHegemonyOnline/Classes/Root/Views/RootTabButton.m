//
//  RootTabButton.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "RootTabButton.h"
#import "UIColor+Helper.h"
#import "ColorDefine.h"
#import "Masonry.h"

@implementation RootTabButton {
    UIImageView *indicatorView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initButton];
    }
    return self;
}

- (void)initButton {
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentEdgeInsets, UIEdgeInsetsZero)) {
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    
    UIColor *bgColor = [UIColor colorWithColorCodeString:@"F6F6F6"];
    self.backgroundColor = bgColor;

    [self setTitleColor:[UIColor colorWithColorCodeString:@"AAAAAA"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithColorCodeString:@"282828"] forState:UIControlStateSelected];
//
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.layer.borderColor = [UIColor.lightGrayColor CGColor];
//    self.titleLabel.tintColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    self.tintColor = [UIColor colorWithColorCodeString:NavigationBarBGColor];
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = [UIColor colorWithColorCodeString:NavigationBarBGColor];
    indicatorView.hidden = !self.selected;
    [self addSubview:indicatorView];
    
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(1);
        make.left.equalTo(self.titleLabel).offset(3);
        make.right.equalTo(self.titleLabel).offset(-3);
        make.height.mas_equalTo(6);
    }];
}
     
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    indicatorView.hidden = !selected;
}

@end
