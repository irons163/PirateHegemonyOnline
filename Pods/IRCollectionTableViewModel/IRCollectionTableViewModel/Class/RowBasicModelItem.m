//
//  RowBasicModelItem.m
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/29.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import "RowBasicModelItem.h"
#import "RowBasicModelItem+Private.h"

@implementation RowBasicModelItem

-(instancetype)initWithType:(RowType)type withTitle:(NSString*)title {
    if (self = [super init]) {
        _type = type;
        _title = title;
        _tagRange = NSMakeRange(0, 1);
    }
    return self;
}

- (void)setTagRangeLength:(NSUInteger)length {
    _tagRange = NSMakeRange(_tagRange.location, length);
}

- (void)setTagRange:(NSRange)tagRange {
    _tagRange = tagRange;
}
@end
