//
//  CoreTabsView.m
//  CoreTabsVC
//
//  Created by junfrost on 15/3/19.
//  Copyright (c) 2015年 junfrost. All rights reserved.
//

#import "CorePagesView.h"
#import "CorePagesBarView.h"
#import "CorePagesViewConst.h"


@interface CorePagesView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,assign) CGFloat width;


/**
 *  性能优化字典
 */
@property (nonatomic,strong) NSMutableDictionary *indexDict;



/**
 *  本视图所属的控制器
 */
@property (nonatomic,weak) UIViewController *ownerVC;






/**
 *  最大的页码
 */
@property (nonatomic,assign) NSUInteger maxPage;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *pagesBarViewHConstraint;

@property (nonatomic,assign) CGFloat barH;

@property (nonatomic,assign) CGRect originalFrame;


/**
 *  记录offset的字典
 */
@property (nonatomic,strong) NSMutableDictionary *offsetDict;


/**
 *  记录insets的字典
 */
@property (nonatomic,strong) NSMutableDictionary *insetsDict;



/**
 *  记录出现过的view
 */
@property (nonatomic,strong) NSMutableArray *calViewsM;


/**
 *  页码
 */
@property (nonatomic,assign) NSUInteger page;


/**
 *  减速前的页码
 */
@property (nonatomic,assign) NSUInteger deceleratingPage;


/**
 *  上一次scrollView在didScroll中计算页码所使用的宽度
 */
@property (nonatomic,assign) CGFloat lastCalWidth;

@end



@implementation CorePagesView


/*
 *  快速实例化对象
 */
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels{
    
    CorePagesView *pagesView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        //记录所属控制器
        pagesView.ownerVC=ownerVC;
        
        //模型数组
        pagesView.pageModels=pageModels;
        
    });
    
    return pagesView;
}

+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels pageWidth:(CGFloat)width isHomePage:(BOOL) isHomePage{
    
    CorePagesView *pagesView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    pagesView.frame = CGRectMake(0, 64, width, mScreenHeight-64);
    dispatch_async(dispatch_get_main_queue(), ^{
        //记录所属控制器
        pagesView.ownerVC=ownerVC;
        pagesView.homePageWidth = isHomePage;
        //模型数组
        pagesView.pageModels=pageModels;
        
    });
    
    return pagesView;
}
+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels isHomePage:(BOOL) isHomePage{
    CorePagesView *pagesView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //记录所属控制器
        pagesView.ownerVC=ownerVC;
        
        pagesView.homePageWidth = isHomePage;
        //模型数组
        pagesView.pageModels=pageModels;
        
    });
    
    return pagesView;
}

+(instancetype)viewWithOwnerVC:(UIViewController *)ownerVC pageModels:(NSArray *)pageModels useAutoResizeWidth:(BOOL) useAutoResizeWidth{
    
    CorePagesView *pagesView=[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //记录所属控制器
        pagesView.ownerVC=ownerVC;
        
        pagesView.useAutoResizeWidth = useAutoResizeWidth;
        //模型数组
        pagesView.pageModels=pageModels;
        
    });
    
    return pagesView;
}


-(id)currentVC{
    return [self.pageModels[self.page] pageVC];
}


-(void)awakeFromNib{
    
    [super awakeFromNib];

    self.scrollView.pagingEnabled=YES;

    //注册屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //设置scrollView的代理
    self.scrollView.delegate=self;
    
    //隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator = NO;//隐藏垂直滚动条
    //高度修复
    _pagesBarViewHConstraint.constant = CorePagesBarViewH;
    
    //初始化
    self.lastCalWidth=self.width;
    //事件处理
    [self event];
    
    //设置值
    _scrollView.contentInset =UIEdgeInsetsMake(CorePagesBarViewH, 0, 0, 0);
    _scrollView.contentOffset = CGPointMake(0, -CorePagesBarViewH);
}


-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  事件处理
 */
