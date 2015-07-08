//
//  ImageViewController.m
//  PreviewDemo
//
//  Created by hupeng on 15/7/7.
//  Copyright (c) 2015年 hupeng. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageView.image = _presentImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
