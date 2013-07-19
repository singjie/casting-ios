//
//  CAImageCache.h
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAImageCache : NSCache

+ (CAImageCache *)sharedInstance;

- (void)setData:(NSData *)data forURL:(NSString *)url;
- (void)setImage:(UIImage *)image forURL:(NSString *)url;
- (UIImage *)imageForURL:(NSString *)url;

@end
