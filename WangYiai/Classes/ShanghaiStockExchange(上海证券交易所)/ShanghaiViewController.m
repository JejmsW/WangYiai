//
//  ShanghaiViewController.m
//  WangYiai
//
//  Created by Jejms on 2019/12/8.
//  Copyright © 2019 Jejms. All rights reserved.
//

#import "ShanghaiViewController.h"
#import "ShenzhenCell.h"
#import "fmdbTool.h"
#import "UIView+Frame.h"
#import "MBProgressHUD+CCHUD.h"
@interface ShanghaiViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *ARR;
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, strong) NSTimer *Rtimer;//定时器
@property (nonatomic,strong) UIButton *faCaiBtn;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) UILabel *currentTimeLab;
@property (nonatomic,assign) CGFloat count;
@property (nonatomic,strong) UIButton *changepercent;
@property (nonatomic,strong) UIButton *name;
@end

@implementation ShanghaiViewController
-(UIButton *)name{
    if (!_name) {
        _name = [UIButton buttonWithType:UIButtonTypeCustom];
        [_name setTitle:@"股票名称" forState:UIControlStateNormal];
        [_name setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_name.titleLabel setFont:[UIFont systemFontOfSize:Ratio(16)]];
        _name.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_name addTarget:self action:@selector(NameClick:) forControlEvents:UIControlEventTouchUpInside];
        _name.frame = CGRectMake(Ratio(16), (Ratio(32) - Ratio(16)) / 2, Ratio(70), Ratio(16));
    }
    return _name;
}
#pragma mark - LazyLoa
-(UIButton *)changepercent{
    if (!_changepercent) {
        _changepercent = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changepercent setTitle:@"涨跌幅" forState:UIControlStateNormal];
        [_changepercent setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
        [_changepercent.titleLabel setFont:[UIFont systemFontOfSize:Ratio(16)]];
        _changepercent.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_changepercent addTarget:self action:@selector(ChangepercentClick:) forControlEvents:UIControlEventTouchUpInside];
        _changepercent.frame = CGRectMake(ScreenW - Ratio(100) - Ratio(20), (Ratio(32) - Ratio(16)) / 2, Ratio(100), Ratio(16));
    }
    return _changepercent;
}
-(UILabel *)currentTimeLab{
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
        _currentTimeLab.textAlignment = NSTextAlignmentCenter;
        _currentTimeLab.textColor = [UIColor whiteColor];
        _currentTimeLab.font = [UIFont systemFontOfSize:Ratio(20)];
        self.navigationItem.titleView = _currentTimeLab;
    }
    return _currentTimeLab;
}
-(NSMutableArray *)ARR{
    if (!_ARR) {
        _ARR = [NSMutableArray array];
    }
    return _ARR;
}
-(NSTimer *)Rtimer{
    if (!_Rtimer) {
        _Rtimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(RGetRichClick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _Rtimer;
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(GetRichClick) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}
-(UIButton *)faCaiBtn{
    if (!_faCaiBtn) {
        _faCaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _faCaiBtn.backgroundColor = maiColor;
        [_faCaiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_faCaiBtn setImage:[UIImage imageNamed:@"组1"] forState:UIControlStateNormal];
        [_faCaiBtn setTitle:@"开" forState:UIControlStateNormal];
//        [_faCaiBtn setImage:[UIImage imageNamed:@"开关"] forState:UIControlStateNormal];
        [_faCaiBtn setTitle:@"关" forState:UIControlStateSelected];
        [_faCaiBtn.titleLabel setFont:[UIFont systemFontOfSize:Ratio(18)]];
        [_faCaiBtn addTarget:self action:@selector(faCaiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_faCaiBtn addGestureRecognizer:panGesture];
//        _faCaiBtn.layer.borderColor = [maiColor CGColor];
//        _faCaiBtn.layer.borderWidth = Ratio(2);
        _faCaiBtn.layer.cornerRadius = Ratio(30);
        _faCaiBtn.layer.masksToBounds = YES;
        [self.view addSubview:_faCaiBtn];
    }
    return _faCaiBtn;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,NewConstraints ? 88 : 64, [UIScreen mainScreen].bounds.size.width, ScreenH - (NewConstraints ? 88 + 83 : 64 + 49)) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBA(245, 245, 245, 1);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, NRatio(0), 0, NRatio(0));
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShenzhenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShenzhenCell"];
    if (!cell) {
        cell = [[ShenzhenCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ShenzhenCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.Dic = self.ARR[indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.ARR.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return Ratio(64);
}
//HEADER
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *Header = [[UIView alloc]init];
    Header.backgroundColor = RGBA(245, 245, 245, 1);
    Header.frame = CGRectMake(0, 0, ScreenW, Ratio(32));
    
//    UILabel *name = [[UILabel alloc]init];
//    name.text = @"股票名称";
//    name.textColor = RGBA(51, 51, 51, 1);
//    name.font = [UIFont systemFontOfSize:Ratio(16)];
//    name.textAlignment = NSTextAlignmentCenter;
//    name.frame = CGRectMake(Ratio(16), (Ratio(32) - Ratio(16)) / 2, Ratio(70), Ratio(16));
    [Header addSubview:self.name];
    
    UILabel *trade = [[UILabel alloc]init];
    trade.text = @"最新价";
    trade.textColor = RGBA(51, 51, 51, 1);
    trade.font = [UIFont systemFontOfSize:Ratio(16)];
    trade.textAlignment = NSTextAlignmentRight;
    trade.frame = CGRectMake(Ratio(170), (Ratio(32) - Ratio(16)) / 2, Ratio(100), Ratio(16));
    [Header addSubview:trade];
    

    [Header addSubview:self.changepercent];
    
    UIView *Bline = [[UIView alloc]init];
    Bline.backgroundColor = RGBA(245, 245, 245, 1);
    Bline.frame = CGRectMake(0, Header.frame.size.height - 1, ScreenW, 1);
    [Header addSubview:Bline];
    
    return Header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return Ratio(32);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *Dic =  self.ARR[indexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = Dic[@"name"];
    [self ShowHint:@"成功" yOffset:0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"深圳证券交易所";
    self.currentTimeLab.text = @"深圳证券交易所";
    [self.view addSubview:self.tableView];
    self.faCaiBtn.frame = CGRectMake(ScreenW - Ratio(60), Ratio(160), Ratio(60), Ratio(60));
    [self.timer setFireDate:[NSDate distantPast]];//运行
    [self Refresh];
}
-(void)Refresh{
    __weak __typeof(self) weakSelf = self;
    [self.hud showAnimated:YES];
    NSMutableArray *Arr = [NSMutableArray array];
    for (int i = 1; i < 20; i++) {
        [HttpTool postWithPath:@"/finance/stock/shall" params:@{@"key":AppKey,@"type":@4,@"page":@(i)} success:^(id json) {
                    if ([json[@"reason"] isEqualToString:@"SUCCESSED!"]) {
                        [Arr addObjectsFromArray:json[@"result"][@"data"]];
                        if (Arr.count >= 1461) {
                            [weakSelf dataBase:Arr];
                        }
                    }else{
                        [weakSelf.hud hideAnimated:YES];
                    }
                } failure:^(NSError *error) {
                    [weakSelf.hud hideAnimated:YES];
                }];
    }
    
}
-(void)dataBase:(NSMutableArray *)ARR{
    
    if (_count == 0) {
        [[fmdbTool shareData] Ddelete];
        for (NSDictionary *DIC in ARR) {
            [[fmdbTool shareData] insertSymbol:DIC[@"symbol"] Dic:DIC];
        }
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"Increase" Desc:@"desc"];
        [self.tableView reloadData];
        [self.hud hideAnimated:YES];
    }else{
        for (NSDictionary *dic in ARR) {
                [[fmdbTool shareData] updateSymbol:dic[@"symbol"] Dic:dic Page:_count];
        }
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"Increase" Desc:@"desc"];
        [self.tableView reloadData];
        [self.hud hideAnimated:YES];
    }
    
}
-(void)GetRichClick{
    [self GetCurrentTime];
}
-(void)RGetRichClick{
    _count ++;
    if (_count == 11) {
        [_Rtimer setFireDate:[NSDate distantFuture]];//停止
        return;
    }
    [self Refresh];
}
-(void)faCaiBtnClick:(UIButton *)Btn{
    Btn.selected = !Btn.selected;
    if (Btn.selected) {
        [self.Rtimer setFireDate:[NSDate distantPast]];//运行
    }else{
        [self.Rtimer setFireDate:[NSDate distantFuture]];//停止
    }
}
-(void)NameClick:(UIButton *)Btn{
    self.name.selected = !Btn.selected;
    if (Btn.selected == NO) {
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"probability" Desc:@"asc"];
        [self.tableView reloadData];
    }else{
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"probability" Desc:@"desc"];
        [self.tableView reloadData];
    }
}
-(void)ChangepercentClick:(UIButton *)Btn{
    self.changepercent.selected = !Btn.selected;
    if (Btn.selected == NO) {
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"Increase" Desc:@"asc"];
        [self.tableView reloadData];
    }else{
        self.ARR = [[fmdbTool shareData] TableTurnArrayIncrease:@"Increase" Desc:@"desc"];
        [self.tableView reloadData];
    }
}
- (void)panAction:(UIPanGestureRecognizer *)recognizer {
    CGPoint translationPoint = [recognizer translationInView:self.view];
    CGPoint center = recognizer.view.center;
    recognizer.view.center = CGPointMake(center.x + translationPoint.x, center.y + translationPoint.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
    if (recognizer.view.x <= 0) {
        recognizer.view.x = 0;
        
    }
    if (recognizer.view.x >= self.view.width - recognizer.view.width) {
        recognizer.view.x = self.view.width - recognizer.view.width;
        
    }
    if (recognizer.view.y <= (NewConstraints ? 88 : 84)) {
        recognizer.view.y = (NewConstraints ? 88 : 84);
    }
    if (recognizer.view.y >= self.view.height - recognizer.view.height) {
        recognizer.view.y = self.view.height - recognizer.view.height;
    }
    
}
-(MBProgressHUD *)hud{
    if (!_hud) {
        [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];//菊花 全局设置
        
        _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        _hud.userInteractionEnabled = YES;
        _hud.removeFromSuperViewOnHide = NO;
//        [_hud hideAnimated:YES afterDelay:30];

        //    hud.label.textColor = [UIColor whiteColor];
        //    hud.label.text = @"加载中...";
        //    hud.label.font = [UIFont systemFontOfSize:15];
        //背景颜色
        _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hud.bezelView.backgroundColor = [UIColor lightGrayColor];
    }
    return _hud;
}
-(void)GetCurrentTime{
    NSDate * senddate=[NSDate
                       date];
    NSDateFormatter *dateformatter=[[NSDateFormatter
                                     alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    NSString * locationString=[dateformatter
                               stringFromDate:senddate];
    self.currentTimeLab.text = [NSString stringWithFormat:@"深圳证券交易所 %@",locationString];

}
- (void)ShowHint:(NSString *)hint yOffset:(float)yOffset
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    if (yOffset == 0) {
        hud.offset = CGPointMake(0.f, yOffset);
    }else{
        hud.offset = CGPointMake(0.f, yOffset);
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.f];
}
@end
