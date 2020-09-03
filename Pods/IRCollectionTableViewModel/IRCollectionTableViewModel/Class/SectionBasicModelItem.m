//
//  SectionBasicModelItem.m
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/26.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import "SectionBasicModelItem.h"
#import "SectionType.h"

@implementation SectionBasicModelItem {
    NSUInteger _rowCount;
}
@synthesize hideCells;
@synthesize rows;

- (instancetype)initWithRowCount:(NSUInteger)rowCount {
    if(self = [self init]){
        _rowCount = rowCount;
    }
    return self;
}

- (NSInteger)rowCount {
    if(self.hideCells)
        return 0;
    return _rowCount;
}

- (NSString *)sectionTitle {
    return nil;
}

- (UIImage *)sectionLeftIcon {
    return nil;
}

- (SectionType)type {
    return NONE;
}

@end
