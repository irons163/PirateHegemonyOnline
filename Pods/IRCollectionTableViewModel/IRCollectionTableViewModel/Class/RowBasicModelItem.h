//
//  RowBasicModelItem.h
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/29.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RowType.h"

NS_ASSUME_NONNULL_BEGIN

@interface RowBasicModelItem : NSObject
@property (readonly) RowType type;
@property (readonly) NSString *title;
@property (readonly) NSRange tagRange; // length default == 1

- (instancetype)initWithType:(RowType)type withTitle:(NSString*)title;
- (void)setTagRangeLength:(NSUInteger)length;
@end

NS_ASSUME_NONNULL_END
