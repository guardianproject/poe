//
//  OCRootViewController.m
//  POE
//
//  Created by Benjamin Erhart on 06.04.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "OCRootViewController.h"

@implementation OCRootViewController

- (id)init
{
    if (self = [super initWithNibName: @"LaunchScreen" bundle: [NSBundle bundleForClass: [OCRootViewController classForCoder]]])
    {
        self.introVC = [[IntroViewController alloc] init];
        self.introVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.conctVC = [[ConnectingViewController alloc] init];
        self.conctVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.errorVC = [[ErrorViewController alloc] init];
        self.errorVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    [self presentViewController: self.introVC animated: animated completion: nil];
}

// MARK: - POEDelegate

/**
     Callback, after the user finished the intro and selected, if she wants to
     use a bridge or not.

     - parameter useBridge: true, if user selected to use a bridge, false, if not.
 */
- (void)introFinished:(BOOL)useBridge
{
    [self.introVC presentViewController:self.conctVC animated:YES completion:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC connectingStarted];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC updateProgress:0.25];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC updateProgress:0.5];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC updateProgress:0.75];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC updateProgress:1];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conctVC connectingFinished];
    });
}

/**
    Callback, after the user pressed the "Start Browsing" button.
 */
- (void)userFinishedConnecting
{
    [self.conctVC presentViewController:self.errorVC animated:YES completion:nil];
}

@end
