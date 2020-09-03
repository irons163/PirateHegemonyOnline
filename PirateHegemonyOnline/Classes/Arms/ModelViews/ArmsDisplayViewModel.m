//
//  ArmsDisplayViewModel.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "ArmsDisplayViewModel.h"
#import "ArmsDisplayCollectionViewCell.h"
#import "ArmsDisplayViewSectionType.h"
#import "DBManager.h"
#import "ArmUtility.h"

@interface CollectionViewItem()
@end

@implementation CollectionViewItem
@dynamic type;
@end

@implementation CollectionViewSectionItem
@end

@implementation ArmsDisplayViewModel

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView {
    if (self = [super init]) {
        items = [[NSMutableArray<id<SectionModelItem>> alloc] init];
        
        // Register cell classes
        [collectionView registerNib:[UINib nibWithNibName:ArmsDisplayCollectionViewCell.identifier bundle:nil] forCellWithReuseIdentifier:ArmsDisplayCollectionViewCell.identifier];
        
//        queue = [[NSOperationQueue alloc]init];
//        queue.maxConcurrentOperationCount = 2;
    }
    return self;
}

- (void)update {
    [items removeAllObjects];
    [self setupRows];
}

- (void)setupRows {
    NSMutableArray *rowItems = [NSMutableArray array];
    for (Arm *arm in _arms) {
        CollectionViewItem *item = [[CollectionViewItem alloc] initWithType:ItemType_Arm withTitle:@""];
        [rowItems addObject:item];
    }
    
    NSArray *armRowItems = [NSArray arrayWithArray:rowItems];
    CollectionViewSectionItem *sction = [[CollectionViewSectionItem alloc] initWithRowCount:[armRowItems count]];
    sction.type = ArmSection;
    sction.sectionTitle = @"";
    sction.rows = armRowItems;
    [items addObject:sction];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id<SectionModelItem> item = [items objectAtIndex:section];
    NSInteger itemsCount = [item rowCount];
    return itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SectionModelItem> item = [items objectAtIndex:indexPath.section];
    CollectionViewItem *row = (CollectionViewItem *)[item.rows objectAtIndex:[indexPath row]];
    
    switch (item.type) {
        case ArmSection:
        {
            switch (row.type) {
                case ItemType_Arm:
                {
                    ArmsDisplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArmsDisplayCollectionViewCell.identifier forIndexPath:indexPath];
                    
                    int position = 0;
                    for(int section = 0; section < indexPath.section; section++){
                        position += [collectionView numberOfItemsInSection:section];
                    }
                    
                    position += indexPath.row;
                    
                    Arm *arm = [_arms objectAtIndex:position];
                    
                    ArmCategory category = [arm category];
                    NSString *categoryStr = nil;
                    switch (category) {
                        case S_Class:
                            categoryStr = @"S";
                            break;
                        case A_Class:
                            categoryStr = @"A";
                            break;
                        case B_Class:
                            categoryStr = @"B";
                            break;
                        case C_Class:
                            categoryStr = @"C";
                            break;
                        case D_Class:
                            categoryStr = @"D";
                            break;
                        case E_Class:
                            categoryStr = @"E";
                            break;
                    }
                    
                    cell.categoryLabel.text = categoryStr;
                    cell.categoryLabel.textColor = [ArmUtility getArmCategoryColorFromArm:arm];
                    cell.atkLabel.text = [NSString stringWithFormat:@"%@%lld", @"ATK:", arm.atk];
                    
                    return cell;
                }
            }
            break;
        }
        default:
            break;
    }
    return [[UICollectionViewCell alloc] init];
}


@end
