//
//  CATabBarViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 30/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CATabBarViewController.h"

#import "CACaptureViewController.h"

@interface CATabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *mainButton;

@end

@implementation CATabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"tabbarroll"];
    UIImage *buttonDisabledImage = [UIImage imageNamed:@"tabbarroll-disabled"];
    
    self.mainButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height)];
    [self.mainButton addTarget:self action:@selector(didTapMainButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainButton setBackgroundImage:buttonImage forState:UIControlStateSelected];
    [self.mainButton setBackgroundImage:buttonDisabledImage forState:UIControlStateNormal];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        self.mainButton.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        self.mainButton.center = center;
    }
    
    [self.view addSubview:self.mainButton];
    
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.mainButton.selected = [viewController isMemberOfClass:[CACaptureViewController class]];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    [super setSelectedViewController:selectedViewController];
    
    [self.delegate tabBarController:self didSelectViewController:selectedViewController];
}

- (void)didTapMainButton:(id)sender
{
    self.selectedIndex = 1;
    self.mainButton.selected = YES;
}
@end
