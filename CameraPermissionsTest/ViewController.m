//
//  Created by Pete Callaway on 23/10/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;


@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end


@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // Observe the app comming back to the foreground
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateLabel];
}





// Programatically requests access to the camera and updates the label on completion
- (IBAction)didTapRequestAccess:(id)sender {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateLabel];
        });
    }];
}

// Shows the app's settings in Settings.app
- (IBAction)didTapShowSettings:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

// Called when the application enters the foreground, updates the label with the current authorization status
- (void)applicationWillEnterForegroundNotification:(NSNotification*)notification {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateLabel];
    });
}





// Udpates the label with the current authorization status
- (void)updateLabel {
    NSString *newText = nil;
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            newText = @"Authorized";
            break;
            
        case AVAuthorizationStatusDenied:
            newText = @"Denied";
            break;
            
        case AVAuthorizationStatusNotDetermined:
            newText = @"Not determined";
            break;
            
        case AVAuthorizationStatusRestricted:
            newText = @"Restricted";
            break;
    }
    
    self.descriptionLabel.text = newText;
}

@end
