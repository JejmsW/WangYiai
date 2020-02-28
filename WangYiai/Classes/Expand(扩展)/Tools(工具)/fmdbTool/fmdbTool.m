//
//  fmdbTool.m
//  WangYiai
//
//  Created by Jejms on 2019/12/19.
//  Copyright © 2019 Jejms. All rights reserved.
//

#import "fmdbTool.h"
#import <FMDB.h>
@interface fmdbTool ()
@property (nonatomic, strong) FMDatabaseQueue *Queue;

@end

@implementation fmdbTool
static fmdbTool *FmdbTool = nil;
+ (instancetype)shareData
{
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        FmdbTool = [[fmdbTool alloc]init];
    });
    return FmdbTool;
    
}
-(BOOL )initializeGroup{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 拼接文件名
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"stock.sqlite"];
    NSLog(@"filePath = %@",filePath);
    // 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
    FMDatabaseQueue *Queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    _Queue = Queue;
    __block BOOL flag = false;
    [Queue inDatabase:^(FMDatabase *db) {
        flag = [db executeUpdate:@"create table if not exists t_stock (id integer primary key autoincrement,symbol text,name text,trade text,pricechange text,changepercent text,buy text,sell text,settlement text,open text,high text,low text,volume text,amount text,ticktime text,Increase integer,previous text,probability integer,page text)"];
        if (flag) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
    }];
    
    return flag;
    
}
-(BOOL)insertSymbol:(NSString *)symbol Dic:(NSDictionary *)dic{
    __block BOOL flag = false;
    CGFloat PriceDF = ([dic[@"trade"] floatValue] -[dic[@"open"] floatValue]) / [dic[@"open"] floatValue];
    NSLog(@"PriceDF = %f",PriceDF);
    if ([self initializeGroup]) {
        [_Queue inDatabase:^(FMDatabase *db) {
            flag = [db executeUpdate:@"insert into t_stock (symbol,name,trade,pricechange,changepercent,buy,sell,settlement,open,high,low,volume,amount,ticktime,Increase,previous,probability,page) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",symbol,dic[@"name"],dic[@"trade"],dic[@"pricechange"],dic[@"changepercent"],dic[@"buy"],dic[@"sell"],dic[@"settlement"],dic[@"open"],dic[@"high"],dic[@"low"],dic[@"volume"],dic[@"amount"],dic[@"ticktime"],@(PriceDF),dic[@"trade"],@0,@"0"];
            
        }];
    }else{
        
    }
    
    return flag;
}
-(BOOL)updateSymbol:(NSString *)symbol Dic:(NSDictionary *)dic Page:(CGFloat )page{
    __block BOOL flag = false;
    if ([self initializeGroup]) {
        [_Queue inDatabase:^(FMDatabase *db) {
            NSString *previous;
            FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"select * from t_stock where symbol = '%@'",symbol]];
            while ([result next]) {
                previous = [result stringForColumn:@"previous"];
            }
            
            
            CGFloat probability;
            if ([dic[@"trade"] floatValue] - previous.floatValue > 0) {
                probability = 1;
            }else if ([dic[@"trade"] floatValue] - previous.floatValue == 0){
                probability = 0;
            }else{
                probability = -1;
            }
            
            
            CGFloat PriceDF = ([dic[@"trade"] floatValue] -[dic[@"open"] floatValue]) / [dic[@"open"] floatValue];

            BOOL flag1 = [db executeUpdate:[NSString stringWithFormat:@"update t_stock set page = '%f' where symbol = '%@'",page,dic[@"symbol"]]];
            
//            int x = arc4random() % 10;
            BOOL flag2 = [db executeUpdate:[NSString stringWithFormat:@"update t_stock set probability = '%f' where symbol = '%@'",probability,dic[@"symbol"]]];
            
            BOOL flag3 = [db executeUpdate:[NSString stringWithFormat:@"update t_stock set trade = '%@' where symbol = '%@'",dic[@"trade"],dic[@"symbol"]]];
            
            BOOL flag4 = [db executeUpdate:[NSString stringWithFormat:@"update t_stock set Increase = '%f' where symbol = '%@'",PriceDF,dic[@"symbol"]]];
            
            BOOL flag5 = [db executeUpdate:[NSString stringWithFormat:@"update t_stock set previous = '%@' where symbol = '%@'",dic[@"trade"],dic[@"symbol"]]];
            
            if (flag1 && flag2 && flag3 && flag4 && flag5) {
                flag = YES;
            }else{
                flag = NO;
            }
        }];
    }else{
        
    }
    return flag;
}
-(NSMutableArray *)TableTurnArrayIncrease:(NSString *)increase Desc:(NSString *)desc{
    __block NSMutableArray *arr = [NSMutableArray array];
    if ([self initializeGroup]) {
        [_Queue inDatabase:^(FMDatabase *db) {
            FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"select * from t_stock order by %@ %@",increase,desc]];
            NSDictionary *dic;
            while ([result next]) {
                NSString *symbol = [result stringForColumn:@"symbol"];
                NSString *name = [result stringForColumn:@"name"];
                NSString *trade = [result stringForColumn:@"trade"];
                NSString *pricechange = [result stringForColumn:@"pricechange"];
                NSString *changepercent = [result stringForColumn:@"changepercent"];
                NSString *buy = [result stringForColumn:@"buy"];
                NSString *sell = [result stringForColumn:@"sell"];
                NSString *settlement = [result stringForColumn:@"settlement"];
                NSString *open = [result stringForColumn:@"open"];
                NSString *high = [result stringForColumn:@"high"];
                NSString *low = [result stringForColumn:@"low"];
                NSString *volume = [result stringForColumn:@"volume"];
                NSString *amount = [result stringForColumn:@"amount"];
                NSString *ticktime = [result stringForColumn:@"ticktime"];
                NSString *page = [result stringForColumn:@"page"];
                NSString *probability = [result stringForColumn:@"probability"];

                dic = @{@"symbol":symbol,@"name":name,@"trade":trade,@"pricechange":pricechange,@"changepercent":changepercent,@"buy":buy,@"sell":sell,@"settlement":settlement,@"open":open,@"high":high,@"low":low,@"volume":volume,@"amount":amount,@"ticktime":ticktime,@"page":page,@"probability":probability};
                [arr addObject:dic];
            }
            
            [result close];
            
        }];
    }
    return arr;
    
}
-(BOOL)Ddelete{
    __block BOOL flag = false;
    if ([self initializeGroup]) {
        [_Queue inDatabase:^(FMDatabase *db) {
            flag = [db executeUpdate:@"delete from t_stock"];
        }];
    };
    return flag;
}
@end
