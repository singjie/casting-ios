//
//  CASecondViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CASecondViewController.h"

@interface CASecondViewController ()

@end

@implementation CASecondViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"profile_active"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"profile"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
