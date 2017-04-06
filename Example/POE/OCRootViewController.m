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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.conctVC done];
        });
    }
}

- (void)introFinished:(BOOL)useBridge
{
    self.nextVC = self.conctVC;

    [self dismissViewControllerAnimated: true completion: nil];
}

- (void)connectingFinished
{
    self.nextVC = self.errorVC;

    [self dismissViewControllerAnimated: true completion: nil];
}

@end
