//
//  HPPhotoBrowserViewContorller.m
//  PreviewDemo
//
//  Created by hupeng on 15/7/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPPhotoBrowserViewContorller.h"
#import "UIViewController+ControllerExt.h"
#import "ImageViewController.h"

@interface HPPhotoBrowserViewContorller ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITabBarDelegate> {
     UIPageViewController *_pageViewController;
}
@end

@implementation HPPhotoBrowserViewContorller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPageController];
}

- (void)initPageController
{
    CGFloat spacing = 30.f;
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{ UIPageViewControllerOptionInterPageSpacingKey : @(spacing)}];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    _pageViewController.automaticallyAdjustsScrollViewInsets = NO;
    [self addChildViewController:_pageViewController];
    [self.view insertSubview:_pageViewController.view atIndex:0];
    
    ImageViewController *selectedViewController = [self mediaViewControllerAtIndex:_currentIndex];
    _currentMediaViewController = selectedViewController;
    [_pageViewController setViewControllers:@[selectedViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (NSUInteger)validPageIndex:(NSInteger)pageIndex
{
    NSUInteger validIndex = pageIndex;
    NSUInteger count = _dataSource.count;
    
    if (pageIndex < 0) {
        validIndex = count - (-pageIndex)%count;
    }
    if (pageIndex >= count) {
        validIndex = pageIndex%count;
    }
    return validIndex;
}

- (ImageViewController *)mediaViewControllerAtIndex:(NSInteger)index
{
    index = [self validPageIndex:index];
    ImageViewController *viewController = [ImageViewController loadFromStoryboard];
    viewController.pageIndex = index;
    viewController.presentImage = [UIImage imageNamed:_dataSource[index]];
    
    return viewController;
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    return [self mediaViewControllerAtIndex:_currentIndex - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    return [self mediaViewControllerAtIndex:_currentIndex + 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    _currentMediaViewController = pageViewController.viewControllers.firstObject;
    _currentIndex = [_currentMediaViewController pageIndex];
}


@end
