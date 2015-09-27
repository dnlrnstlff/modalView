//
//  DELPopupView.h
//  Modal Popover
//
//  Created by Daniel-Ernest Luff on 27/09/15
//  Copyright (c) 2015 Toutright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DELPopupView : UIView

@property (nonatomic, strong) UIView *handleView;
+ (DELPopupView *)popupView;
- (void)show;
- (void)hideAnimated:(BOOL)animated;
- (void)willRotateToOrientation:(UIInterfaceOrientation) toInterfaceOrientation withDuration:(NSTimeInterval)duration;
@end
