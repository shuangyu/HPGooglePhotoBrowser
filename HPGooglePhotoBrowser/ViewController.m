//
//  ViewController.m
//  PreviewDemo
//
//  Created by hupeng on 15/7/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "ImageViewController.h"
#import "HPPhotoBrowserAnimation.h"
#import "HPPhotoBrowserViewContorller.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
{
    NSInteger _index;
    NSArray *_dataSource;
    // params for animation
    HPPhotoBrowserAnimation *_animation;
    UIImage *_imageForInteraction;
    CGRect _fromRect;
}

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    _animation = [[HPPhotoBrowserAnimation alloc] initWithNavigationController:self.navigationController];
    
    
    _dataSource = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openBrowserPage"]) {
        HPPhotoBrowserViewContorller *dvc = segue.destinationViewController;
        dvc.currentIndex = _index;
        dvc.dataSource   = _dataSource;
        _animation.viewForInteraction = dvc.view;
        
    }
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_dataSource[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _fromRect = [self.view convertRect:cell.frame fromView:collectionView];
    _imageForInteraction = cell.imageView.image;
    [self performSegueWithIdentifier:@"openBrowserPage" sender:self];
}

#pragma mark - Navigation Controller Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            _animation.type     = HPPhotoBrowserAnimationTypePresent;
            _animation.fromRect = _fromRect;
            _animation.imageForInteraction = _imageForInteraction;
            return  _animation;
        case UINavigationControllerOperationPop: {
            HPPhotoBrowserViewContorller *browserVC = (HPPhotoBrowserViewContorller *)fromVC;
            ImageViewController *mediaVC = browserVC.currentMediaViewController;
            UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:mediaVC.pageIndex inSection:0]];
            
            _fromRect = [self.view convertRect:cell.frame fromView:_collectionView];
            _animation.type     = HPPhotoBrowserAnimationTypeDismiss;
            _animation.fromRect = _fromRect;
            _animation.imageForInteraction = mediaVC.presentImage;
            return _animation;
        }
        default:
            return nil;
    }
}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[HPPhotoBrowserAnimation class]]) {
        HPPhotoBrowserAnimation *controller = (HPPhotoBrowserAnimation *)animationController;
        if (controller.isInteractive) {
            return controller;
        }
        else {
           return nil;
        }
        
    } else {
        return nil;
    }
}


@end
