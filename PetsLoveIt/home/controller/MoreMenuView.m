//
//  MoreMenuContainerView.m
//  PetsLoveIt
//
//  Created by 123 on 15/12/27.
//  Copyright © 2015年 liubingyang. All rights reserved.
//

#import "MoreMenuView.h"
#import "DXPopover.h"

#define kPlaceHolderTip @"请输入评论内容"
@implementation MoreMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.frame = CGRectMake(0, 0, (mScreenWidth-40)/3+10, 50);
    CGFloat popBtnWidth = self.width/2 -5;
    _popButton1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, popBtnWidth, 30)];
    [_popButton1 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];
     //[_popButton1 addLeftBorderWithColor:mRGBToColor(0x505050) andWidth:2];
    [_popButton1 setTitle:@"回复" forState:UIControlStateNormal];
    [_popButton1 addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
    [_popButton1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    _popButton2 = [[UIButton alloc] initWithFrame:CGRectMake(_popButton1.right, 10, popBtnWidth, 30)];
    //[_popButton2 addRightBorderWithColor:mRGBToColor(0x505050) andWidth:2];
    [_popButton2 setTitle:@"@Ta" forState:UIControlStateNormal];
    [_popButton2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_popButton2 addTarget:self action:@selector(atAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_popButton1];
    [self addSubview:_popButton2];
   
   
    return self;
}
//回复
- (void)replyAction
{
    self.editToolBar.hidden = NO;
        self.isReply = YES;
    self.isAt = NO;
        [[DXPopover sharedView] dismiss];
    self.editToolBar.inputTextView.text = @"";
    self.editToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复 \"%@\"",self.selectedComment.nickName==nil?self.selectedComment.otherNickName:self.selectedComment.nickName];
        [self.editToolBar.inputTextView becomeFirstResponder];
    

}
// @ta
- (void)atAction
{
    self.editToolBar.hidden = NO;
    [[DXPopover sharedView] dismiss];
    self.isReply = YES;
    self.isAt = YES;
    self.editToolBar.inputTextView.text = @"";
    self.editToolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"@%@ ",self.selectedComment.nickName==nil?self.selectedComment.otherNickName:self.selectedComment.nickName];
    
    [self.editToolBar.inputTextView becomeFirstResponder];
}

@end
