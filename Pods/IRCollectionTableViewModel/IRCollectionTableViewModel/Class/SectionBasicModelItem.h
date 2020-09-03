//
//  SectionBasicModelItem.h
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/26.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SectionBasicModelItem : NSObject <SectionModelItem> 

-(instancetype)initWithRowCount:(NSUInteger)rowCount;
@end

NS_ASSUME_NONNULL_END
