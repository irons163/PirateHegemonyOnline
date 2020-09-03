//
//  Utilities.h
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utilities : NSObject

#pragma mark - Image
//Resize image
+ (UIImage*)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end

NS_ASSUME_NONNULL_END
