//
//  CAImageCache.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CAImageCache.h"

#import "SJFileManager.h"

#import "NSData+SSToolkitAdditions.h"
#import "NSString+SSToolkitAdditions.h"

@interface CAImageCache ()

@property (nonatomic, strong) SJFileManager *fileManager;

@end

@implementation CAImageCache

+ (CAImageCache *)sharedInstance
{
    static CAImageCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    
    return cache;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        self.fileManager = [[SJFileManager alloc] initWithKey:@"images"];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forURL:(NSString *)url
{
    NSString *md5 = [url MD5Sum];
    
    [self setObject:image forKey:md5];
    
    [self.fileManager writeToUserDisk:md5 data:UIImageJPEGRepresentation(image, 0.8)];
}

- (void)setData:(NSData *)data forURL:(NSString *)url
{
    NSString *md5 = [url MD5Sum];
    
    UIImage *image = [UIImage imageWithData:data];
    
    [self setObject:image forKey:md5];
    
    [self.fileManager writeToUserDisk:md5 data:data];
}

- (UIImage *)imageForURL:(NSString *)url
{
    NSString *md5 = [url MD5Sum];
    
    UIImage *image = [self objectForKey:md5];
    
    if (image == nil) {
        NSData *data = [self.fileManager loadFromUserDisk:md5];
        
        if (data) {
            image = [UIImage imageWithData:data];
            [self setObject:image forKey:md5];
        }
    }
    
    return image;
}

@end
