//
//  CACaptureViewController.m
//  CastingApp
//
//  Created by Lee Sing Jie on 14/7/13.
//  Copyright (c) 2013 Lee Sing Jie. All rights reserved.
//

#import "CACaptureViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MessageUI/MessageUI.h>

#import "RosyWriterPreviewView.h"
#import "RosyWriterVideoProcessor.h"

#import "MBProgressHUD.h"

@interface CACaptureViewController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate, RosyWriterVideoProcessorDelegate>

@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) UIImageView *recordingImage;

@property (nonatomic, strong) RosyWriterVideoProcessor *videoProcessor;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation CACaptureViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveA:) name:@"a" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self setupAVCapture];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(didTriggerOneSecondTimer:) userInfo:nil repeats:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:47.0/255 green:47.0/255 blue:47.0/255 alpha:1];
    
    self.debugLabel.textColor = [UIColor whiteColor];
    self.debugLabel.hidden = YES;
    
    // Initialize the class responsible for managing AV capture session and asset writer
    self.videoProcessor = [[RosyWriterVideoProcessor alloc] init];
	self.videoProcessor.delegate = self;
    
    [self.videoProcessor setupAndStartCaptureSession];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[self.videoProcessor captureSession]];
    
    [self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [self.previewView layer];
    [rootLayer setMasksToBounds:YES];
    [self.previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:self.previewLayer];
    
    self.recordingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recording"]];
    self.recordingImage.frame = CGRectMake(109, 16, self.recordingImage.frame.size.width, self.recordingImage.frame.size.height);
    self.recordingImage.hidden = YES;
    
    [self.previewView addSubview:self.recordingImage];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.previewView.frame), self.view.frame.size.width, 80)];
    self.textView.text = @"Smile! Once you are ready, please proceed with the recording. You will be given 3 tries. Good luck!";
    self.textView.font = [UIFont boldSystemFontOfSize:20];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.hidden = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:self.textView];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.recordingImage.frame) + 2, CGRectGetMinY(self.recordingImage.frame), 100, 18)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.hidden = YES;
    [self.view addSubview:self.timeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRecording
{
    self.isRecording = YES;
    self.debugLabel.text = @"Recording";
    self.textView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a nisl nunc. Morbi dictum mi vitae odio porttitor, vitae pharetra turpis scelerisque. Vestibulum venenatis, sapien at scelerisque facilisis, metus tortor mattis augue, non dictum dui purus a mi. In ut nunc tincidunt mauris hendrerit interdum vel eu dolor. Quisque iaculis lobortis turpis, in auctor nibh auctor nec. Proin congue, sem non faucibus dictum, enim nulla ornare tellus, a scelerisque magna nibh eget justo. Morbi sit amet faucibus lorem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum dui nisi, adipiscing commodo consequat nec, commodo at nisl. Donec fringilla elementum eleifend. Suspendisse et sapien at lorem vestibulum gravida non eget lorem. Maecenas vel sem erat. Praesent lobortis justo eget augue viverra bibendum.";
    
    self.startDate = [NSDate date];
    [self.videoProcessor startRecording];
}

- (void)stopRecording
{
    self.debugLabel.text = @"Stop Recording";
    self.isRecording = NO;
 
    [self.videoProcessor stopRecording];
}

- (IBAction)didTapCaptureButton:(id)sender
{
    if (self.isRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
    
    self.textView.hidden = !self.isRecording;
    self.textView.contentOffset = CGPointZero;
    self.recordingImage.hidden = !self.isRecording;
    self.timeLabel.hidden = !self.isRecording;
}

- (void)recordingWillStart
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)recordingDidStart
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)recordingWillStop
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)recordingDidStopWithData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hudShowLoading];
        
        NSLog(@"%@, %d", NSStringFromSelector(_cmd), data.length);
        
        self.debugLabel.text = [NSString stringWithFormat:@"Uploading :%d", data.length];
        
        [[CAClient sharedInstance] uploadVideo:data onCompletion:^(id responseObject, NSError *error) {
            NSLog(@"Completed uploading");
            [self hudShowSuccessful:@"Uploaded successfully"];
            
            self.debugLabel.text = @"Uploaded.";
        }];
    });
}

- (void)didReceiveA:(id)sender
{
    self.tabBarController.selectedViewController = self;
    self.textView.hidden = NO;
    self.textView.contentOffset = CGPointZero;
}

- (void)didTriggerOneSecondTimer:(id)sender
{
    self.textView.contentOffset = CGPointMake(self.textView.contentOffset.x, self.textView.contentOffset.y + 0.5);
    
    NSTimeInterval timeInterval = [self.startDate timeIntervalSinceNow] * -1;
    self.timeLabel.text = [NSString stringWithFormat:@"00:%02d", (int)timeInterval];
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
