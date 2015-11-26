//
//  HPTransitionView.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/7/28.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPTransitionView.h"

@implementation HPTransitionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation UIView (ViewExt)

- (UIImage *)toImage
{
    float scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)loadNibNamed:(NSString *)name
{
    return [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil][0];
}

+ (instancetype)loadNibForCurrentDevice
{
    NSString *nibName = NSStringFromClass([self class]);
    
    int width = CGRectGetWidth([UIScreen mainScreen].bounds);
    int height = CGRectGetHeight([UIScreen mainScreen].bounds);
    
    
    if (width > height) {
        width += height;
        height = width - height;
        width -= height;
    }
    
    NSString *preferNibName = [NSString stringWithFormat:@"%@_%d_%d", nibName, width, height];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:preferNibName ofType:@"nib"];
    
    if (filePath) {
        nibName = preferNibName;
    } else {
        preferNibName = [NSString stringWithFormat:@"%@_%d", nibName, width];
        filePath = [[NSBundle mainBundle] pathForResource:preferNibName ofType:@"nib"];
        
        if (filePath) {
            nibName = preferNibName;
        }
    }
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil][0];
}
@end
