//
//  ShenzhenCell.m
//  WangYiai
//
//  Created by Jejms on 2019/12/14.
//  Copyright © 2019 Jejms. All rights reserved.
//

#import "ShenzhenCell.h"
#import <Masonry.h>
@interface ShenzhenCell ()
@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *probability;
@property(nonatomic,strong) UILabel *symbol;
@property(nonatomic,strong) UILabel *trade;
@property(nonatomic,strong) UILabel *changepercent;
@end

@implementation ShenzhenCell
-(UILabel *)changepercent{
    if (!_changepercent) {
        _changepercent = [[UILabel alloc]init];
        _changepercent.text = @"+10.02%";
        _changepercent.textColor = RGBA(233, 19, 44, 1);
        _changepercent.font = [UIFont systemFontOfSize:Ratio(20)];
        _changepercent.textAlignment = NSTextAlignmentRight;
        [self addSubview:_changepercent];
    }
    return _changepercent;
}
-(UILabel *)trade{
    if (!_trade) {
        _trade = [[UILabel alloc]init];
        _trade.text = @"20.450";
        _trade.textColor = RGBA(233, 19, 44, 1);
        _trade.font = [UIFont systemFontOfSize:Ratio(20)];
        _trade.textAlignment = NSTextAlignmentRight;
        [self addSubview:_trade];
    }
    return _trade;
}
-(UILabel *)symbol{
    if (!_symbol) {
        _symbol = [[UILabel alloc]init];
        _symbol.text = @"sz300001";
        _symbol.textColor = RGBA(141, 141, 141, 1);
        _symbol.font = [UIFont systemFontOfSize:Ratio(12)];
        [self addSubview:_symbol];
    }
    return _symbol;
}
-(UILabel *)probability{
    if (!_probability) {
        _probability = [[UILabel alloc]init];
        _probability.text = [NSString stringWithFormat:@"胜率:%.1f",0.6000];
        _probability.textColor = RGBA(233, 19, 44, 1);
        _probability.font = [UIFont systemFontOfSize:Ratio(14)];
        [self addSubview:_probability];
    }
    return _probability;
}
-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.text = @"特锐德";
        _name.textColor = RGBA(51, 51, 51, 1);
        _name.font = [UIFont systemFontOfSize:Ratio(18)];
        [self addSubview:_name];
    }
    return _name;
}
-(void)setDic:(NSDictionary *)Dic{
    _Dic = Dic;
    CGFloat PriceDF = ([Dic[@"trade"] floatValue] -[Dic[@"open"] floatValue]) / [Dic[@"open"] floatValue];
    self.name.text = Dic[@"name"];
    self.symbol.text = Dic[@"symbol"];
    self.trade.text = Dic[@"trade"];
    self.changepercent.text = [NSString stringWithFormat:@"%.4f%@",PriceDF * 100 ,@"%"];
    self.probability.text = [NSString stringWithFormat:@"胜率:%.1f",[Dic[@"probability"] floatValue] / [Dic[@"page"] floatValue]];
    if (PriceDF > 0) {
        self.trade.textColor = RGBA(233, 19, 44, 1);
        self.changepercent.textColor = RGBA(233, 19, 44, 1);
    }else{
        self.trade.textColor = RGBA(35, 167, 105, 1);
        self.changepercent.textColor = RGBA(35, 167, 105, 1);
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.name.frame = CGRectMake(Ratio(18), Ratio(13), Ratio(100), Ratio(20));
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@(Ratio(18)));
        make.top.mas_equalTo(@(Ratio(13)));
        make.height.mas_equalTo(@(Ratio(20)));
    }];
    [self.probability mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name.mas_right).offset(10);
        make.top.mas_equalTo(@(Ratio(13)));
        make.height.mas_equalTo(@(Ratio(20)));
    }];
    self.symbol.frame = CGRectMake(Ratio(18), Ratio(38), Ratio(100), Ratio(13));
    self.trade.frame = CGRectMake(Ratio(170), (Ratio(64) - Ratio(20)) / 2, Ratio(100), Ratio(20));
    self.changepercent.frame = CGRectMake(ScreenW - Ratio(100) - Ratio(13), (Ratio(64) - Ratio(20)) / 2, Ratio(100), Ratio(20));

}
@end
