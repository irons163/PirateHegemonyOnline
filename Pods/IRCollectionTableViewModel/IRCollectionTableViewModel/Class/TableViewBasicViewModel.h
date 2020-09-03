//
//  TableViewBasicViewModel.h
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/26.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionModelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewBasicViewModel : NSObject {
@protected
    NSMutableArray<id<SectionModelItem>>* items;
}

@property (weak) UIViewController *owner;

- (NSInteger)getRowTypeWith:(SectionType)type row:(NSInteger)row;
- (NSString *)getSectionTitleinSection:(NSInteger)section;
- (UIImage *)getSectionLeftIconinSection:(NSInteger)section;
- (SectionType)getSectionTypeinSection:(NSInteger)section;
- (void)hideRows:(BOOL)hide inSection:(NSInteger)section;
- (BOOL)hiddenRowsinSection:(NSInteger)section;
- (NSIndexSet *)getIndexSetWithSectionType:(SectionType)sectionType;
- (NSIndexPath *)getIndexPathWithSectionType:(SectionType)sectionType rowType:(RowType)rowType;
- (void)setupRowTag;
- (NSIndexPath *)getIndexPathFromRowTag:(NSInteger)rowTag;
@end

NS_ASSUME_NONNULL_END
