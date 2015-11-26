//
//  ImageViewController.h
//  PreviewDemo
//
//  Created by hupeng on 15/7/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, assign) NSInteger pageIndex;
// used for preview animation
@property (nonatomic, strong) UIImage *presentImage;

@end
