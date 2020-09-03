//
//  SectionModelItem.h
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/26.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RowBasicModelItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SectionType);

@protocol SectionModelItem <NSObject>
@property (nonatomic) BOOL hideCells;
@property (nonatomic) NSArray<RowBasicModelItem *> *rows;
- (SectionType)type;
- (NSInteger)rowCount;
- (NSString*)sectionTitle;
- (UIImage *)sectionLeftIcon;
@end

NS_ASSUME_NONNULL_END
