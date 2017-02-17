//
//  ViewController.m
//  ImageGif
//
//  Created by yangsen on 17/2/13.
//  Copyright © 2017年 sitemap. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Gif.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){{100,100},{50,50}}];
    [self.view addSubview:imageView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"abc.gif" ofType:nil];
    [UIImage ys_gifImageWithURL:[NSURL fileURLWithPath:path] complete:^(UIImage *image) {
        imageView.image = image;
    }];
}




@end
