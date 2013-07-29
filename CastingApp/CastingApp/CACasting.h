//
//  CACasting.h
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CAManager;

@interface CACasting : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger kind;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) CAManager *manager;

@property (nonatomic, strong) NSString *requirements;

+ (CACasting *)castingDictionary:(NSDictionary *)dictionary;

@end
