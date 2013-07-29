//
//  CACastingCallMenuCell.h
//  CastingApp
//
//  Created by Lee Sing Jie on 26/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CACastingCallMenuCellProtocol <NSObject>

- (void)didTapLatestButton:(id)sender;
- (void)didTapPopularButton:(id)sender;
- (void)didTapInviteButton:(id)sender;

@end

@interface CACastingCallMenuCell : UITableViewCell

@property (nonatomic, weak) id <CACastingCallMenuCellProtocol> delegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@end
