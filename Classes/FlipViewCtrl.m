//
//  FlipViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FlipViewCtrl.h"
#import "MainViewController.h"
//#import "SettingsTableViewCtrl.h"

@implementation FlipViewCtrl

@synthesize clockViewShown;
@synthesize tabBarController;
@synthesize clockViewCtrl;
//@synthesize settings;

// The designated initializer. Override to perform setup that is required before the view is loaded.
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		//clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
		clockViewCtrl = [[ClockViewCtrl alloc] init];
	}
	return self;
}*/


/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

-(void) setSettings:(SettingsTableViewCtrl *)settings {
	//NSLog(@"flipp.setSettings");
	[clockViewCtrl setSettings:settings];
	[clockViewCtrl setFlippis:self];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSLog(@"flipp.didload");
	[super viewDidLoad];
	self.view.clearsContextBeforeDrawing = YES;
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	//self.view.userInteractionEnabled = YES;
	//clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	clockViewCtrl = [[ClockViewCtrl alloc] init];
	//NSLog(@"flipp.didload2");
	//[self.view addSubview:clockViewCtrl.view];
	[clockViewCtrl.button addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
	clockViewCtrl.flipViewCtrl = self;
	clockViewCtrl.new_pseudo_orientation = 0;
	//clockViewCtrl.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	//clockViewCtrl.view.userInteractionEnabled = YES;
	//[clockViewCtrl.button addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventValueChanged];
	//clockView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	[tabBarController viewWillAppear:NO];
	//[clockViewCtrl setSettings:(id)(tabBarController.viewControllers[1])];
	/* Check once per minute if it's time to automatically switch to the clock view. */
	clockViewSwitcher = [NSTimer scheduledTimerWithTimeInterval:1*60
														 target:self selector:@selector(maybeSwitchToClockView:)
													   userInfo:nil repeats:YES];
}




// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	clockViewCtrl.clockView.last_activity_time = [[NSDate alloc] init];
	//NSLog(@"Disabling screen saver because of user activity.");
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//clockViewCtrl.old_orientation = interfaceOrientation;
	clockViewCtrl.new_orientation = interfaceOrientation;
	clockViewCtrl.new_pseudo_orientation += 1;
	if (clockViewShown) {
		//self.view.bounds = CGRectMake(0,0,460,320);
		//[self.view setNeedsDisplay];
		//[self.view reload
		//clockViewCtrl.old_orientation = interfaceOrientation;
		//clockViewCtrl.new_orientation = interfaceOrientation;
		return YES;
	} else {
		clockViewCtrl.old_orientation = interfaceOrientation;
		//return NO;
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}
	//clockViewCtrl.interfaceOrientation = interfaceOrientation;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	//[clockViewCtrl.view setNeedsDisplay];
	[clockViewCtrl didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)toggleView:(id)sender {
	//clockViewCtrl.old_orientation = tabBarController.interfaceOrientation;
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	//[self.view setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
						   forView:[self view] //[self view]
							 cache:YES];
	[tabBarController viewWillAppear:NO];
	[[self view] addSubview:tabBarController.view]; //tillagd sjalv
	//[self.view bringSubviewToFront:tabBarController.view];
	//tabBarController.view.hidden = NO;
	[clockViewCtrl viewWillDisappear:NO];
	[clockViewCtrl.view removeFromSuperview]; //clockView
	//[self.view sendSubviewToBack:clockViewCtrl.view];
	//clockViewCtrl.view.hidden = YES;
	//[tabBarController viewDidAppear:NO];
	[UIView commitAnimations];
	clockViewShown = NO;
	//clockViewCtrl.old_orientation = UIInterfaceOrientationPortrait;
	//[self.view setNeedsDisplay];
	//[self reloadData];
	//[[UIApplication sharedApplication] statusBarOrientation:UIInterfaceOrientationPortrait];
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
	//tabBarController.view.frame = CGRectMake(40,30,460,400);
	//int prevVal = ((MainViewController *)tabBarController).prevItem;
	//tabBarController.selectedIndex = ((MainViewController *)tabBarController).prevItem;
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;

	int prevVal = ((MainViewController *)tabBarController).prevItem;
	/* For some reason the navigation bar becomes too small when rotating, so we need to adjust
	   its size by hand. */
	tabBarController.selectedIndex = 1;
	UINavigationController *navContr = ((UINavigationController *)tabBarController.selectedViewController);
	[navContr.rotatingHeaderView setFrame:CGRectMake(0,0,320,44)];

	tabBarController.selectedIndex = prevVal;
	clockViewCtrl.correction_rotation_done = NO;
	//[clockViewCtrl.view setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
	//clockViewCtrl.old_orientation = self.interfaceOrientation;
	//[self.view setFrame: [[UIScreen mainScreen] bounds]];
	//[[navContr view] setFrame: [[UIScreen mainScreen] bounds]];
	//[[navContr view] setFrame: CGRectMake(0,0,220,380)];
	//UINavigationBar *navBar = navContr.navigationBar;
	
	//[tabBarController viewWillAppear:NO];
	//CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
	//[tabBarController.view setTransform:rotate];
	//self.view = myTableView;
	//tabBarController.view.frame = CGRectMake(0,0,320,360);
	//[tabBarController.view setBounds:[[UIScreen mainScreen] bounds]];
	//tabBarController.selectedViewController.view.hidden = YES;
	//tabBarController.selectedViewController.view.hidden = NO;
	//[tabBarController.view setNeedsDisplay];
	//[tabBarController.view setNeedsLayout];
	
	NSLog(@"Disabling screen saver because moving to main view.");
	[clockViewCtrl.clockView disableScreenSaver]; //qqq
	//[UIApplication sharedApplication].idleTimerDisabled = YES; //qqq
	//clockViewCtrl.clockView.screen_locked = NO; //qqq
	
	/* Check once per minute if it's time to automatically switch to the clock view. */
	if (clockViewSwitcher != nil && [clockViewSwitcher isValid]) {
		[clockViewSwitcher invalidate];
		clockViewSwitcher = nil;
	}
	clockViewSwitcher = [NSTimer scheduledTimerWithTimeInterval:1*60
												   target:self selector:@selector(maybeSwitchToClockView:)
												 userInfo:nil repeats:YES];
}