-(void)event{
    
    
     __weak typeof(self) weakSelf=self;
    self.pagesBarView.btnActionBlock=^(CorePagesBarBtn *btn,NSUInteger page){
        weakSelf.page=page;
        [weakSelf scrollViewActionWithPage:page];
    };
}





/**
 *  注册屏幕旋转
 */
-(void)deviceRotate{

    self.pagesBarView.page=self.page;
    [self scrollViewActionWithPage:self.page];
    [self adjustContentSize];
}



-(void)setPageModels:(NSArray *)pageModels{
    
    _pageModels=pageModels;
    
    
    
    //模型检查
    BOOL res=[CorePageModel modelCheck:pageModels];
    
    if(!res){
        
        NSLog(@"您传的pageModels数组格式不正确，请检查！");
        
        return;
    }
    
    self.pagesBarView.useAutoResizeWidth = self.useAutoResizeWidth;
    self.pagesBarView.homePageWidth = self.homePageWidth;
    //数据传递
    self.pagesBarView.pageModels=pageModels;
    
    
    //调整contentSize
    [self adjustContentSize];
    
    //性能优化：最开始只加第一个
    [self handleForPage:0];
}


/**
 *  调整contentSize
 */
-(void)adjustContentSize{
    CGFloat width=self.width;
    CGFloat num=self.pageModels.count;
    if(num<=0) num=1;
    self.scrollView.contentSize=CGSizeMake(width * num, 0);
}


-(void)handleForPage:(NSUInteger)page{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CorePageModel *pageModel=_pageModels[page];
        
        //判断页面是否已经添加
        if(_indexDict!=nil && [_indexDict.allKeys containsObject:@(page)]){
            return;
        }
        
        //添加子控制器
        [self.ownerVC addChildViewController:pageModel.pageVC];
        
        //添加视图
        UIView *subView=pageModel.pageVC.view;
        subView.tag=100;
        
        [self.scrollView addSubview:subView];

        if(subView != nil){
            
            //字典记录
            [self.indexDict setObject:subView forKey:@(page)];
        }

        [self setNeedsLayout];
    });
}



-(void)layoutSubviews{
    
    [super layoutSubviews];

    self.originalFrame=self.bounds;
    
    NSArray *subViews=self.scrollView.subviews;
    
    CGRect frame=_originalFrame;
    
    NSUInteger index=0;

    for (NSInteger i=0; i<subViews.count; i++) {
        
        UIView *subView=subViews[i];

        //非我们的子控件不需要处理
        if([subView isKindOfClass:[UIImageView class]]){
            continue;
        }
        
        index=[self findIndex:subView];
 
        if([subView isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView=(UIScrollView *)subView;

            if(![self.calViewsM containsObject:@(index)]){
                //处理insets
                UIEdgeInsets insets=scrollView.contentInset;
                insets.top+=self.barH;
                scrollView.contentInset=insets;
                
                //处理offset
                CGPoint offset=scrollView.contentOffset;
                offset.y+=-self.barH;
                scrollView.contentOffset=offset;
                
                //记录subView
                [self.calViewsM addObject:@(index)];
            }
            
        }else{
            self.scrollView.contentInset=UIEdgeInsetsMake(CorePagesBarViewH, 0, 0, 0);
            
            frame.size.height=_originalFrame.size.height - CorePagesBarViewH;
        }
        
        
        frame.origin.x= frame.size.width * index;
       
        subView.frame=frame;
        subView.width = mScreenWidth;
    }
}



-(NSUInteger)findIndex:(UIView *)subView{
    
    if(_pageModels==nil || _pageModels.count==0) return 0;
    
    for (CorePageModel *pageModel in _pageModels) {
        
        if(pageModel.pageVC.view != subView) continue;
        
        return [_pageModels indexOfObject:pageModel];
    }
    
    return 0;
}





-(CGFloat)width{
    return self.bounds.size.width;
}

-(CGFloat)barH{
    
    return _pagesBarViewHConstraint.constant;
    
}


-(void)setPage:(NSUInteger)page{
    
    if(_page==page) return;

    if(page>=self.maxPage) page=self.maxPage;

    _page=page;
    
    //页码传递
    self.pagesBarView.page=page;
    
    if(self.scrollView.isDragging) return;
    
    //页码处理并加载视图
    [self pageHandle:YES];
    
    //处理视图生命周期
    [self handleViewLife:YES];
}


/**
 *  页码改变，scrollView做出响应
 */
-(void)scrollViewActionWithPage:(NSUInteger)page{
    
    CGFloat x =self.width * page;
    
    CGPoint offset=CGPointMake(x, -CorePagesBarViewH);
    
    [UIView animateWithDuration:CorePagesAnimDuration animations:^{
        [self.scrollView setContentOffset:offset animated:NO];
    }];
}




/**
 *  scrollView代理方法区
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX=scrollView.contentOffset.x;
    
    CGFloat width=self.width;
    
    if(_lastCalWidth != width && _lastCalWidth!=600){
        
        _lastCalWidth=width;
        return;
    }
    
    //获取页面
    NSInteger page=(offsetX / width) + .5f;
    
    [self handleForPage:page];

    self.page=page;
    
    _lastCalWidth=width;
}






-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(self.scrollView.isDragging) return;
    self.deceleratingPage=self.page;
}

/**
 *  处理视图生命周期
 */
-(void)handleViewLife:(BOOL)isTopBtnClick{
    
    //尝试遍历
    [_indexDict enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIView *subView, BOOL *stop) {
        
        if(![key isEqualToNumber:@(_page)]){
            
            if(isTopBtnClick){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(!self.scrollView.isDragging){
                        [subView removeFromSuperview];
                    }
                });
            }else{
                if(!self.scrollView.isDragging){
                    [subView removeFromSuperview];
                }
            }
            
            [_indexDict removeObjectForKey:key];
//            NSLog(@"index=%@的视图被移除",key);
            

        }else{
//            NSLog(@"index=%@的视图被保留",key);
        }
    }];
}





