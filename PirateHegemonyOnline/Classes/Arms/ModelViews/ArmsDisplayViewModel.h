//
//  ArmsDisplayViewModel.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IRCollectionTableViewModel/IRCollectionTableViewModel.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ArmCollectionViewItemType){
    ItemType_Arm
};

@interface CollectionViewItem : RowBasicModelItem
@property (readonly) ArmCollectionViewItemType type;
@end

@interface CollectionViewSectionItem : SectionBasicModelItem
@property (nonatomic) NSString* sectionTitle;
@property (nonatomic) SectionType type;
@end

@interface ArmsDisplayViewModel : TableViewBasicViewModel<UICollectionViewDataSource>

@property (nonatomic) NSArray *arms;

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView;

- (void)update;

@end

NS_ASSUME_NONNULL_END
