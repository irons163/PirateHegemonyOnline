//
//  TableViewBasicViewModel.m
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/4/26.
//  Copyright © 2019 EnGenius. All rights reserved.
//

#import "TableViewBasicViewModel.h"
#import "RowBasicModelItem+Private.h"

@implementation TableViewBasicViewModel

- (instancetype)init {
    if (self = [super init]) {
        items = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Public
- (NSString*)getSectionTitleinSection:(NSInteger)section {
    return [items[section] sectionTitle];
}

- (UIImage*)getSectionLeftIconinSection:(NSInteger)section {
    return [items[section] sectionLeftIcon];
}

- (SectionType)getSectionTypeinSection:(NSInteger)section {
    return [(id<SectionModelItem>)items[section] type];
}

- (void)hideRows:(BOOL)hide inSection:(NSInteger)section {
    [items[section] setHideCells:hide];
}

- (BOOL)hiddenRowsinSection:(NSInteger)section {
    return [items[section] hideCells];
}

- (NSInteger)getRowTypeWith:(SectionType)type row:(NSInteger)row {
    for (id<SectionModelItem> sectionItem in items) {
        if(sectionItem.type == type) {
            return sectionItem.rows[row].type;
        }
    }
    
    return NSNotFound;
}

- (NSIndexSet *)getIndexSetWithSectionType:(SectionType)sectionType {
    NSInteger section = -1;
    for (int i = 0; i < [self->items count]; i++) {
        id<SectionModelItem> item = [self->items objectAtIndex:i];
        if(item.type == sectionType) {
            section = i;
            break;
        }
    }
    
    if(section < 0)
        return nil;
    return [NSIndexSet indexSetWithIndex:section];
}

- (NSIndexPath *)getIndexPathWithSectionType:(SectionType)sectionType rowType:(RowType)rowType {
    NSInteger section = -1;
    for (int i = 0; i < [self->items count]; i++) {
        id<SectionModelItem> item = [self->items objectAtIndex:i];
        if(item.type == sectionType) {
            section = i;
            break;
        }
    }
    
    NSInteger row = -1;
    for (id<SectionModelItem> item in self->items) {
        for (int i = 0; i < [item.rows count]; i++) {
            RowBasicModelItem *rowObject = [item.rows objectAtIndex:i];
            if(rowObject.type == rowType) {
                row = i;
                break;
            }
        }
    }
    
    if(section < 0 || row < 0)
        return nil;
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)setupRowTag {
    NSInteger rowTag = 0;
    for (int section = 0; section < [items count]; section++) {
        for (RowBasicModelItem *row in items[section].rows) {
            row.tagRange = NSMakeRange(rowTag, row.tagRange.length);
            rowTag += row.tagRange.length;
        }
    }
}

- (NSIndexPath *)getIndexPathFromRowTag:(NSInteger)rowTag {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int section = 0; section < [items count]; section++) {
        for (int row = 0; row < [items[section].rows count]; row++) {
            RowBasicModelItem *rowItem = [items[section].rows objectAtIndex:row];
            NSInteger tagLength = rowItem.tagRange.length;
            rowTag -= tagLength;
            
            if (rowTag + 1 <= 0) {
                indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                return indexPath;
            }
        }
    }
    return indexPath;
}


@end