-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //页码处理并加载视图
    [self pageHandle:NO];
}



/**
 *  页码处理并加载视图
 */
-(void)pageHandle:(BOOL)topBtnClick{
    
    if(_pageModels==nil ||_pageModels.count==0) return;
    
    
    //取出下一个页面的页码
    NSUInteger prePage=_page-1;
    NSUInteger nowPager=_page;
    NSUInteger nextPage=_page+1;
    

    if(nextPage >= self.maxPage) nextPage=self.maxPage;
    if(prePage>=self.maxPage-1)prePage=_maxPage-1;
    
    //取出对应的模型
    if(topBtnClick){
        [self handleForPage:nowPager];
    }else{
        [self handleForPage:prePage];
        [self handleForPage:nextPage];
        
    }
}



/**
 *  懒加载
 */
-(NSMutableDictionary *)indexDict{
    
    if(_indexDict==nil){
        _indexDict=[NSMutableDictionary dictionary];
    }
    
    return _indexDict;
}

-(NSMutableDictionary *)offsetDict{
    
    if(_offsetDict==nil){
        
        _offsetDict=[NSMutableDictionary dictionary];
    }
    
    return _offsetDict;
}

-(NSMutableDictionary *)insetsDict{
    
    if(_insetsDict==nil){
        
        _insetsDict=[NSMutableDictionary dictionary];
    }
    
    return _insetsDict;
}


-(NSMutableArray *)calViewsM{
    
    if(_calViewsM==nil){
        _calViewsM=[NSMutableArray array];
    }
    
    return _calViewsM;
}



-(NSUInteger)maxPage{
    
    if(_maxPage<=0 && _pageModels!=nil){
        _maxPage=_pageModels.count - 1;
    }
    
    return _maxPage;
}



-(void)setDeceleratingPage:(NSUInteger)deceleratingPage{
    
    if(_deceleratingPage == deceleratingPage) return;
    
    _deceleratingPage = deceleratingPage;
   
    //处理视图生命周期
    [self handleViewLife:NO];
}



@end
