//
//  UserSettingVC.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/29.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "UserSettingVC.h"
#import "BindEmailViewController.h"
#import "BindMobileViewController.h"
#import "AddAddressViewController.h"
#import "Nickname ViewController.h"
@interface UserSettingVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) AddressModel *addmodel;

@end

@implementation UserSettingVC

- (void)viewDidLoad {
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"个人设置";
    self.tableView.tableFooterView = [UIView new];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"meSettingCell"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.textLabel setTextColor:mRGBToColor(0x333333)];
    switch (indexPath.row) {
        case 0:
        {

            cell.textLabel.text = @"绑定手机";
            LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
            if ([userInfo.mobile length]>0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
               
                [label setTextColor:mRGBToColor(0x999999)];
                [label setFont:[UIFont systemFontOfSize:13]];
                [label setTextAlignment:NSTextAlignmentRight];
                [label setText:@"已绑定"];
                label.right = mScreenWidth - 34;
                label.center = CGPointMake(label.center.x, 27);
                [cell.contentView addSubview:label];
            }else{
                UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
                arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
                arrow.right = mScreenWidth - 10;
                arrow.center = CGPointMake(arrow.center.x, 27);
                [cell.contentView addSubview:arrow];
            }
            
        }
            break;
        case 1:
        {
             cell.textLabel.text = @"设置收货地址";
             UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
             arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
             arrow.right = mScreenWidth - 10;
             arrow.center = CGPointMake(arrow.center.x, 27);
            [cell.contentView addSubview:arrow];
            NSDictionary *params = @{
                                     @"uid":@"getDeliveryaddressByUserId"
                                     };
            [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
                if (!error) {
                    NSArray *jsonArray = [[responseData objectForKey:@"beans"] objectForKey:@"beans"];
                   
                    //            cell.detailTextLabel.text = @"用于积分商品的兑换";
                    
                   
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,150, 15)];
                    label.right = mScreenWidth - 10-24;
                    [label setTextColor:mRGBToColor(0x999999)];
                    [label setFont:[UIFont systemFontOfSize:13]];
                    [label setTextAlignment:NSTextAlignmentRight];
                    
                    label.center = CGPointMake(label.center.x, 27);
                    
                    [cell.contentView addSubview:label];
                    if (jsonArray.count > 0) {
                        self.addmodel = [[AddressModel alloc] initWithDictionary:jsonArray[0]];
                         [label setText:@"已绑定"];
                    }else{
                        [label setText:@"用于积分商品的兑换"];
                        self.addmodel = nil;
                    }
                }else{
                    mAlertAPIErrorInfo(error);
                }
            }];
                   }
            break;
            case 2:
        {
            cell.textLabel.text = @"修改昵称";
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
            arrow.image = [UIImage imageNamed:@"rightArrowIcon"];
            arrow.right = mScreenWidth - 10;
            arrow.center = CGPointMake(arrow.center.x, 27);
            [cell.contentView addSubview:arrow];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,150, 15)];
            label.right = mScreenWidth - 10-24;
            [label setTextColor:mRGBToColor(0x999999)];
            [label setFont:[UIFont systemFontOfSize:13]];
            [label setTextAlignment:NSTextAlignmentRight];
            
            label.center = CGPointMake(label.center.x, 27);
            
            [cell.contentView addSubview:label];
            label.text = [AppCache getUserName];;

        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LocalUserInfoModelClass *userInfo = [AppCache getUserInfo];
    if (indexPath.row ==0  && [userInfo.mobile length]==0) {
//        BindEmailViewController *vc = [BindEmailViewController new];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else if (indexPath.row == 1 && [userInfo.mobile length]==0){
        BindMobileViewController *vc = [BindMobileViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.row == 1){
        AddAddressViewController *vc = [AddAddressViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        vc.address = self.addmodel;
    }else if (indexPath.row == 2){
        Nickname_ViewController *vc = [[Nickname_ViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
