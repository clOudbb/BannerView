//
//  BannersView.m
//  BiliBili
//
//  Created by 张征鸿 on 16/3/18.
//  Copyright © 2016年 张征鸿. All rights reserved.
//

#import "BannersView.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>
// View的宽高
#define SELF_WIDTH     self.bounds.size.width
#define SELF_HEIGHT   self.bounds.size.height
@interface BannersView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bannersScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation BannersView
- (void) dealloc{
    _bannersScrollView.delegate = nil;
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame withURLArray: (NSMutableArray *)array{
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollViewWithCount:array.count];
        [self setImageWithArray:array];
        // 懒加载
        if (!_imgArr) {
            self.imgArr = [NSMutableArray array];
        }
        _imgArr = array;
    }
    return self;
}

+ (BannersView *) initWithFrame: (CGRect)frame withURLArray:(NSMutableArray *)array{
    return [[BannersView alloc] initWithFrame:frame withURLArray:array];
}

/** 创建ScrollView */
- (void) createScrollViewWithCount: (NSInteger) ArrayCount {

    self.bannersScrollView = [[UIScrollView alloc ] initWithFrame:CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT)];
    [self addSubview:_bannersScrollView];
    _bannersScrollView.delegate = self;
    _bannersScrollView.pagingEnabled = YES;
    _bannersScrollView.bounces = NO;
    _bannersScrollView.showsHorizontalScrollIndicator = NO;
    _bannersScrollView.showsVerticalScrollIndicator = NO;
    _bannersScrollView.contentSize = CGSizeMake(SELF_WIDTH * (ArrayCount+ 2), 0);
    _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);
    
  
}

/** 给图片赋值 */
- (void) setImageWithArray: (NSMutableArray *) array{
    // 通过数组个数判断图片位置
    for (int i = 0; i < array.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SELF_WIDTH* (i + 1), 0, SELF_WIDTH , SELF_HEIGHT)];
        NSString *urlStr = array[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        [_bannersScrollView addSubview:imgView];
        
        [self createTapGestureRecognizerWithImageView:imgView withIndex:i];
    }
    
    UIImageView *FirstImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT)];
    NSString *FirstUrlStr = array.lastObject;
    [FirstImgView sd_setImageWithURL:[NSURL URLWithString:FirstUrlStr]];
    [_bannersScrollView addSubview:FirstImgView];
    [self createTapGestureRecognizerWithImageView:FirstImgView withIndex:array.count];
    
    UIImageView *lastImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SELF_WIDTH * (array.count + 1), 0, SELF_WIDTH, SELF_HEIGHT)];
    NSString *lastUrlStr = array.firstObject;
    [lastImgView sd_setImageWithURL:[NSURL URLWithString:lastUrlStr]];
    [_bannersScrollView addSubview:lastImgView];
    
    [self createTapGestureRecognizerWithImageView:lastImgView withIndex:0];
    

}

/** 添加点击方法 */
- (void) createTapGestureRecognizerWithImageView: (UIImageView *)imgView withIndex: (NSInteger)index{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouch:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imgView addGestureRecognizer:tap];
    imgView.userInteractionEnabled = YES;
    
    NSString *firstCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstCount"];
    if ([firstCount isEqualToString:@"YES"]) {
        NSInteger count = 0;
        NSString *page = [NSString stringWithFormat:@"%ld", _pageControl.currentPage];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:page];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"firstCount"];
    }

}


- (void) imageTouch: (UITapGestureRecognizer *)tap{
    
    if (self.imageTouchBlock != nil) {
        self.imageTouchBlock(_pageControl.currentPage);
    }
    NSString *page = [NSString stringWithFormat:@"%ld", _pageControl.currentPage];
    NSInteger count = [[[NSUserDefaults standardUserDefaults] objectForKey:page] integerValue];
    count++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:count] forKey:page];
    
}

- (void) printCountWithPage: (NSInteger) page {
    NSString *pCount = [NSString stringWithFormat:@"%ld", page];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:pCount]);
}


/** 结束回弹令ScrollView位置偏移 */
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat xOffset = _bannersScrollView.contentOffset.x;
    if (xOffset == 0) {
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH * _imgArr.count, 0);
    }if (xOffset == SELF_WIDTH * (_imgArr.count+1)) {
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);
    }
    
    _pageControl.currentPage = _bannersScrollView.contentOffset.x/ SELF_WIDTH - 1;
}

#pragma mark - Page

- (void) initPageControlWithFrame: (CGRect)frame{
    self.pageControl = [[UIPageControl alloc] initWithFrame:frame];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _imgArr.count;
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:61/255.0 green:179/255.0 blue:239/255.0 alpha:0.7];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
}

- (void) pageAction: (UIPageControl *) pageControl{
    [_bannersScrollView setContentOffset:CGPointMake((_pageControl.currentPage + 1) * SELF_WIDTH, 0) animated:YES];
}


- (void) initPageControlWithCenter{
    [self initPageControlWithFrame:CGRectMake(SELF_WIDTH / 2 - 100, SELF_HEIGHT - 20, 200, 20)];
}


#pragma mark - NSTimer
- (void) initNSTimerWithSecond: (CGFloat) second{

    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    }
}

- (void) timeAction: (NSTimer *) timer{
    CGFloat xOffset = _bannersScrollView.contentOffset.x;
    [_bannersScrollView setContentOffset:CGPointMake(xOffset+ SELF_WIDTH, 0) animated:YES];
    if (xOffset == SELF_WIDTH * (_imgArr.count + 1)) {
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);
    }
    else if (xOffset == 0){
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH * _imgArr.count, 0);
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xOffset = _bannersScrollView.contentOffset.x;
    if (xOffset == 0) {
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH * _imgArr.count, 0);
    }if (xOffset == SELF_WIDTH * (_imgArr.count +1)) {
        _bannersScrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);
        _pageControl.currentPage = 0;
    }else{
    _pageControl.currentPage = xOffset/ SELF_WIDTH - 1;
    }
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
