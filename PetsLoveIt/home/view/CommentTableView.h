//
//  CommentTableView.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/5.
//  Copyright © 2015年 liubingyang. All rights reserved.
//
#import <UIKit/UIKit.h>
@class CommentModel,CommentCell;
@interface CommentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) CommentModel *rootModel;
@property (nonatomic,weak) CommentCell *supercell;
@end
