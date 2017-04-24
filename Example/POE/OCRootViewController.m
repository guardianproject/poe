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
        self.conctVC = [[ConnectingViewController alloc] init];
        self.errorVC = [[ErrorViewController alloc] init];
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    if (!self.nextVC)
    {
        self.nextVC = self.introVC;
    }

    [self presentViewController: self.nextVC animated: animated completion: nil];
    
    if (self.nextVC == self.conctVC)
    {
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
}

// MARK: - POEDelegate

/**
     Callback, after the user finished the intro and selected, if she wants to
     use a bridge or not.

     - parameter useBridge: true, if user selected to use a bridge, false, if not.
 */
- (void)introFinished:(BOOL)useBridge
{
    self.nextVC = self.conctVC;

    [self dismissViewControllerAnimated: true completion: nil];
}

/**
    Callback, after the user pressed the "Start Browsing" button.
 */
- (void)userFinishedConnecting
{
    self.nextVC = self.errorVC;

    [self dismissViewControllerAnimated: true completion: nil];
}

@end
