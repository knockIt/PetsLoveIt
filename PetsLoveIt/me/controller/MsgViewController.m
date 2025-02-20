//
//  MsgViewController.m
//  PetsLoveIt
//
//  Created by liubingyang on 15/11/25.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "MsgViewController.h"
#import "SysMsgCell.h"
#import "MyMsgCell.h"
#import "GoodsDetailViewController.h"

@interface MsgViewController ()<MyMsgCellDelegate>

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.top = 5;
    self.view.backgroundColor = mRGBColor(245, 245, 245);
    [self prepareViewAndData];
    
}

- (void)prepareViewAndData{
    [self config];

}

- (void)setMsgRead{
    NSDictionary *params = @{@"uid":@"saveUserReadMsg",
                             @"msgType":@"2"
                             };
    [APIOperation GET:@"common.action" parameters:params onCompletion:^(id responseData, NSError *error) {
        if (!error) {
            
        }
    }];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [self setMsgRead];
    }
   [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
}
-(void)showProductVC:(NSString *)proId{
    GoodsDetailViewController *vc = [GoodsDetailViewController new];
    vc.goodsId = proId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMsgCell * cell =(MyMsgCell *) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SysMsgModel *model = [self.dataList objectAtIndex:indexPath.row];
    CGFloat height = [MyMsgCell heightForCellWithObject:model];
    
    return height;
}


/**
 *  模型配置
 */
-(void)config{
    
    LTConfigModel *configModel=[[LTConfigModel alloc] init];
    //url,分为公告和话题
    
    configModel.url=[NSString stringWithFormat:@"%@%@",kBaseURL,@"common.action"];
    
    //请求方式
    configModel.httpMethod=LTConfigModelHTTPMethodGET;
    configModel.params = @{
                           @"uid":@"getUserSystemMsg",
                           @"msgType":@"2"
                           };
    //模型类
        configModel.ModelClass=[SysMsgModel class];
    //    //cell类
        configModel.ViewForCellClass=[MyMsgCell class];
    //标识
    configModel.lid=NSStringFromClass(self.class);
    //pageName第几页的参数名
    configModel.pageName=@"startNum";
    
    //pageSizeName
    configModel.pageSizeName=@"limit";
    //pageSize
    configModel.pageSize = 10;
    //起始页码
    configModel.pageStartValue=0;
    //行高
    configModel.rowHeight=110;
    
    //移除返回顶部:(默认开启)
    configModel.removeBackToTopBtn=YES;
    
    configModel.refreshControlType = LTConfigModelRefreshControlTypeBoth;
    
    //配置完毕
    self.configModel=configModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
