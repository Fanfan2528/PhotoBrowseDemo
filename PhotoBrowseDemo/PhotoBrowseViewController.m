//
//  PhotoBrowseViewController.m
//  TestForImageView
//
//  Created by 冯琦帆 on 15/12/16.
//  Copyright © 2015年 Joy Feng. All rights reserved.
//

#import "PhotoBrowseViewController.h"

@interface PhotoBrowseViewController ()<UIScrollViewDelegate> {
  float targetX;
  float targetY;
  float targetWidth;
  float targetHeight;
  float photoWidth;
  float photoHeight;
}

@property(weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property(strong, nonatomic) UIImageView* photoImageView;

@property(assign, nonatomic) BOOL viewDidAppear;

@end

@implementation PhotoBrowseViewController

- (instancetype)initWithImage:(UIImage*)image lastPageFrame:(CGRect)imageFrame {
  self = [super init];
  self.photo = image;
  self.photoOrginFrame = imageFrame;
  return self;
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(doubleTapEvent:)];
  doubleTapGesture.numberOfTapsRequired = 2;
  doubleTapGesture.cancelsTouchesInView = NO;
  [self.scrollView addGestureRecognizer:doubleTapGesture];

  UITapGestureRecognizer* oneTapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(oneTapEvent)];
  oneTapGesture.cancelsTouchesInView = NO;
  [self.scrollView addGestureRecognizer:oneTapGesture];

  self.scrollView.decelerationRate = 0;
  self.scrollView.minimumZoomScale = 1.0;
  self.scrollView.delegate = self;
  self.scrollView.showsHorizontalScrollIndicator = NO;
  self.scrollView.showsVerticalScrollIndicator = NO;

  self.photoImageView =
      [[UIImageView alloc] initWithFrame:self.photoOrginFrame];
  self.scrollView.contentSize = self.photoImageView.frame.size;
  self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
  self.photoImageView.clipsToBounds = YES;

  [self.scrollView addSubview:self.photoImageView];
  self.photoImageView.image = self.photo;

  [self.scrollView.panGestureRecognizer
      requireGestureRecognizerToFail:doubleTapGesture];
  [self.scrollView.pinchGestureRecognizer
      requireGestureRecognizerToFail:doubleTapGesture];
  [self.scrollView.panGestureRecognizer
      requireGestureRecognizerToFail:oneTapGesture];
  [self.scrollView.pinchGestureRecognizer
      requireGestureRecognizerToFail:oneTapGesture];
  [oneTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.navigationController setNavigationBarHidden:YES];
  if (!self.viewDidAppear) {
    [self showPhoto];
    self.viewDidAppear = YES;
  }
}

- (void)showPhoto {
  photoWidth = self.photo.size.width;
  photoHeight = self.photo.size.height;
  if ([UIScreen mainScreen].bounds.size.height /
          [UIScreen mainScreen].bounds.size.width >=
      photoHeight / photoWidth) {
    targetX = 0;
    targetWidth = [UIScreen mainScreen].bounds.size.width;
    targetHeight =
        [UIScreen mainScreen].bounds.size.width / photoWidth * photoHeight;
    targetY = ([UIScreen mainScreen].bounds.size.height - targetHeight) / 2;
    self.scrollView.maximumZoomScale = 2;
  } else {
    targetY = 0;
    targetWidth =
        [UIScreen mainScreen].bounds.size.height / photoHeight * photoWidth;
    targetHeight = [UIScreen mainScreen].bounds.size.height;
    targetX = ([UIScreen mainScreen].bounds.size.width - targetWidth) / 2;
    self.scrollView.maximumZoomScale =
        MAX([UIScreen mainScreen].bounds.size.width / targetWidth, 2);
  }
  [self zoomPhotoToScreen];
}

- (void)zoomPhotoToScreen {
  [UIView animateWithDuration:0.25
                   animations:^{
                     self.scrollView.zoomScale = 1.0;
                     self.photoImageView.frame =
                     CGRectMake(0, 0, self->targetWidth, self->targetHeight);
                     self.scrollView.contentInset =
                         UIEdgeInsetsMake(self->targetY, self->targetX, self->targetY, self->targetX);
                     self.scrollView.contentOffset =
                         CGPointMake(-self->targetX, -self->targetY);
                     self.scrollView.backgroundColor = [UIColor blackColor];
                   }];
}

- (void)oneTapEvent {
  self.scrollView.zoomScale = 1.0;
  self.scrollView.userInteractionEnabled = NO;
//  [[UIApplication sharedApplication]
//      setStatusBarHidden:NO
//           withAnimation:UIStatusBarAnimationNone];
  [UIView animateWithDuration:0.25
      animations:^{
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.photoImageView.frame = self.photoOrginFrame;
        self.scrollView.backgroundColor = [UIColor clearColor];
      }
      completion:^(BOOL finished) {
        [self cancelWithAnimated:NO];
      }];
}

- (void)cancelWithAnimated:(BOOL)animated {
  [self.view endEditing:YES];
  if (self.presentingViewController != nil) {
    UIStatusBarStyle statusBarStyle = UIStatusBarStyleDefault;
    if ([self.presentingViewController
         isKindOfClass:[UINavigationController class]]) {
      statusBarStyle = [[[(UINavigationController*)
                          self.presentingViewController viewControllers]
                         lastObject] preferredStatusBarStyle];
    } else {
      statusBarStyle = self.presentingViewController.preferredStatusBarStyle;
    }
    [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
  }
  [self dismissViewControllerAnimated:animated completion:nil];
}

- (void)doubleTapEvent:(UITapGestureRecognizer*)tap {
  if (self.scrollView.zoomScale > 1.5) {
    [self zoomPhotoToScreen];
  } else {
    CGRect rect =
        [self zoomRectForScale:self.scrollView.maximumZoomScale
                    withCenter:[tap locationInView:self.photoImageView]];
    [self.scrollView zoomToRect:rect animated:YES];
  }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
  CGRect zoomRect;
  zoomRect.size.height = self.scrollView.frame.size.height / scale;
  zoomRect.size.width = self.scrollView.frame.size.width / scale;
  zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
  zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
  return zoomRect;
}

- (void)scrollViewDidZoom:(UIScrollView*)scrollView {
  float top = MAX(([UIScreen mainScreen].bounds.size.height -
                   targetHeight * scrollView.zoomScale) /
                      2,
                  0);
  float left = MAX(([UIScreen mainScreen].bounds.size.width -
                    targetWidth * scrollView.zoomScale) /
                       2,
                   0);
  self.scrollView.contentInset = UIEdgeInsetsMake(top, left, top, left);
  self.scrollView.contentSize = CGSizeMake(targetWidth * scrollView.zoomScale,
                                           targetHeight * scrollView.zoomScale);
}


@end
