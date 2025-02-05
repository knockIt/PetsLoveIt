//
//  CoreViewNetWorkStausManager.m
//  CoreViewNetWorkStausManager
//
//  Created by muxi on 15/3/12.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreViewNetWorkStausManager.h"
#import "CMView.h"
#import "CommentGoodsViewController.h"
#import "RichEditView.h"
#import "CarefulSelectViewController.h"
@implementation CoreViewNetWorkStausManager


+(void)show:(UIView *)view type:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock{

    //先移除一次
    [self dismiss:view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //创建CMView
        CMView *myCmView=[CMView cmViewWithType:type msg:msg subMsg:subMsg offsetY:offsetY failClickBlock:failClickBlock];
      
        if ([msg isEqualToString:kNoNetWorkTip]) {
            myCmView.imageView.image = [UIImage imageNamed:@"noNetWorkIcon"];
        }else if ([msg isEqualToString:kNoContentTip]||[msg isEqualToString:kNoBLTip]){
            myCmView.imageView.image = [UIImage imageNamed:@"noContentIcon"];
        }else{
            return ;
        }
        
        view.width = mScreenWidth;
       
       
        [view addSubview:myCmView];
       
       
        myCmView.alpha=0;
        [UIView animateWithDuration:.25f animations:^{
            myCmView.alpha=1.0f;
        }];
    });
    
}
+(void)showWithViewController:(UIViewController *)viewcontroller type:(CMType)type msg:(NSString *)msg subMsg:(NSString *)subMsg offsetY:(CGFloat)offsetY failClickBlock:(void(^)())failClickBlock{
    
    //先移除一次
    [self dismiss:viewcontroller.view];
    //创建CMView
   
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CMView *myCmView=[CMView cmViewWithType:type msg:msg subMsg:subMsg offsetY:offsetY failClickBlock:failClickBlock];
        
        if ([msg isEqualToString:kNoNetWorkTip]) {
            myCmView.imageView.image = [UIImage imageNamed:@"noNetWorkIcon"];
        }else if ([msg isEqualToString:kNoContentTip]||[msg isEqualToString:kNoBLTip]){
            myCmView.imageView.image = [UIImage imageNamed:@"noContentIcon"];
        }else{
            return ;
        }
        
        viewcontroller.view.width = mScreenWidth;
        
        [viewcontroller.view addSubview:myCmView];
       
        if ([viewcontroller isKindOfClass:[CommentGoodsViewController class]]) {
            for (UIView *vw in [viewcontroller.view subviews]) {
                if ([vw isKindOfClass:[RichEditToolBar class]]) {
                    [viewcontroller.view insertSubview:myCmView belowSubview:vw];
                }
            }
            
        }
       
        myCmView.alpha=0;
        [UIView animateWithDuration:.25f animations:^{
            myCmView.alpha=1.0f;
        }];
    });
    
}


+(void)dismiss:(UIView *)view{
    
    if (!view) {
        return;
    }
    NSArray *subViews=view.subviews;
    
    if(subViews==nil || subViews.count==0) return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //遍历
        for (UIView *subView in subViews) {
            
            if(![subView isKindOfClass:[CMView class]]) continue;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [subView removeFromSuperview];
            });
        }
    });
}


@end
