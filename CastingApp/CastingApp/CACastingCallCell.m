//
//  CACastingCallsCell.m
//  CastingApp
//
//  Created by Lee Sing Jie on 24/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CACastingCallCell.h"

#import "CACasting.h"

#import "CAImageCache.h"

@interface CACastingCallCell ()

@property (nonatomic, strong) UIButton *castingButton;

@end

@implementation CACastingCallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.castingButton = [[UIButton alloc] initWithFrame:self.contentView.bounds];
        self.castingButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.castingButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self.castingButton addTarget:self action:@selector(didTapCasting:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.castingButton];
    }
    return self;
}

- (void)setCasting:(CACasting *)casting
{
    _casting = casting;
    
    UIImage *image = [[CAImageCache sharedInstance] imageForURL:casting.imageURL];
    
    __weak CACastingCallCell *me = self;
    
    if (image == nil) {
        [[CAClient sharedInstance] getImage:casting.imageURL onCompletion:^(UIImage *image, NSError *error) {
            [[CAImageCache sharedInstance] setImage:image forURL:casting.imageURL];
            
            [me.castingButton setImage:image
                              forState:UIControlStateNormal];
        }];
    }
    
    [self.castingButton setImage:image
                        forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didTapCasting:(id)sender
{
    [self.delegate didTapCasting:self.casting];
}

@end