/* Switch to clock view if we're in the main view and we've been idle for at least 3 minutes.
   Note: idle in this case is counted starting from the time when we last switched between the
   main view and the clock view (we probably should count starting from any activity in the
   main view, but that's not done here...). */
-(void) maybeSwitchToClockView:(NSTimer*)theTimer {
	if (clockViewShown == NO && [clockViewCtrl.clockView.last_activity_time timeIntervalSinceNow] < -10*60) {
		//Store the old last_activity_time value and then restore it, since
		//it's changed by the call to switchToClockView
		NSDate *temp = clockViewCtrl.clockView.last_activity_time;
		[self switchToClockView];
		clockViewCtrl.clockView.last_activity_time = temp;
		/*if (clockViewSwitcher != nil && [clockViewSwitcher isValid]) {
			[clockViewSwitcher invalidate];
			clockViewSwitcher = nil;
		}*/
	}
}

-(void) switchToClockView {
	if (clockViewSwitcher != nil && [clockViewSwitcher isValid]) {
		[clockViewSwitcher invalidate];
		clockViewSwitcher = nil;
	}
	//clockViewShown = YES;
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:[self view] //[self view]
							 cache:YES];
	[tabBarController viewWillDisappear:NO];
	[tabBarController.view removeFromSuperview]; //tillagd sjalv
	//[self.view sendSubviewToBack:tabBarController.view];
	//tabBarController.view.hidden = YES;
	////clockViewCtrl = [[[ClockViewCtrl alloc] initWithNibName:nil bundle:nil] autorelease];
	//if (clockViewCtrl != nil && clockViewCtrl.view != nil)

	/*UIButton *buttona = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain];
	buttona.frame = CGRectMake(100.0, 0.0, 25.0, 25.0);
	[buttona setTitle:@"latte" forState:UIControlStateNormal];
	buttona.backgroundColor = [UIColor clearColor];
	buttona.enabled = YES;
	buttona.showsTouchWhenHighlighted = YES;
	//buttona.userInteractionEnabled = YES;
	[buttona addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
	[clockViewCtrl.view addSubview:buttona];
	*/
	
	//[clockViewCtrl.button addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
	//clockViewCtrl.view.userInteractionEnabled = YES;
	//[clockViewCtrl.view setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
	[clockViewCtrl viewWillAppear:NO];
	//[clockViewCtrl turnAround];
	
	/*[clockViewCtrl release];
	clockViewCtrl = [[ClockViewCtrl alloc] init];
	//clockViewCtrl.interfaceOrientation = self.interfaceOrientation;
	[clockViewCtrl.button addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
	clockViewCtrl.flipViewCtrl = self;
	*/
	
	[[self view] addSubview:clockViewCtrl.view]; //clockView
	//[self.view bringSubviewToFront:clockViewCtrl.view];
	//clockViewCtrl.view.hidden = NO;
	[clockViewCtrl viewDidAppear:NO];
	//[clockViewCtrl.view setNeedsDisplay];
	//[self.view setNeedsDisplay];
	[UIView commitAnimations];
	//[UIApplication sharedApplication].statusBarOrientation = self.interfaceOrientation;
	//[clockViewCtrl viewDidAppear:NO];
	//[clockViewCtrl.view setNeedsDisplay];
	//[self.view setNeedsDisplay];
	//self.view.userInteractionEnabled = YES;
	//clockViewCtrl.view.userInteractionEnabled = YES;
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	clockViewShown = YES;
	clockViewCtrl.old_orientation = self.interfaceOrientation;
	//[clockViewCtrl.view setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
	[clockViewCtrl.clockView.last_activity_time release];
	clockViewCtrl.clockView.last_activity_time = [[NSDate alloc] init];
	/*if (clockViewCtrl.clockView.dimmed_at != nil) {
		[clockViewCtrl.clockView.dimmed_at release];
		clockViewCtrl.clockView.dimmed_at = nil;
	}*/
	//NSLog(@"Disabling screen saver because of user activity.");
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	NSSet *aSet = [event touchesForView:[self view]]; //clockView
	if ([aSet count] > 0) {
		[self switchToClockView];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
