//
//  ArmsDisplayCollectionViewCell.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArmsDisplayCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkLabel;

+ (NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
