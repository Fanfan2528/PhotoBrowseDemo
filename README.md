# PhotoBrowseDemo
A photo browse control, contain following functions: double tap to enlarge or reduce the photo, scroll the photo 

#一、功能介绍
1. 用户点击图片进入图片浏览模式，控件会自动计算图片将顶宽显示还是顶长显示。
2. 进入图片浏览模式之后，双指和双击都有放大/缩小图片的功能。
3. 单击图片退出图片浏览模式。

#二、如何用
1. 将“PhotoBrowseController.h”, “PhotoBrowseController.m”, “PhotoBrowseController.xib”拖入项目
2. 在触发图片浏览模式的地方加入如下代码：
```
PhotoBrowseViewController* controller = [[PhotoBrowseViewController alloc] initWithImage:image lastPageFrame:self.imageView.frame];
```
3. image代表传入的图片；
4. lastPageFrame是图片在当前UIViewController显示的UIView中对应的frame;
5. 设置controller的present模式，推荐使用如下代码：
```
controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
[self presentViewController:controller animated:true completion:nil];
```
