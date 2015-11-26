//
//  UIViewController+ControllerKit.m
//  snapgrab
//
//  Created by hupeng on 14-10-30.
//  Copyright (c) 2014年 Hu Peng. All rights reserved.
//

#import "UIViewController+ControllerExt.h"

@implementation UIViewController (ControllerExt)

- (UIViewController *)topestController
{
    UIViewController *topViewController = self;
    
    while (1) {
        
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
            continue;
        }
        
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = ((UITabBarController *)topViewController).selectedViewController;
            continue;
        }
        
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
            continue;
        }
        
        break;
    }
    return topViewController;
}

+ (id)loadFromStoryboard
{
    NSString *sbName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
    return [[UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}


- (UIViewController *)visibleViewController
{
    UIViewController *topViewController = self;
    
    while (1) {
        
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = ((UITabBarController *)topViewController).selectedViewController;
            continue;
        }
        
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
            continue;
        }
        
        break;
    }
    return topViewController;
}

- (UIViewController *)rootViewcontroller
{
    return self.navigationController ? self.navigationController : self;
}

@end
