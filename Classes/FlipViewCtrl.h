//
//  FlipViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewCtrl.h"
//#import "SettingsTableViewCtrl.h"

//@class SettingsTableViewCtrl;

@interface FlipViewCtrl : UIViewController {
	//IBOutlet UIView *clockView;
	ClockViewCtrl *clockViewCtrl;
	BOOL clockViewShown;
	UITabBarController *tabBarController;
	//SettingsTableViewCtrl *settings;
	NSTimer *clockViewSwitcher;
}

@property BOOL clockViewShown;
@property (assign) UITabBarController *tabBarController;
@property (assign) ClockViewCtrl *clockViewCtrl;
//@property (assign) SettingsTableViewCtrl *settings;

- (void)toggleView:(id)sender;
-(void) setSettings:(SettingsTableViewCtrl *)settings;
-(void) maybeSwitchToClockView:(NSTimer*)theTimer;

@end

