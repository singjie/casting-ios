//
//  CACaptureViewController.h
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CACaptureViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *previewView;
- (IBAction)didTapCaptureButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *debugLabel;
@end
