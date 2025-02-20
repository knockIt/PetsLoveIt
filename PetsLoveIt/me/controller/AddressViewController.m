//
//  AddressViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/30.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressModel.h"
#import "AddAddressViewController.h"

@interface AddressViewController ()
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (nonatomic,strong) AddressModel *address;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareViewAndData];
}

- (void) prepareViewAndData{
    [self showNaviBarView];
    self.navBarTitleLabel.text = @"收货地址";
    self.addressView.width = mScreenWidth;
    [self.addressView addBottomBorderWithColor:kLayerBorderColor andWidth:kLayerBorderWidth];
    self.addressView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUpdateAddrVC)];
    [self.addressView addGestureRecognizer:tap];
    
    self.addBtn.layer.cornerRadius = 25;
    self.addressView.hidden = YES;
    self.addBtn.hidden = YES;
    self.tipLabel.hidden = YES;
   }

- (void)showUpdateAddrVC{
    AddAddressViewController *vc = [AddAddressViewController new];
    vc.isUpdateAddress = YES;
    vc.address = self.address;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)addAction:(id)sender {
    AddAddressViewController *vc = [AddAddressViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
