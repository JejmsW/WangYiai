//
//  fmdbTool.h
//  WangYiai
//
//  Created by Jejms on 2019/12/19.
//  Copyright © 2019 Jejms. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface fmdbTool : NSObject
+ (instancetype)shareData;
-(BOOL)insertSymbol:(NSString *)symbol Dic:(NSDictionary *)dic;
-(BOOL)updateSymbol:(NSString *)symbol Dic:(NSDictionary *)dic Page:(CGFloat )page;
-(NSMutableArray *)TableTurnArrayIncrease:(NSString *)increase Desc:(NSString *)desc;
-(BOOL)Ddelete;
@end

NS_ASSUME_NONNULL_END
