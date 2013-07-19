//
//  CAClient.h
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "AFHTTPClient.h"

@interface CAClient : AFHTTPClient

+ (CAClient *)sharedInstance;

- (void)requestListOnCompletion:(void (^)(NSArray *responseObject, NSError *error))completion;

- (void)uploadVideo:(NSData *)data onCompletion:(void (^)(id responseObject, NSError *error))completion;
- (void)getImage:(NSString *)url onCompletion:(void (^)(UIImage *image, NSError *error))completion;

@end
