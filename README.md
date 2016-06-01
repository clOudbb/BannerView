#个人封装简单的Demo  可自定义page位置

具体方法在.h中有详细说明

使用方法如下
        
self.bannersView = [BannersView initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 4) withURLArray:_imgArr];
[_bannersView initPageControlWithFrame:CGRectMake(0, 0, 200, 20)];   //自定义位置
[_bannersView initPageControlWithCenter];                             //默认直接居中
[_bannersView initNSTimerWithSecond:3.0];                          
        
__weak typeof(_bannersView)wBanners = _bannersView;
_bannersView.imageTouchBlock = ^(NSInteger index){
   [wBanners printCountWithPage:0];
};
[self.view addSubview:_bannersView];
