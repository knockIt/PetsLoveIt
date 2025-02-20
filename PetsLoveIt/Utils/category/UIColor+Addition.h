//
//  UIColor+WSK.h
//  smartcity
//
//  Created by kongjun on 13-11-1.
//  Copyright (c) 2013年 junfrost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

/**
 *  根据RGB返回UIColor。
 *  @param  red、green、blue:范围0—255。
 *  @param  alpha:透明度。
 *  return  UIColor。
 */
+ (UIColor *)red:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha;

/**
 *  根据UIColor返回RGB数组。
 *  @param  color:传递的参数。
 *  return  RGB数组
 */
+ (NSArray *)convertColorToRBG:(UIColor *)color;

/**
 *  根据十六进制颜色值返回UIColor。
 *  @param  hexColor:十六进制颜色值。
 *  return  UIColor。
 */
+ (UIColor *)convertHexColorToUIColor:(NSInteger)hexColor;

// 十六进制颜色值  ==  @"#666666"
+ (UIColor *)colorWithHexString: (NSString *)color;

@end
