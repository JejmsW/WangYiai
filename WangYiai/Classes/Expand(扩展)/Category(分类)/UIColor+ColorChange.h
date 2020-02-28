//
//  UIColor+ColorChange.h
//  LeMengVilleggiatura
//
//  Created by jejms on 2018/8/8.
//  Copyright © 2018年 1697220970@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)
// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;
@end
