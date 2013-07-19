//
//  CACasting.h
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CACasting : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger kind;

+ (CACasting *)castingDictionary:(NSDictionary *)dictionary;

@end
