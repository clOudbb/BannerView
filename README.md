#支持自定义动画效果的Banner  可自定义page位置
<text width = "50px" heigth = "30px" background = "orange"></text>

新增各种动画效果，提升个性化! 具体动画类型在.h中有详细介绍
一句话调用，你值得拥有

<img src="http://ww4.sinaimg.cn/large/005Duxwwgw1f4o1n8tjltg30ac05lb2a.gif" width="50%" height="50%">

使用方法如下
        
        self.bannersView = [BannersView initWithFrame:CGRect withURLArray:self.bannerArr animationType:kTransitionRippleEffect];
        [_bannersView initPageControlWithCenter];
        [_bannersView initNSTimerWithSecond:3.0f];
        
        __weak typeof(_bannersView)wBanners = _bannersView;
        _bannersView.imageTouchBlock = ^(NSInteger index){
            [wBanners printCountWithPage:0];
        };
        [self.view addSubview:_bannersView];
