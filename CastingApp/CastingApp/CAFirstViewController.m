//
//  CAFirstViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CAFirstViewController.h"

#import "MBProgressHUD.h"

#import "CAImageCache.h"

#import "CACasting.h"

#import "CACastingCallCell.h"
#import "CACastingCallMenuCell.h"

#import "CACastingDetailedViewController.h"

@interface CAFirstViewController () <UITableViewDataSource, UITableViewDelegate, CACastingCallCellProtocol, CACastingCallMenuCellProtocol>

@property (nonatomic, strong) NSArray *results;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CAFirstViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"casting_active"]
                      withFinishedUnselectedImage:[UIImage imageNamed:@"casting"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Casting Calls";
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBarHidden = YES;
    
    [[CAClient sharedInstance] requestLatestOnCompletion:^(NSArray * responseObject, NSError *error) {
        NSLog(@"responseObject:%@ :%@", responseObject, self);
        
        self.results = responseObject;
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        CACastingCallMenuCell *cell = [[CACastingCallMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.delegate = self;
        cell.selectedIndex = self.selectedIndex;
        return cell;
    }
    
    NSIndexPath *correctedIndexPath = [NSIndexPath indexPathForRow:(indexPath.row >= 1 ? indexPath.row-1 : indexPath.row) inSection:indexPath.section];
    
    CACasting *casting = self.results[correctedIndexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    
    CACastingCallCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CACastingCallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    
    cell.casting = casting;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 240;
    } else if (indexPath.row == 1) {
        return 40;
    }
    
    return 85;
}

- (void)didTapCasting:(CACasting *)casting
{
    CACastingDetailedViewController *vc = [[CACastingDetailedViewController alloc] initWithNibName:nil bundle:nil];
    vc.casting = casting;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTapInviteButton:(id)sender
{
    self.selectedIndex = 2;
    
    [self hudShowLoading];
    [[CAClient sharedInstance] requestInviteOnCompletion:^(NSArray * responseObject, NSError *error) {
        NSLog(@"responseObject:%@ :%@", responseObject, self);
        self.results = responseObject;
        [self.tableView reloadData];
        [self hudHide];
    }];
}

- (void)didTapLatestButton:(id)sender
{
    self.selectedIndex = 0;
    
    [self hudShowLoading];
    [[CAClient sharedInstance] requestLatestOnCompletion:^(NSArray * responseObject, NSError *error) {
        NSLog(@"responseObject:%@ :%@", responseObject, self);
        self.results = responseObject;
        [self.tableView reloadData];
        [self hudHide];
    }];
}

- (void)didTapPopularButton:(id)sender
{
    self.selectedIndex = 1;
    
    [self hudShowLoading];
    [[CAClient sharedInstance] requestPopularOnCompletion:^(NSArray * responseObject, NSError *error) {
        NSLog(@"responseObject:%@ :%@", responseObject, self);
        self.results = responseObject;
        [self.tableView reloadData];
        [self hudHide];
    }];
}

#pragma mark - HUD

- (void)hudShowLoading
{
    [self hudShowLoadingInView:self.view];
}

- (void)hudShowLoadingInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"Loading...";
    [hud hide:YES afterDelay:30];
}

- (void)hudShowSuccessful:(NSString *)successful
{
    [self hudShowSuccessful:successful inView:self.view];
}

- (void)hudShowSuccessful:(NSString *)successful inView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"19-check"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = successful;
    [hud hide:YES afterDelay:1.25];
}

- (void)hudShowError:(NSString *)error
{
    [self hudShowError:error inView:self.view];
}

- (void)hudShowError:(NSString *)error inView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"20-no"]];
    hud.labelText = error;
    [hud hide:YES afterDelay:1.25];
}

- (void)hudHide
{
    [self hudHideInView:self.view];
}

- (void)hudHideInView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}   

@end
