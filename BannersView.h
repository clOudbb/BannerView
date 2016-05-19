//
//  BannersView.h
//  BiliBili
//
//  Created by 张征鸿 on 16/3/18.
//  Copyright © 2016年 张征鸿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannersView : UIView

#warning 使用该封装需要在CoCoaPods里引入AFNetWorking，SDWebImage


/** 注意数组内只能是String类型 */
+ (BannersView *) initWithFrame: (CGRect)frame withURLArray:(NSMutableArray *)array;

/** 创建page 自定义位置 */
- (void) initPageControlWithFrame: (CGRect)frame;

/** 创建page 自动位于轮播图下方中央位置 */
- (void) initPageControlWithCenter;

/** 设置定时器自动滚动 */
- (void) initNSTimerWithSecond: (CGFloat) second;

/** 点击图片时调用，返回点击图片的序数 */
@property (nonatomic, copy) void (^imageTouchBlock)(NSInteger);

#warning block中需要将本类弱引用否则会循环引用
/** Block中调用，可以打印某张图片被点击次数 */
- (void) printCountWithPage: (NSInteger) page;

@end
