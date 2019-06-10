//
//  REMAlarmClockAppDelegate.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewCtrl.h"
#import "SettingsTableViewCtrl.h"
#import "RelaxViewCtrl.h"
#import "HelpViewCtrl.h"
#import "AboutViewCtrl.h"
//#import "RootViewCtrl.h"
//#import "FlipsideViewController.h"
#import "FlipViewCtrl.h"

@interface MagicAlarmAppDelegate : NSObject <UIApplicationDelegate, AVAudioPlayerDelegate> {
    UIWindow *window;
	ClockViewCtrl *clockViewCtrl;
	SettingsTableViewCtrl *settingsTableViewCtrl;
	RelaxViewCtrl *relaxViewCtrl;
	HelpViewCtrl *helpViewCtrl;
	AboutViewCtrl *aboutViewCtrl;
	UITabBarController *tabBarController;
	UINavigationController *navigationController;
	//RootViewCtrl *rootViewController;
	//FlipsideViewController *flipsideViewController;
	FlipViewCtrl *flipViewCtrl;
	NSTimer *silentSoundPlayerTimer;
	AVAudioPlayer *silentSoundPlayer;
	//BOOL silentSoundPlaying;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
//@property (nonatomic, retain) IBOutlet RootViewCtrl *rootViewController;
@property (nonatomic, retain) IBOutlet FlipViewCtrl *flipViewCtrl;
@property (retain) AVAudioPlayer *silentSoundPlayer;

@end

