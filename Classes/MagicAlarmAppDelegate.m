//
//  REMAlarmClockAppDelegate.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MagicAlarmAppDelegate.h"
//#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>
#import "MainViewController.h"

@implementation MagicAlarmAppDelegate

@synthesize window;
//@synthesize rootViewController;
@synthesize flipViewCtrl;
@synthesize silentSoundPlayer;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	//NSLog(@"Slutade att launcha");
	
	/* Turn off the automatic screen saver. */
	NSLog(@"Disabling screen saver at program start.");
	[UIApplication sharedApplication].idleTimerDisabled = YES; //qqq
	
	/* We remove the status bar, because it causes problems when flipping
	   to the UITabBarController view if the clock view was in landscape mode.
	   => Actually this is done in the nib file instead. */
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];

    // Override point for customization after application launch
	
	/* Set the audio session category to kAudioSessionCategory_MediaPlayback
	   in order to make sure that sound will be heard even if the phone is in silent mode. */
	AudioSessionInitialize(NULL,NULL,NULL,NULL/*interruptionListenerCallback,userData*/);
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,sizeof(sessionCategory),&sessionCategory);
	
	/*
	settingsTableViewCtrl = [[[SettingsTableViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	navigationController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewCtrl];
	//[navigationController pushViewController:[[[SettingsTableViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease] animated:NO];
	//[settingsTableViewCtrl release];
	[window addSubview:[navigationController view]];
	*/
	
	/*
	tabBarController = [[UITabBarController alloc] initWithNibName:nil bundle:nil];
	settingsTableViewCtrl = [[[SettingsTableViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	tabBarController.viewControllers = [NSArray arrayWithObjects:settingsTableViewCtrl, nil];
	[window addSubview:[tabBarController view]];
	*/

	/* This clock view isn't used in practice, rather the clockview/clockviewcontrol of the flipcontroller
	   is used. So therefore make sure that the timer of this clock view is turned off. The only point
	   with this clock view control is that something needs to be fed to the tab bar controller, and
	   this clock view controller tells the tab bar controller what image to display on the tab bar.
	   In fact this whole object which is fed to the tab bar controller should probably be replaced with
	   a dummy object that inherits from UIViewController and doesn't do anything else than setting
	   self.tabBarItem.image to a value in its init function. FIXME! */
	clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	[clockViewCtrl.clockView stopUpdateTimer];
	//clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:@"ClockViewController" bundle:nil] autorelease];
	settingsTableViewCtrl = [[[SettingsTableViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	//settingsTableViewCtrl.view.contentMode = UIViewContentModeRedraw;
	//settingsTableViewCtrl.view.clearsContextBeforeDrawing = YES;
	//settingsTableViewCtrl.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	relaxViewCtrl = [[[RelaxViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	//relaxViewCtrl.clockView = clockViewCtrl.clockView;
	//relaxViewCtrl.clockView = 
	helpViewCtrl = [[[HelpViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	aboutViewCtrl = [[[AboutViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	navigationController = [[UINavigationController alloc] initWithRootViewController:settingsTableViewCtrl];
	//[navigationController.view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin/* | UIViewAutoresizingFlexibleHeight*/];
	//[navigationController.rotatingHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin/* | UIViewAutoresizingFlexibleHeight*/];
	//[navigationController.rotatingFooterView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin/* | UIViewAutoresizingFlexibleHeight*/];
	//navigationController.view.autoresizesSubviews = NO;
	//navigationController.rotatingHeaderView.autoresizesSubviews = NO;
	//navigationController.rotatingFooterView.autoresizesSubviews = NO;
	//rootViewController = [[[RootViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	tabBarController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
	//tabBarController.view.frame = [[UIScreen mainScreen] bounds];
	//tabBarController = [[MainViewController alloc] init];
	//tabBarController.view.frame = CGRectMake(0,0,320,460);
	////tabBarController.view.frame = CGRectMake(0,0,320,480);
	//[tabBarController.view setBounds:[[UIScreen mainScreen] bounds]];
	((MainViewController *)tabBarController).flipViewCtrl = flipViewCtrl;
	//tabBarController = [[UITabBarController alloc] initWithFrame:CGRectMake(20,20,320,216)];
	tabBarController.viewControllers = [NSArray arrayWithObjects:clockViewCtrl,navigationController,relaxViewCtrl,helpViewCtrl,aboutViewCtrl/*,rootViewController*/,nil];
	//tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController,relaxViewCtrl,helpViewCtrl,aboutViewCtrl,nil];
	tabBarController.selectedIndex = 1;
	((MainViewController *)tabBarController).prevItem = tabBarController.selectedIndex;
	//tabBarController.view.alpha = 0.5;
	////[window addSubview:[tabBarController view]];
	//clockViewCtrl.view.alpha = 1.0;
	
	//rootViewController = [[[RootViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	//rootViewController = [RootViewCtrl alloc];
	//[rootViewController loadView];
	//[window addSubview:[rootViewController view]];
	//flipsideViewController = [FlipsideViewController alloc];
	//[flipsideViewController loadView];
	//[window addSubview:[flipsideViewController view]];
	//[window addSubview:[clockViewCtrl view]];

	//flipViewCtrl = [[[FlipViewCtrl alloc] initWithNibName:@"FlipViewController" bundle:[NSBundle mainBundle]] autorelease];
	//[window addSubview:[flipViewCtrl view]];
	/*[flipViewCtrl.view setFrame:CGRectMake(0,0,320,480)];
	[flipViewCtrl.view setNeedsLayout];
	[flipViewCtrl.view setNeedsDisplay];
	[flipViewCtrl.view setNeedsDisplayInRect:CGRectMake(0,0,320,480)];*/
	flipViewCtrl.clockViewShown = NO;
	flipViewCtrl.tabBarController = tabBarController;
	//flipViewCtrl.settings = settingsTableViewCtrl;
	//tabBarController.view.clearsContextBeforeDrawing = YES;
	//tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [flipViewCtrl.view addSubview:tabBarController.view];
	//NSLog(@"appDelegate.setSettings");
	//flipViewCtrl.clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	[flipViewCtrl setSettings:settingsTableViewCtrl];
	relaxViewCtrl.clockView = flipViewCtrl.clockViewCtrl.clockView;
	settingsTableViewCtrl.clockView = flipViewCtrl.clockViewCtrl.clockView;
    [window addSubview:flipViewCtrl.view];
	[window makeKeyAndVisible];
	//silentSoundPlaying = NO;
	silentSoundPlayerTimer = [NSTimer scheduledTimerWithTimeInterval:5.0
															  target:self selector:@selector(playSilentSound:)
															userInfo:nil repeats:YES];
}


/* TODO: Make sure that this silent sound playing won't start until in the applicationWillResignActive
   function. Also: don't start it in the first place if lock_screen = NO. */

/* Play sound if not playing already. */
- (void)playSilentSound:(NSTimer*)theTimer {
	//NSLog(@"In playSilentSound");
	if ((silentSoundPlayer == nil || silentSoundPlayer.playing == NO) && flipViewCtrl.clockViewCtrl.clockView.player.playing == NO/*soundPlaying == 0*//*silentSoundPlaying == NO*/) {
		//NSLog(@"In playSilentSound: starting new sound");
		//silentSoundPlaying = YES;
		if (silentSoundPlayer != nil) {
			[silentSoundPlayer release];
			silentSoundPlayer = nil;
		}
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"silentsound" ofType:@"mp3"]];
		NSError *outError = nil;
		AVAudioPlayer *newPlayer =
		[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
											   error: &outError];
		if (outError != nil) {
			NSLog(@"Error playing silent sound: %@",[outError localizedDescription]);
			return;
		}// else {
			//NSLog(@"No error playing silent sound.");
		//}
		[fileURL release];
		
		self.silentSoundPlayer = newPlayer;
		self.silentSoundPlayer.delegate = self;
		[newPlayer release];

		AudioSessionSetActive(true);
		//NSLog(@"silent sound volume = 0.20");
		[self.silentSoundPlayer setVolume:0.00]; //0.05
		self.silentSoundPlayer.numberOfLoops = 0;
		[self.silentSoundPlayer prepareToPlay];
		//NSLog(@"Playing silent sound.");
		[self.silentSoundPlayer play];
	}
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	//do nothing
	//NSLog(@"silent sound interrupted");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	//resume playing after interruption
	//NSLog(@"silent sound interruption stopped");
	[player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playerLoc successfully:(BOOL)flag {
	//silentSoundPlaying = NO;
	//Be a good iPhone citizen and set the audio to inactive when the sound finished
	//NSLog(@"silent sound stopped");
	if (flipViewCtrl.clockViewCtrl.clockView.player.playing == NO/*soundPlaying == 0*/) {
		//NSLog(@"silent: turning off audio session");
		AudioSessionSetActive(false);
	}// else {
		//NSLog(@"silent: NOT turning off audio session");
	//}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	if (silentSoundPlayerTimer != nil && [silentSoundPlayerTimer isValid]) {
		[silentSoundPlayerTimer invalidate];
		silentSoundPlayerTimer = nil;
	}
}

/* Shortly after the screen is locked (around 20 seconds according to some source) the device will
   go into sleep state, which means that the application won't run at all. We would like to have the
   screen shut off to save battery while still having the application running. This doesn't seem to
   be possible, so we do a work around here: whenever the applicationWillResignActive function is
   called (it's called when the screen is locked, or if an interrupt comes such as an incoming phone
   call) we'll start playing silent audio which stops the phone from going into sleep state. */
/*- (void)applicationWillResignActive:(UIApplication *)application {
	silentSoundPlayerTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
												   target:self selector:@selector(playSilentSound:)
												 userInfo:nil repeats:YES];
}*/

/* This function stops the silent audio that was started in applicationWillResignActive. */
/*- (void)applicationDidBecomeActive:(UIApplication *)application {
}*/

- (void)dealloc {
	//TODO: Here we probably need to release the controller objects created above!
    //[rootViewController release];
    [window release];
    [super dealloc];
}


@end
