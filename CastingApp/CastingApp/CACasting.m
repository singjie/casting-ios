//
//  CACasting.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CACasting.h"

#import "CAManager.h"

@implementation CACasting

+ (CACasting *)castingDictionary:(NSDictionary *)dictionary
{
    NSNumber *castID = [dictionary objectForKey:@"id"];
    
    if (castID == nil) {
        return nil;
    }
    
    CACasting *casting = [[CACasting alloc] init];
    casting.id = [castID integerValue];
    casting.desc = [dictionary objectForKey:@"description"];
    casting.imageURL = [dictionary objectForKey:@"image"];
    casting.kind = [[dictionary objectForKey:@"kind"] integerValue];
    casting.name = [dictionary objectForKey:@"name"];
    casting.requirements = [dictionary objectForKey:@"requirements"];
    
    casting.manager = [[CAManager alloc] initWithDictionary:[dictionary objectForKey:@"manager"]];
    
    return casting;
}

@end
