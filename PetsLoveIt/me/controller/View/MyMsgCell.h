//
//  MyMsgCell.h
//  PetsLoveIt
//
//  Created by liubingyang on 15/12/9.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCell.h"
#import "SysMsgModel.h"

@protocol MyMsgCellDelegate <NSObject>

@optional
- (void) showProductVC:(NSString *)proId;

@end

@interface MyMsgCell : LTCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *productView;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak,nonatomic) id<MyMsgCellDelegate> delegate;
@property (weak,nonatomic) UIImageView *dotOnCommentImage;
+(CGFloat)heightForCellWithObject:(SysMsgModel *)object;
@end
