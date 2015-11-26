//
//  HPTransitionView.h
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/7/28.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTransitionView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *maskView;

@end

@interface UIView (ViewExt)

- (UIImage *)toImage;

+ (instancetype)loadNibNamed:(NSString *)name;

+ (instancetype)loadNibForCurrentDevice;

@end
