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

        self.bridgeVC = [BridgeSelectViewController
         initWithCurrentId:[NSUserDefaults.standardUserDefaults integerForKey:@"use_bridges"]
         noBridgeId:@0
         providedBridges:@{@1: @"obfs4", @2: @"meek-amazon", @3: @"meek-azure"}
         customBridgeId:@99
         customBridges:[NSUserDefaults.standardUserDefaults stringArrayForKey:@"custom_bridges"]];

        self.conctVC = [[ConnectingViewController alloc] init];
        self.conctVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.errorVC = [[ErrorViewController alloc] init];
        self.errorVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

        NSString *localeId = [NSUserDefaults.standardUserDefaults objectForKey:@"locale"];
        NSString *currentId = [[NSLocale currentLocale] localeIdentifier];

        if (localeId && ![currentId isEqualToString:localeId])
        {
            NSLog(@"Change locale in your app from '%@' to '%@'!", currentId, localeId);
        }
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

//    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"did_intro"];
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"did_intro"]) {
        self.conctVC.autoClose = YES;
        [self presentViewController: self.conctVC animated: animated completion: nil];
        [self connect];
    }
    else {
        [self presentViewController: self.introVC animated: animated completion: nil];
    }
}

// MARK: - POEDelegate

/**
     Callback, after the user finished the intro and selected, if she wants to
     use a bridge or not.

     - parameter useBridge: true, if user selected to use a bridge, false, if not. You should
     show the BridgeSelectViewController then.
 */
- (void)introFinished:(BOOL)useBridge
{
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"did_intro"];

    if (useBridge)
    {
        [self.introVC presentViewController:self.bridgeVC animated:YES completion:nil];
        return;
    }

    [NSUserDefaults.standardUserDefaults setInteger:0 forKey:@"use_bridges"];

    [self.introVC presentViewController:self.conctVC animated:YES completion:nil];

    [self connect];
}

/**
     Receive this callback, after the user finished the bridges configuration.

     - parameter bridgesId: the selected ID of the list you gave in the constructor of
     BridgeSelectViewController.
     - parameter customBridges: the list of custom bridges the user configured.
 */
- (void)bridgeConfigured:(NSInteger)bridgesId customBridges:(NSArray *)customBridges
{
    [NSUserDefaults.standardUserDefaults setInteger:bridgesId forKey:@"use_bridges"];
    [NSUserDefaults.standardUserDefaults setObject:customBridges forKey:@"custom_bridges"];

    if (self.conctVC.presentingViewController)
    {
        // Already showing - do connection again from beginning.
        [self connect];
    }
    else {
        // Not showing - present the ConnectingViewController and start connecting afterwards.
        [self.introVC presentViewController:self.conctVC animated:YES completion:^{
            [self connect];
        }];
    }
}

/**
     Receive this callback, when the user pressed the gear icon in the ConnectingViewController.

     This probably means, the connection doesn't work and the user wants to configure bridges.

     Cancel the connection here and show the BridgeSelectViewController afterwards.
 */
- (void)changeSettings
{
    [self cancel];
    [self.conctVC presentViewController:self.bridgeVC animated:YES completion:nil];
}

/**
    Callback, after the user pressed the "Start Browsing" button.
 */
- (void)userFinishedConnecting
{
    [self.conctVC presentViewController:self.errorVC animated:YES completion:nil];
}

/**
    Callback, when the user changed the locale.
 */
- (void)localeUpdated:(NSString *)localeId
{
    [NSUserDefaults.standardUserDefaults setObject:localeId forKey:@"locale"];
}

// MARK: - Private

- (void)connect
{
    [self.conctVC connectingStarted];

    self.connectionSteps = @[
                       dispatch_block_create(0, ^{ [self.conctVC updateProgress:0.25]; }),
                        dispatch_block_create(0, ^{ [self.conctVC updateProgress:0.5]; }),
                        dispatch_block_create(0, ^{ [self.conctVC updateProgress:0.75]; }),
                        dispatch_block_create(0, ^{ [self.conctVC updateProgress:1]; }),
                        dispatch_block_create(0, ^{ [self.conctVC connectingFinished]; }),
                        ];

    NSInteger count = 0;
    for (dispatch_block_t step in self.connectionSteps) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(++count * NSEC_PER_SEC)), dispatch_get_main_queue(), step);
    }
}

- (void) cancel
{
    for (dispatch_block_t step in self.connectionSteps)
    {
        dispatch_block_cancel(step);
    }

    self.connectionSteps = nil;
}

@end
