//
//  UIViewController+ControllerKit.h
//  snapgrab
//
//  Created by hupeng on 14-10-30.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ControllerExt)

- (UIViewController *)topestController;

+ (id)loadFromStoryboard;

- (UIViewController *)visibleViewController;

- (UIViewController *)rootViewcontroller;

@end
