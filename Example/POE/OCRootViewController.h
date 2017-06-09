//
//  OCRootViewController.h
//  POE
//
//  Created by Benjamin Erhart on 06.04.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import <UIKit/UIKit.h>
@import POE;

@interface OCRootViewController : UIViewController <POEDelegate>

@property IntroViewController *introVC;
@property UINavigationController *bridgeVC;
@property ConnectingViewController *conctVC;
@property ErrorViewController *errorVC;

@end
