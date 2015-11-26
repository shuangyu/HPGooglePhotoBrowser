//
//  HPPhotoBrowserViewContorller.h
//  PreviewDemo
//
//  Created by hupeng on 15/7/6.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageViewController;

@interface HPPhotoBrowserViewContorller : UIViewController

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) ImageViewController *currentMediaViewController;

@end
