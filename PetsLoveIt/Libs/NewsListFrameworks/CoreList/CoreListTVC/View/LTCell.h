//
//  LTCell.h
//  CoreLTVC
//
//  Created by 沐汐 on 15-3-9.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreListCommonModel.h"
#import "SWTableViewCell.h"



@interface LTCell : SWTableViewCell


/**
 *  模型数据
 */
@property (nonatomic,strong) CoreListCommonModel *model;

/**
 *  indexPath
 */
@property (nonatomic,strong) NSIndexPath *indexPath;


/**
 *  从缓存池中取cell封装
 */
+(instancetype)cellWithTableView:(UITableView *)tableView;


/**
 *  cell的创建
 */
+(instancetype)cellPrepare;


/**
 *  填充数据
 */
-(void)dataFill;

/**
 *  自己添加的参数显示是否是淘宠界面
 */

@end
