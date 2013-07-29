//
//  CACastingCallsCell.h
//  CastingApp
//
//  Created by Lee Sing Jie on 24/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CACasting;

@protocol CACastingCallCellProtocol <NSObject>

- (void)didTapCasting:(CACasting *)casting;

@end

@interface CACastingCallCell : UITableViewCell

@property (nonatomic, strong) CACasting *casting;

@property (nonatomic, weak) id <CACastingCallCellProtocol> delegate;

@end
