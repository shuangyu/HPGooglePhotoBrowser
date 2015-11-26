//
//  HPPhotoBrowserAnimation.m
//  PreviewDemo
//
//  Created by hupeng on 15/7/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "HPPhotoBrowserAnimation.h"
#import "HPTransitionView.h"

@interface HPPhotoBrowserAnimation ()
{
    id<UIViewControllerContextTransitioning> _context;
    UINavigationController *_navigationController;
    HPTransitionView *_transitioningView;
    CGPoint _originalCenter;
    int _maxDistance;
}

@end

@implementation HPPhotoBrowserAnimation

- (instancetype)initWithNavigationController:(UINavigationController *)controller
{
    self = [super init];
    if (self) {
        _navigationController = controller;
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return self;
}

- (void)setViewForInteraction:(UIView *)viewForInteraction
{
    if (_viewForInteraction && [_viewForInteraction.gestureRecognizers containsObject:_panGesture]) {
        [_viewForInteraction removeGestureRecognizer:_panGesture];
    }
    
    _viewForInteraction = viewForInteraction;
    [_viewForInteraction addGestureRecognizer:_panGesture];
    _maxDistance = sqrtf(powf(CGRectGetHeight(_viewForInteraction.bounds), 2) + powf(CGRectGetWidth(_viewForInteraction.bounds), 2));
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:_viewForInteraction];
    float distance = sqrtf(powf(translation.x, 2) + powf(translation.y, 2));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _originalCenter = _viewForInteraction.center;
            self.interactive = YES;
            [_navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            
            _transitioningView.imageView.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y + translation.y);
            CGFloat percent = MIN(1.0, distance/_maxDistance * 2.0);
            CGFloat scale   = MAX(0.9, 1.0 - percent);
            _transitioningView.imageView.transform = CGAffineTransformMakeScale(scale, scale);
            _transitioningView.maskView.alpha = MAX(0, 1.0 - 2 * percent);
            
            [_context updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint velocityPoint = [pan velocityInView:_viewForInteraction];
            CGFloat percent  = MIN(1.0, distance/_maxDistance * 2.0);
            CGFloat velocity = sqrtf(powf(velocityPoint.x, 2) + powf(velocityPoint.y, 2));
            BOOL cancelled = percent <= 0.5 && velocity < 500.0;
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CGPoint velocityPoint = [pan velocityInView:_viewForInteraction];
            CGFloat percent = MIN(1.0, distance/_maxDistance * 2.0);
            CGFloat velocity = sqrtf(powf(velocityPoint.x, 2) + powf(velocityPoint.y, 2));
            BOOL cancelled = percent <= 0.5 && velocity < 500.0;
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

- (void)end:(BOOL)cancelled
{
    NSTimeInterval animationDuration = [self transitionDuration:_context];
    
    UIViewController *fromViewController = [_context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [_context viewControllerForKey:UITransitionContextToViewControllerKey];
    if (cancelled) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _transitioningView.imageView.center = _originalCenter;
            _transitioningView.imageView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [_context cancelInteractiveTransition];
            [_context completeTransition:NO];
            [_transitioningView removeFromSuperview];
            fromViewController.view.alpha = 1.0;
        }];
    } else {
        CGRect frame = [_transitioningView convertRect:_fromRect fromView:toViewController.view];
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _transitioningView.imageView.frame = frame;
        } completion:^(BOOL finished) {
            [_transitioningView removeFromSuperview];
            [_context finishInteractiveTransition];
            [_context completeTransition:YES];
        }];
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    
    if (self.type == HPPhotoBrowserAnimationTypePresent) {
        
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        toViewController.view.alpha = 0.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_fromRect];
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        imageView.image         = _imageForInteraction;
        [containerView addSubview:imageView];
        
        CGRect toFrame  = AVMakeRectWithAspectRatioInsideRect(_imageForInteraction.size, fromViewController.view.bounds);
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            imageView.frame = toFrame;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [imageView removeFromSuperview];
            toViewController.view.alpha = 1.0;
        }];
        
    } else if (self.type == HPPhotoBrowserAnimationTypeDismiss) {
        
        //Add 'to' view to the hierarchy
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        if (!_imageForInteraction) {
            [transitionContext completeTransition:YES];
            return;
        }
        
        CGRect frame  = AVMakeRectWithAspectRatioInsideRect(_imageForInteraction.size, fromViewController.view.bounds);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode   = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        imageView.image         = _imageForInteraction;
        [containerView addSubview:imageView];
        
        fromViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            imageView.frame = _fromRect;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

-(void)animationEnded:(BOOL)transitionCompleted
{
    self.interactive = NO;
}

#pragma mark - Interactive Transitioning

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    _context = transitionContext;
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    fromViewController.view.alpha = 0.0;
    
    CGRect frame  = AVMakeRectWithAspectRatioInsideRect(_imageForInteraction.size, fromViewController.view.bounds);
    
    // set up transition view
    _transitioningView = [HPTransitionView loadNibForCurrentDevice];
    _transitioningView.frame = fromViewController.view.bounds;
    _transitioningView.maskView.backgroundColor = fromViewController.view.backgroundColor;
    _transitioningView.imageView.frame          = frame;
    _transitioningView.imageView.contentMode    = UIViewContentModeScaleAspectFill;
    _transitioningView.imageView.clipsToBounds  = TRUE;
    _transitioningView.imageView.image          = _imageForInteraction;
    [containerView addSubview:_transitioningView];
}

@end
