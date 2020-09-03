//
//  IRSingleButtonGroup.m
//  IRSingleButtonGroup
//
//  Created by Phil on 2019/7/23.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRSingleButtonGroup.h"

@implementation IRSingleButtonGroup

- (instancetype)init {
    if (self = [super init]) {
        self.canSelectWhenSelected = NO;
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons {
    _buttons = buttons;
}

- (void)selected:(UIButton*)selectedButton {
    [self selected:selectedButton delegatable:YES];
}

- (void)setInitSelected:(UIButton*)selectedButton {
    [self selected:selectedButton delegatable:NO];
}

- (void)selected:(UIButton*)selectedButton delegatable:(BOOL)delegatable {
    if(![_buttons containsObject:selectedButton])
        return;
    
    if (!self.canSelectWhenSelected && !selectedButton.selected)
        selectedButton.userInteractionEnabled = NO;
    if (delegatable)
        [self.delegate didSelectedButton:selectedButton];
    selectedButton.selected = YES;
    for (UIButton* button in _buttons) {
        if (button == selectedButton)
            continue;
        if (self.canMultiSelected)
            break;
        
        if (!self.canSelectWhenSelected)
            button.userInteractionEnabled = YES;
        if (delegatable)
            [self.delegate didDeselectedButton:button];
        button.selected = NO;
    }
}

- (void)deselected:(UIButton *)selectedButton {
    selectedButton.userInteractionEnabled = YES;
    selectedButton.selected = NO;
    [self.delegate didDeselectedButton:selectedButton];
}

@end

