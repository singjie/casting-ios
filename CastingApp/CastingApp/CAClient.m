//
//  CAClient.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CAClient.h"

#import <MessageUI/MessageUI.h>

#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"

#import "NSData+SSToolkitAdditions.h"

#import "CACasting.h"

#define LOCALHOST_

#ifndef LOCALHOST
static NSString *kClientBaseURL = @"http://castingapp.herokuapp.com";
#else
static NSString *kClientBaseURL = @"http://localhost:3000";
#endif

@implementation CAClient

+ (id)sharedInstance
{
    static CAClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[CAClient alloc] initWithBaseURL:[NSURL URLWithString:kClientBaseURL]];
    });
    
    return client;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        self.parameterEncoding = AFJSONParameterEncoding;
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (void)requestLatestOnCompletion:(void (^)(NSArray *results, NSError *error))completion
{
    NSLog(@"request");
    [self getPath:@"castings/latest" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSMutableArray *responses = [NSMutableArray arrayWithCapacity:responseObject.count];
        
        for (NSDictionary *castDict in responseObject) {
            CACasting *casting = [CACasting castingDictionary:castDict];
            
            [responses addObject:casting];
        }
        
        NSLog(@"ResponseObject:%@", responseObject);
        completion(responses, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
        nil;
    }];
}

- (void)requestPopularOnCompletion:(void (^)(NSArray *results, NSError *error))completion
{
    NSLog(@"request");
    [self getPath:@"castings/popular" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSMutableArray *responses = [NSMutableArray arrayWithCapacity:responseObject.count];
        
        for (NSDictionary *castDict in responseObject) {
            CACasting *casting = [CACasting castingDictionary:castDict];
            
            [responses addObject:casting];
        }
        
        NSLog(@"ResponseObject:%@", responseObject);
        completion(responses, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
        nil;
    }];
}


- (void)requestInviteOnCompletion:(void (^)(NSArray *results, NSError *error))completion
{
    NSLog(@"request");
    [self getPath:@"castings/invite" parameters:nil success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        NSMutableArray *responses = [NSMutableArray arrayWithCapacity:responseObject.count];
        
        for (NSDictionary *castDict in responseObject) {
            CACasting *casting = [CACasting castingDictionary:castDict];
            
            [responses addObject:casting];
        }
        
        NSLog(@"ResponseObject:%@", responseObject);
        completion(responses, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@", error);
        nil;
    }];
}

- (void)uploadVideo:(NSData *)data onCompletion:(void (^)(id responseObject, NSError *error))completion
{
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST"
                                                                   path:@"user_videos/user_video_create"
                                                             parameters:nil
                                              constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                  NSString *filename = [NSString stringWithFormat:@"%@.mov", [data MD5Sum]];
                                                  [formData appendPartWithFileData:data name:@"user_video" fileName:filename mimeType:@"application/octet-stream"];
                                              }];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"%d:%lld:%lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"completion:%@", responseObject);
        NSNumber *index = [responseObject objectForKey:@"id"];
        NSString *indexString = [index stringValue];
        completion(indexString, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error");
        completion(nil, error);
    }];
    
    [operation start];
}

- (void)getImage:(NSString *)url onCompletion:(void (^)(UIImage *image, NSError *error))completion
{
    NSURLRequest *request = [self requestWithMethod:@"GET" path:url parameters:nil];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        NSLog(@"got image:%@", image);
        completion(image, nil);
    }];
    
    [operation start];
}

@end
