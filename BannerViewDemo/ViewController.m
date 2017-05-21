//
//  ViewController.m
//  BannerViewDemo
//
//  Created by 张征鸿 on 2017/5/21.
//  Copyright © 2017年 张征鸿. All rights reserved.
//

#import "ViewController.h"
#import "BannersView.h"
#import <AFNetworking.h>

@interface ViewController ()

@property (nullable, nonatomic, strong) BannersView *banner;

@property (nullable, nonatomic, copy) NSMutableArray *imgArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self dataHandle];
}

- (void)dataHandle
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak __typeof__(self)weakSelf = self;
    [manager GET:@"http://mobile.ximalaya.com/mobile/discovery/v1/recommends?channel=ios-b1&device=iPhone&includeActivity=true&includeSpecial=true&scale=2&version=4.3.26" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong __typeof__(weakSelf)strongSelf = weakSelf;
        for (NSDictionary *dic in responseObject[@"focusImages"][@"list"]) {
            NSString *str = dic[@"pic"];
            [strongSelf.imgArr addObject:str];
        }
        
        if (strongSelf.imgArr.count == 0) {
            return ;
        }
        strongSelf.banner = [BannersView initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 4) withURLArray:_imgArr animationType:kTransitionRippleEffect];
        //        [_bannersView initPageControlWithFrame:CGRectMake(0, 0, 200, 20)];
        [strongSelf.banner initPageControlWithCenter];
        [strongSelf.banner initNSTimerWithSecond:3.0];
        [strongSelf.view addSubview:strongSelf.banner];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSMutableArray *)imgArr
{
    if (!_imgArr) {
        _imgArr = [@[] mutableCopy];
    }
    return _imgArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
