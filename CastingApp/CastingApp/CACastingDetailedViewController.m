//
//  CACastingDetailedViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 27/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CACastingDetailedViewController.h"

#import "CACasting.h"
#import "CAManager.h"

#import "CAImageCache.h"

@interface CACastingDetailedViewController ()

@property (nonatomic, strong) UIImageView *castingImageView;

@property (nonatomic, strong) UILabel *aboutLabel;
@property (nonatomic, strong) UILabel *aboutText;

@property (nonatomic, strong) UILabel *hiringLabel;
@property (nonatomic, strong) UILabel *hiringText;

@property (nonatomic, strong) UILabel *requirementsLabel;
@property (nonatomic, strong) UILabel *requirementsText;

@property (nonatomic, strong) UIButton *buyScript;

@end

@implementation CACastingDetailedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.castingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 258)];
    self.castingImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.castingImageView.clipsToBounds = YES;
    
    self.aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.castingImageView.frame) + 20, 157, 18)];
    self.aboutLabel.font = [UIFont boldSystemFontOfSize:15];
    [self themeLabel:self.aboutLabel];
    
    self.aboutText = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.aboutLabel.frame) + 5, 157, 186)];
    self.aboutText.numberOfLines = 0;
    self.aboutText.font = [UIFont systemFontOfSize:12];
    [self themeLabel:self.aboutText];
    
    self.hiringLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.castingImageView.frame) + 20, 157, 18)];
    self.hiringLabel.font = [UIFont boldSystemFontOfSize:15];
    [self themeLabel:self.hiringLabel];
    
    self.hiringText = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.aboutLabel.frame) + 5, 157, 20)];
    self.hiringText.numberOfLines = 0;
    self.hiringText.font = [UIFont systemFontOfSize:12];
    [self themeLabel:self.hiringText];
    
    self.requirementsLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.castingImageView.frame) + 70, 157, 20)];
    [self themeLabel:self.requirementsLabel];
    self.requirementsLabel.font = [UIFont boldSystemFontOfSize:15];
    
    self.requirementsText = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMaxY(self.requirementsLabel.frame) + 5, 157, 100)];
    self.requirementsText.numberOfLines = 0;
    self.requirementsText.font = [UIFont systemFontOfSize:12];
    [self themeLabel:self.requirementsText];
    
    self.buyScript = [[UIButton alloc] initWithFrame:CGRectMake(195, CGRectGetMaxY(self.castingImageView.frame) + 179, 119, 40)];
    [self.buyScript setBackgroundImage:[UIImage imageNamed:@"buyscript"] forState:UIControlStateNormal];
    [self.buyScript addTarget:self action:@selector(didTapBuyScript:) forControlEvents:UIControlEventTouchUpInside];
    
    //390/348
    [self.view addSubview:self.castingImageView];
    
    [self.view addSubview:self.aboutLabel];
    [self.view addSubview:self.aboutText];
    [self.view addSubview:self.hiringLabel];
    [self.view addSubview:self.hiringText];
    [self.view addSubview:self.requirementsLabel];
    [self.view addSubview:self.requirementsText];
    [self.view addSubview:self.buyScript];
    
    self.view.backgroundColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:71.0/255 alpha:1];
    
    self.aboutLabel.text = [NSString stringWithFormat:@"About %@", self.casting.name];
    self.aboutText.text = self.casting.desc;
    [self.aboutText sizeToFit];
    
    self.hiringLabel.text = @"Hiring Manager";
    self.hiringText.text = self.casting.manager.name;
    [self.hiringText sizeToFit];
    
    self.requirementsLabel.text = @"Requirements";
    self.requirementsText.text = self.casting.requirements;
    [self.requirementsText sizeToFit];
    
    UIImage *image = [[CAImageCache sharedInstance] imageForURL:self.casting.imageURL];
    
    __weak CACastingDetailedViewController *me = self;
    
    if (image == nil) {
        [[CAClient sharedInstance] getImage:self.casting.imageURL onCompletion:^(UIImage *image, NSError *error) {
            [[CAImageCache sharedInstance] setImage:image forURL:self.casting.imageURL];
            
            me.castingImageView.image = image;
        }];
    }
    
    self.castingImageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)themeLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
}

- (void)didTapBuyScript:(id)sender
{
    self.tabBarController.selectedIndex = 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"a" object:nil];
}

@end
