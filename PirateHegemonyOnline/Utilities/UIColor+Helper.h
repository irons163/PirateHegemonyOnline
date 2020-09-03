//
//  UIColor+Helper.h
//
//  Created by Phil on 2015/7/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Helper)
+ (UIColor *)colorWithColorCodeString:(NSString*)colorString;
+ (UIColor *)colorWithARGB:(NSUInteger)color;
+ (UIColor *)colorWithRGB:(NSUInteger)color;
+ (UIColor *)colorWithRGBA:(NSUInteger)color;
+ (UIColor *)colorWithRGBWithString:(NSString*)colorString;
@end
