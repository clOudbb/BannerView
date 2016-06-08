#个人封装简单的Demo  可自定义page位置

新增各种动画效果，提升个性化! 具体动画类型在.h中有详细介绍

使用方法如下
        
        self.bannersView = [BannersView initWithFrame:CGRect withURLArray:self.bannerArr animationType:kTransitionRippleEffect];
        [_bannersView initPageControlWithCenter];
        [_bannersView initNSTimerWithSecond:3.0f];
        
        __weak typeof(_bannersView)wBanners = _bannersView;
        _bannersView.imageTouchBlock = ^(NSInteger index){
            [wBanners printCountWithPage:0];
        };
        [self.view addSubview:_bannersView];
