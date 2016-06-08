//
//  BannersView.h
//  BiliBili
//
//  Created by 张征鸿 on 16/3/18.
//  Copyright © 2016年 张征鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, AnimationType){
    kTransitionFade = 0,              /**< 淡入淡出 */
    kTransitionPush,                    /**< 推进效果 */
    kTransitionReveal,                 /**< 揭开效果 */
    kTransitionMoveIn,               /**< 慢慢进入并覆盖效果 */
    kTransitionCube,                   /**< 立体翻转效果 */
    kTransitionSuckEffect,         /**< 像被吸入瓶子的效果 */
    kTransitionRippleEffect,      /**< 波纹效果 */
    kTransitionPageCurl,            /**< 翻页效果 */
    kTransitionPageUnCurl,       /**< 反翻页效果 */
    kTransitionCameraOpen,     /**< 开镜头效果 */
    kTransitionCameraClose,     /**< 关镜头效果 */
    kTransitionOglFlip,                /**< 翻转 */
    kTransitionNone
};
@interface BannersView : UIView

#warning 使用该封装需要在CoCoaPods里引入AFNetWorking，SDWebImage


/** 注意数组内只能是String类型 */
+ (BannersView *) initWithFrame: (CGRect)frame withURLArray:(NSMutableArray *)array animationType:(AnimationType)type;
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
