//
//  PhotoBrowseViewController.h
//  TestForImageView
//
//  Created by 冯琦帆 on 15/12/16.
//  Copyright © 2015年 Joy Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowseViewController : UIViewController

- (instancetype)initWithImage:(UIImage*)image lastPageFrame:(CGRect)imageFrame;

@property(strong, nonatomic) UIImage* photo;
@property(assign, nonatomic) CGRect photoOrginFrame;

@end
