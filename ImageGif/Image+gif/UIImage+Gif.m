//
//  UIImage+Gif.m
//  ImageGif
//
//  Created by yangsen on 17/2/13.
//  Copyright © 2017年 sitemap. All rights reserved.
//

#import "UIImage+Gif.h"
#import <ImageIO/ImageIO.h>
#import <CommonCrypto/CommonDigest.h>

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#define ARCCompatibleAutorelease(object) object
#else
#define toCF (CFTypeRef)
#define ARCCompatibleAutorelease(object) [object autorelease]
#endif

@implementation UIImage (Gif)

+ (UIImage *)ys_gifImageSource:(CGImageSourceRef)source
                   andDuration:(NSTimeInterval)duration{
    if (!source) return nil;
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray *images = [NSMutableArray array];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return nil;
        UIImage *gifImage = [UIImage imageWithCGImage:cgImage];
        [images addObject:gifImage];
        CGImageRelease(cgImage);
    }
    return [self ys_gifImageWithImages:images duration:duration];
}

+ (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration=0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes
                                                                        length:3]
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    return duration/100;
}

//显示本地gif图

+ (UIImage *)ys_gifImageWithData:(NSData *)data{
    if (data.length < 1) {
        return nil;
    }
    CGFloat duration = [self durationForGifData:data];
    
    CGImageSourceRef source = CGImageSourceCreateWithData(toCF data, NULL);
    return [self ys_gifImageSource:source andDuration:duration];
}

//显示网络gif图
+ (void)ys_gifImageWithURL:(NSURL *)url complete:(ImageRequestFinished)complete{
    dispatch_async(dispatch_queue_create("com.image.get", DISPATCH_QUEUE_CONCURRENT), ^{
        NSData *data   = [NSData dataWithContentsOfURL:url];
        UIImage *image = [self ys_gifImageWithData:data];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(image);
            }
        });
    });
}

+ (UIImage *)ys_imageNamed:(NSString *)imageName{

    NSArray *nameArr = [imageName componentsSeparatedByString:@"."];
    if (nameArr.count == 1) {
        return [UIImage imageNamed:imageName];
    }
    NSString *type = nameArr.lastObject;
    if ([type isEqualToString:@"gif"]) {
        UIImage *image = [self ys_gifImageWithData:[self getDataWithNameFromBundle:imageName]];
        return image;
    }
    else{
        return [UIImage imageNamed:imageName];
    }
}

+ (UIImage *)ys_gifImageWithImages:(NSArray <UIImage *> *)images duration:(CGFloat)duration{

    return [UIImage animatedImageWithImages:images duration:duration];
}

+ (NSData *)getDataWithNameFromBundle:(NSString *)name{
    if (name.length) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        if (path) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
            return data;
        }
    }
    return nil;
}


@end
