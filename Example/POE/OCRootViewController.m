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

    if ([NSUserDefaults.standardUserDefaults boolForKey:@"did_intro"]) {
        self.conctVC.autoClose = YES;
        [self presentViewController: self.conctVC animated: animated completion: nil];
        [self connect:[NSUserDefaults.standardUserDefaults boolForKey:@"use_bridge"]];
    }
    else {
        [self presentViewController: self.introVC animated: animated completion: nil];
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
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"did_intro"];
    [NSUserDefaults.standardUserDefaults setBool:useBridge forKey:@"use_bridge"];

    [self.introVC presentViewController:self.conctVC animated:YES completion:nil];

    [self connect:useBridge];
}

/**
    Callback, after the user pressed the "Start Browsing" button.
 */
- (void)userFinishedConnecting
{
    [self.errorVC updateProgress:1];
    [self.conctVC presentViewController:self.errorVC animated:YES completion:nil];
}

// MARK: - Private

- (void)connect:(BOOL)useBridge
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

@end
