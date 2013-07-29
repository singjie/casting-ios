//
//  CAManager.m
//  CastingApp
//
//  Created by Lee Sing Jie on 27/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CAManager.h"

@implementation CAManager

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        self.name = [dictionary objectForKey:@"name"];
        self.id = [[dictionary objectForKey:@"id"] integerValue];
    }
    
    return self;
}

@end
