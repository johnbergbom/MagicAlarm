//
//  MainViewController.h
//  REMAlarmClock
//
//  Created by John Bergbom on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipViewCtrl.h"

#define degreesToRadian(x) (M_PI * x / 180.0)

@interface MainViewController : UITabBarController <UITabBarControllerDelegate> {
    FlipViewCtrl *flipViewCtrl;
	NSUInteger prevItem;
	CGAffineTransform _originalTransform;
	CGRect _originalBounds;
	CGPoint _originalCenter;
	BOOL initiated;
	//UIInterfaceOrientation orientation;
}

@property (assign) FlipViewCtrl *flipViewCtrl;
@property (assign) NSUInteger prevItem;

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed;
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end
