//
//  DELPopupView.m
//  Modal Popover
//
//  Created by Daniel-Ernest Luff on 27/09/15
//  Copyright (c) 2015 Toutright. All rights reserved.
//

#import "DELPopupView.h"
#import <QuartzCore/QuartzCore.h>

static float const HANDLE_VIEW_ANIMATION_DUTARION = 0.2;
//static float const ROOT_VIEW_SCALE_FACTOR = 0.9;

@interface DELPopupView ()

@property (nonatomic, strong) UIView *blackTransparentView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIImageView *renderImageView;
@end

@implementation DELPopupView

- (instancetype)init{
    return [DELPopupView popupView];
}

+ (DELPopupView *)popupView{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = keyWindow.rootViewController.view;
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    if(rootView.transform.b != 0 && rootView.transform.c != 0)
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    DELPopupView *v = [[DELPopupView alloc] initWithFrame:rect];
    v.handleView = [[UIView alloc] initWithFrame:v.frame];
    v.handleView.backgroundColor = [UIColor clearColor];
    v.handleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    v.handleView.clipsToBounds = YES;
    
    v.blackTransparentView = [[UIView alloc] initWithFrame:v.frame];
    v.blackTransparentView.backgroundColor = [UIColor blackColor];
    v.blackTransparentView.alpha = 0.0;
    
    v.renderImageView = [[UIImageView alloc] initWithFrame:v.frame];
    v.renderImageView.contentMode = UIViewContentModeScaleToFill;
    [v addSubview:v.renderImageView];
    [v addSubview:v.blackTransparentView];
    [v addSubview:v.handleView];
    return v;
}

- (void)show{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *ctrl = keyWindow.rootViewController;
    while (ctrl.presentedViewController) {
        ctrl = ctrl.presentedViewController;
    }
    UIView *rootView = ctrl.view;
    
    CGRect rect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height);
    if(rootView.transform.b != 0 && rootView.transform.c != 0)
        rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width);
    self.frame = rect;
    
    //Performing selector after delay just for let UIButton change state from Highlighted before render View
    [self performSelector:@selector(showInNextRunLoop) withObject:nil afterDelay:0.1];
}

- (void)showInNextRunLoop{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *ctrl = keyWindow.rootViewController;
    while (ctrl.presentedViewController) {
        ctrl = ctrl.presentedViewController;
    }
    UIView *rootView = ctrl.view;
    
    UIImage *rootViewRenderImage = [self imageWithView:rootView];
    self.renderImageView.image = rootViewRenderImage;
    
    self.blackTransparentView.alpha = 0.0;
    [rootView addSubview:self];
    self.handleView.center = CGPointMake(self.frame.size.width/2.0, self.handleView.frame.size.height * 1.5);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.blackTransparentView.alpha = 0.4;
                                            }
                     completion:^(BOOL finished) {
                     }];
    [UIView animateWithDuration:HANDLE_VIEW_ANIMATION_DUTARION delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.handleView.center = self.center;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

- (void)hideAnimated:(BOOL)animated{
    if(!animated){
        self.blackTransparentView.alpha = 0.0;
        self.renderImageView.frame = self.frame;
        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:HANDLE_VIEW_ANIMATION_DUTARION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.handleView.center = CGPointMake(self.frame.size.width/2.0, self.handleView.frame.size.height * 1.5);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.blackTransparentView.alpha = 0.0;
                         self.renderImageView.frame = self.frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)willRotateToOrientation:(UIInterfaceOrientation) toInterfaceOrientation withDuration:(NSTimeInterval)duration{
    if(self.superview){
        [self removeFromSuperview];
        self.renderImageView.frame = self.frame;
        [self performSelector:@selector(showAgain) withObject:nil afterDelay:duration];
    }
}

- (void)showAgain{
    [self show];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(self.renderImageView.frame.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)dealloc{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
