//
//  CACastingCallMenuCell.m
//  CastingApp
//
//  Created by Lee Sing Jie on 26/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CACastingCallMenuCell.h"

#import <QuartzCore/QuartzCore.h>

@interface CACastingCallMenuCell ()

@property (nonatomic, strong) UIButton *latestCall;
@property (nonatomic, strong) UIButton *popularCall;
@property (nonatomic, strong) UIButton *inviteCall;

@end

@implementation CACastingCallMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = 320/3;
        self.latestCall = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width+1, self.frame.size.height)];
        [self.latestCall setTitle:@"Latest Casting Call" forState:UIControlStateNormal];
        
        self.popularCall = [[UIButton alloc] initWithFrame:CGRectMake(width+1, 0, width, self.frame.size.height)];
        [self.popularCall setTitle:@"Most Popular Calls" forState:UIControlStateNormal];
        
        self.inviteCall = [[UIButton alloc] initWithFrame:CGRectMake(width*2+1, 0, width+1, self.frame.size.height)];
        [self.inviteCall setTitle:@"By Invite Only" forState:UIControlStateNormal];
        
        [self.latestCall addTarget:self
                            action:@selector(didTapButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.popularCall addTarget:self
                            action:@selector(didTapButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self.inviteCall addTarget:self
                            action:@selector(didTapButton:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [self themeButton:self.latestCall];
        [self themeButton:self.popularCall];
        [self themeButton:self.inviteCall];
        
        [self.contentView addSubview:self.latestCall];
        [self.contentView addSubview:self.popularCall];
        [self.contentView addSubview:self.inviteCall];
    }
    return self;
}

- (void)didTapButton:(id)sender
{
    if (sender == self.latestCall) {
        [self.delegate didTapLatestButton:self];
    } else if (sender == self.popularCall) {
        [self.delegate didTapPopularButton:self];
    } else if (sender == self.inviteCall) {
        [self.delegate didTapInviteButton:self];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    self.latestCall.selected = selectedIndex == 0;
    self.popularCall.selected = selectedIndex == 1;
    self.inviteCall.selected = selectedIndex == 2;
}

- (void)themeButton:(UIButton *)button
{
    [button setTitleColor:[UIColor colorWithRed:102.0/255 green:102.0/255 blue:102.0/255 alpha:1]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateSelected];
    [button setBackgroundImage:[self imageForColor:[UIColor colorWithRed:40.0/255 green:41.0/255 blue:46.0/255 alpha:1]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[self imageForColor:[UIColor colorWithRed:173.0/255 green:114.0/255 blue:22.0/255 alpha:1]]
                      forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
    button.titleLabel.shadowColor = [UIColor blackColor];
    button.titleLabel.shadowOffset = CGSizeMake(0, 1);
}

- (UIImage *)imageForColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
