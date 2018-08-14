//
//  ViewController.m
//  PhotoBrowseDemo
//
//  Created by 冯琦帆 on 2018/8/9.
//  Copyright © 2018年 冯琦帆. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBrowseViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)browsePhoto:(id)sender {
  UIImage* image = [UIImage imageNamed:@"1.jpg"];
  PhotoBrowseViewController* controller = [[PhotoBrowseViewController alloc] initWithImage:image lastPageFrame:self.imageView.frame];
  controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
  controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:controller animated:true completion:nil];
}

@end
