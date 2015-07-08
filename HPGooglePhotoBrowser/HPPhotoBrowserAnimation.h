//
//  HPPhotoBrowserAnimation.h
//  PreviewDemo
//
//  Created by hupeng on 15/7/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
    HPPhotoBrowserAnimationTypePresent,
    HPPhotoBrowserAnimationTypeDismiss
} HPPhotoBrowserAnimationType;

@interface HPPhotoBrowserAnimation : NSObject <UIViewControllerAnimatedTransitioning ,UIViewControllerInteractiveTransitioning>

- (instancetype)initWithNavigationController:(UINavigationController *)controller;

@property (nonatomic, assign, getter = isInteractive) BOOL interactive;
@property (nonatomic, assign) HPPhotoBrowserAnimationType type;
@property (nonatomic, strong) UIView *viewForInteraction;
@property (nonatomic, strong) UIImage *imageForInteraction;
@property (nonatomic, assign) CGRect fromRect;

@end
