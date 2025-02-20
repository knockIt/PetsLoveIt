//
//  GradeDetailViewController.m
//  PetsLoveIt
//
//  Created by 廖先龙 on 15/12/6.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "GradeDetailViewController.h"
#import "GradeDetailHeaderView.h"
#import "MBProgressHUD+Add.h"
#import "GradePopView.h"
#import "PetsLoveIt-swift.h"
#import "MyHistoryGradeViewController.h"
#import "UserSettingVC.h"

@interface GradeDetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isPushOldExchange;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *totalPagesLabel;

@property (weak, nonatomic) IBOutlet UILabel *residuePagesLabel;
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

@property (strong, nonatomic) GradeDetailHeaderView *headerView;
@end

@implementation GradeDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    [self refreshnumberforgoods];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.height = height+20;
     //contentsize是内容的宽和高
    self.scrollView.contentSize = CGSizeMake(mScreenWidth, self.webView.bottom);
    self.scrollView.showsVerticalScrollIndicator = NO;
}
- (void)configUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"兑换详情";
    
    [self.scrollView addSubview:self.headerView];
    self.scrollView.delegate =self;
    UILabel *desclabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.headerView.bottom+20, mScreenWidth-40, 17)];
    desclabel.top =  mNavBarHeight+mStatusBarHeight+128+20;
    desclabel.text = [NSString stringWithFormat:@"基本信息"];
    desclabel.textAlignment = NSTextAlignmentLeft;
    desclabel.font = [UIFont systemFontOfSize:17];
    [desclabel setTextColor:mRGBToColor(0x333333)];
    UILabel *discountlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, desclabel.bottom+30, mScreenWidth-40, 14)];
    discountlabel.text = [NSString stringWithFormat:@"优惠额度: %@",self.gradeModel.discount];
    discountlabel.textAlignment = NSTextAlignmentLeft;
    discountlabel.font = [UIFont systemFontOfSize:14];
    [discountlabel setTextColor:mRGBToColor(0x666666)];
    UILabel *Datelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, discountlabel.bottom+16, mScreenWidth-40, 14)];
    Datelabel.text = [NSString stringWithFormat:@"有效日期: %@",self.gradeModel.effectiveDate];
    Datelabel.textAlignment = NSTextAlignmentLeft;
    Datelabel.font = [UIFont systemFontOfSize:14];
    [Datelabel setTextColor:mRGBToColor(0x666666)];
    UILabel *receiveLimitlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, Datelabel.bottom+16, mScreenWidth-40, 14)];
    receiveLimitlabel.text = [NSString stringWithFormat:@"领取限制: %@",self.gradeModel.receiveLimit];
    receiveLimitlabel.textAlignment = NSTextAlignmentLeft;
    receiveLimitlabel.font = [UIFont systemFontOfSize:14];
    [receiveLimitlabel setTextColor:mRGBToColor(0xFF4401)];
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(20, receiveLimitlabel.bottom+40, 150, 17)];
    subtitle.text = @"详细内容";
    subtitle.textAlignment = NSTextAlignmentLeft;
    subtitle.font = [UIFont systemFontOfSize:17];
    [subtitle setTextColor:mRGBToColor(0x333333)];
    [self.scrollView addSubview:desclabel];
    [self.scrollView addSubview:discountlabel];
    [self.scrollView addSubview:Datelabel];
    [self.scrollView addSubview:receiveLimitlabel];
    [self.scrollView addSubview:subtitle];
    self.webView.delegate =self;
    self.webView.top = subtitle.bottom+20;
//    self.webView.height = mScreenHeight - 64- self.headerView.height - self.bottomView.height-222;
    self.webView.left = 12;
    self.webView.width = mScreenWidth-24;
    
    NSString *html = self.gradeModel.instructions;
    NSString *css = [NSString stringWithFormat:
                     @"<html><head><style>body{ background-color: transparent; text-align: %@; font-size: %ipx; color: #666666;} a { color: #0663b3; } </style></head><body>",
                     @"justify",
                     13];
    
    NSMutableString *desc = [NSMutableString stringWithFormat:@"%@%@%@",
                             css,
                             html,
                             @"</body></html>"];
    [self.webView loadHTMLString:desc baseURL:nil];
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(self.headerView.height, 0, 0, 0);
    
    [self.headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.gradeModel.discountPic]
                          placeholderImage:[UIImage imageNamed:@"jifenxiangqing_default_load"]];
    
    self.headerView.titleLabel.text = self.gradeModel.name;
    
    [self.headerView.titleLabel sizeToFit];
    
    NSDictionary *headerAttributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                 NSFontAttributeName: [UIFont systemFontOfSize:16]};
    NSString *str = [NSString stringWithFormat:@"%@ 积分", self.gradeModel.integral];
    NSMutableAttributedString *headerAttributedStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                      attributes:headerAttributes];
    NSRange range = NSMakeRange(str.length - 2, 2);
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E),
                                  NSFontAttributeName: [UIFont systemFontOfSize:12]};
    [headerAttributedStr addAttributes:attributes1 range:range];
    self.headerView.timeLabel.attributedText  = headerAttributedStr;
    
    self.bottomView.width = mScreenWidth;
    [self.bottomView addTopBorderWithColor:kLineColor andWidth:.5];
    
    NSString *totalStr = [NSString stringWithFormat:@"总计：%@ 张", self.gradeModel.totalNum];
    NSDictionary *defaultDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E)};
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                 NSFontAttributeName: [UIFont systemFontOfSize:16]};

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr
                                                                                      attributes:defaultDict];
    NSRange  totalRange = NSMakeRange(3, self.gradeModel.totalNum.length);
    [attributedStr addAttributes:attributes range:totalRange];
    self.totalPagesLabel.attributedText = attributedStr;
    
    NSString *residueStr = [NSString stringWithFormat:@"剩余：%@ 张", self.gradeModel.remainingNum];
    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:residueStr
                                                                                      attributes:defaultDict];
    NSRange  totalRange1 = NSMakeRange(3, self.gradeModel.remainingNum.length);
    [attributedStr1 addAttributes:attributes range:totalRange1];
    self.residuePagesLabel.attributedText = attributedStr1;

    self.webView.scrollView.scrollEnabled = NO;
