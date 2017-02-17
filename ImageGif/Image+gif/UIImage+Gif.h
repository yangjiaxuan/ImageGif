//
//  UIImage+Gif.h
//  ImageGif
//
//  Created by yangsen on 17/2/13.
//  Copyright © 2017年 sitemap. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ImageRequestFinished)(UIImage *image);
@interface UIImage (Gif)

//显示本地gif图
+ (UIImage *)ys_gifImageWithData:(NSData *)data;

//显示网络gif图
+ (void)ys_gifImageWithURL:(NSURL *)url complete:(ImageRequestFinished)complete;

+ (UIImage *)ys_imageNamed:(NSString *)imageName;

@end
