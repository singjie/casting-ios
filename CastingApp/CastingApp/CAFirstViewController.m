//
//  CAFirstViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CAFirstViewController.h"

#import "CAImageCache.h"

#import "CACasting.h"

@interface CAFirstViewController ()

@property (nonatomic, strong) NSArray *results;

@end

@implementation CAFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CAClient sharedInstance] requestListOnCompletion:^(NSArray * responseObject, NSError *error) {
        NSLog(@"responseObject:%@ :%@", responseObject, self);
        
        self.results = responseObject;
        
        [self configureButtons];
    }];
    
    self.topListButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.middleListButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bottomListButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.mainButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self configureButtons];
}

- (void)configureButtons
{
    [self configureButton:self.topListButton withCasting:self.results[1]];
    [self configureButton:self.middleListButton withCasting:self.results[2]];
    [self configureButton:self.bottomListButton withCasting:self.results[3]];
    
    [self configureButton:self.mainButton withCasting:self.results[0]];
    
}

- (void)configureButton:(UIButton *)button withCasting:(CACasting *)casting
{
    [button setImage:nil forState:UIControlStateNormal];
    
    UIImage *image = [[CAImageCache sharedInstance] imageForURL:casting.imageURL];
    
    if (image == nil) {
        [[CAClient sharedInstance] getImage:casting.imageURL onCompletion:^(UIImage *image, NSError *error) {
            [[CAImageCache sharedInstance] setImage:image forURL:casting.imageURL];
            [self configureButton:button withCasting:casting];
        }];
    }
    
    [button setImage:image forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