//    self.webView.height = self.webView.scrollView.contentSize.height;
//    [self.scrollView setContentSize:CGSizeMake(mScreenWidth, self.webView.bottom + 20)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exchangeAction:(id)sender
{

    if ([[AppCache getUserInfo].userIntegral intValue]<[self.gradeModel.integral intValue]) {
        [mAppUtils showHint:@"亲，您的积分不够，快去赚积分吧。"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"兑换中...";
    NSDictionary *parameter = @{@"uid": @"saveUserChangeIntegral",
                                @"userdiscountId":self.gradeModel.discountId
                                };
    WEAKSELF
    [APIOperation GET:@"common.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             [hud hide:YES];
             if (responseData) {
            
                 int rtnCode = [[responseData objectForKey:@"rtnCode"] intValue];
                 if (rtnCode == 1) {
                     [weakSelf exchangeSucceessfulWithJsonDict:responseData];
                     [self refreshnumberforgoods];
                     //创建一个消息对象
                     NSNotification * notice = [NSNotification notificationWithName:@"refreshtheintegral" object:nil userInfo:nil];
                     //发送消息
                     [[NSNotificationCenter defaultCenter]postNotification:notice];

                 }else if(rtnCode == 0){
                     
                     NSString *rtnmsg = [responseData objectForKey:@"rtnMsg"];
                     [mAppUtils showHint:rtnmsg];
                 }
                 
             }else {
                 [MBProgressHUD showError:@"兑换失败，请重试" toView:weakSelf.view];
             }
         }];
}
#pragma mark - 刷新剩余票数
- (void)refreshnumberforgoods
{
    NSDictionary *parameter = @{@"uid": @"getIntegralChangeById",
                                @"discountId":self.gradeModel.discountId
                                };
    [APIOperation GET:@"getCoreSv.action"
           parameters:parameter
         onCompletion:^(id responseData, NSError *error) {
             
             if (!error) {
                 NSDictionary *defaultDict = @{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                               NSForegroundColorAttributeName: mRGBToColor(0x9E9E9E)};
                 NSDictionary *attributes = @{NSForegroundColorAttributeName: mRGBToColor(0xF52E0A),
                                              NSFontAttributeName: [UIFont systemFontOfSize:16]};
                 NSDictionary *refreshdic = [responseData objectForKey:@"bean"];
                 NSString *residueStr = [NSString stringWithFormat:@"剩余：%@ 张", refreshdic[@"remainingNum"]];
                 self.gradeModel.remainingNum = refreshdic[@"remainingNum"];
                 if ([self.gradeModel.remainingNum intValue] <= 0) {
                     [self.exchangeButton setBackgroundColor: mRGBToColor(0xcccccc)];
                     self.exchangeButton.enabled = NO;
                 }
                 NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString:residueStr
                                                                                                    attributes:defaultDict];
                 NSRange  totalRange1 = NSMakeRange(3, self.gradeModel.remainingNum.length);
                 [attributedStr1 addAttributes:attributes range:totalRange1];
                 self.residuePagesLabel.attributedText = attributedStr1;
                 
             }else {
                
             }
         }];

}

- (void)exchangeSucceessfulWithJsonDict:(NSDictionary *)resp

{
    
    GradeExchangeModel *model = [[GradeExchangeModel alloc] initWithJson:resp];
    GradePopView *popView = [[GradePopView alloc]initWithFrame:CGRectMake(0, 0, 240, 176)];
    popView.backgroundColor = [UIColor whiteColor];
    
    popView.model = model;
    WEAKSELF
    XRZAlertControl *alertControl = [[XRZAlertControl alloc] initWithContentView:popView];
    alertControl.touchDismiss = YES;
    [alertControl show];
    
    popView.cellbackAction = ^(NSInteger index){
        [alertControl dismiss];
        if (index == 0) {
            weakSelf.isPushOldExchange = YES;
            MyHistoryGradeViewController *historyVC = [[MyHistoryGradeViewController alloc] init];
            historyVC.isFlog = YES;
            [weakSelf.navigationController pushViewController:historyVC animated:YES];
        }else {
            UserSettingVC *userSetVC = [[UserSettingVC alloc] initWithNibName:@"UserSettingVC" bundle:nil];
            [weakSelf.navigationController pushViewController:userSetVC animated:YES];
        }
    };

   
}

#pragma mark - *** getter ***

- (GradeDetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle] loadNibNamed:@"GradeDetailHeaderView"
                                                    owner:self
                                                  options:nil][0];
        _headerView.frame = CGRectMake(0, 64, mScreenWidth, 125);
        [_headerView addBottomBorderWithColor:kLineColor andWidth:.5];
    }
    return _headerView;
}
//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:@"refreshtheintegral"];
//   
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
