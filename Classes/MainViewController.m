//
//  MainViewController.m
//  REMAlarmClock
//
//  Created by John Bergbom on 3/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
//#import "MainView.h"

@implementation MainViewController

@synthesize flipViewCtrl;
@synthesize prevItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		self.delegate = self;
		//initiated = NO;
    }
    return self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
	//[super tabBarController:tabBarController didEndCustomizingViewControllers:viewControllers changed:changed];
	//[super 
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	//[super tabBarController:nil didSelectViewController:nil];
	if ([viewController.title isEqualToString:@"Clock"]) {
		[flipViewCtrl switchToClockView];
	} else {
		prevItem = [self selectedIndex];
		
		/* There seems to be a bug in the navigation bar that gives it the wrong size in some
		   circumstances (when rotations have been done). This workaround fixes the problem. */
		if (tabBarController.selectedIndex == 1) {
			UINavigationController *navContr = ((UINavigationController *)tabBarController.selectedViewController);
			[navContr.rotatingHeaderView setFrame:CGRectMake(0,0,320,44)];
		}
	}
}

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;

	/*if (initiated) {
		[self.view setTransform:_originalTransform];
		//CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(90));
		//[self.view setTransform:portraitTransform];
		[self.view setBounds:_originalBounds];
		[self.view setCenter:_originalCenter];
	}*/
	
	/*if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 0)
		flipViewCtrl.view.backgroundColor = [UIColor blackColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 1)
		flipViewCtrl.view.backgroundColor = [UIColor whiteColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 2)
		flipViewCtrl.view.backgroundColor = [UIColor yellowColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 3)
		flipViewCtrl.view.backgroundColor = [UIColor greenColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 4)
		flipViewCtrl.view.backgroundColor = [UIColor redColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 5)
		flipViewCtrl.view.backgroundColor = [UIColor blueColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 6)
		flipViewCtrl.view.backgroundColor = [UIColor grayColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 7)
		flipViewCtrl.view.backgroundColor = [UIColor orangeColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 8)
		flipViewCtrl.view.backgroundColor = [UIColor whiteColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 9)
		flipViewCtrl.view.backgroundColor = [UIColor yellowColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 10)
		flipViewCtrl.view.backgroundColor = [UIColor greenColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 11)
		flipViewCtrl.view.backgroundColor = [UIColor redColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 12)
		flipViewCtrl.view.backgroundColor = [UIColor blueColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 13)
		flipViewCtrl.view.backgroundColor = [UIColor grayColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation == 14)
		flipViewCtrl.view.backgroundColor = [UIColor orangeColor];
	else if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation > 14)
		flipViewCtrl.view.backgroundColor = [UIColor purpleColor];*/

	//[super viewWillAppear:animated];
	if (/*(*/flipViewCtrl.interfaceOrientation != UIInterfaceOrientationPortrait
		/*&& ((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_pseudo_orientation < 7)*/
		|| (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortrait)) {
	//if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_orientation == UIInterfaceOrientationPortrait
	//	flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortrait) {
	//if (((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).old_orientation != ((ClockViewCtrl *)flipViewCtrl.clockViewCtrl).new_orientation
	//	&& flipViewCtrl.interfaceOrientation != UIInterfaceOrientationPortrait) {
	//if (flipViewCtrl.interfaceOrientation != UIInterfaceOrientationPortrait) {
		int dir = (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeRight ? -1 : 1);
		if (initiated) {
			CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
				portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			else
				portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
				NSLog(@"right");
			else if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
				NSLog(@"left");
			else if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortrait)
				NSLog(@"portrait");
			else if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
				NSLog(@"portraitupsidedown");
			else
				NSLog(@"okand");
			if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				|| flipViewCtrl.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				NSLog(@"a");
				//[self.view setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
				[self.view setTransform:portraitTransform];
				[self.view setBounds:_originalBounds];
				[self.view setCenter:_originalCenter];
			} else if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortrait) {
				NSLog(@"b");
				//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
				portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(0));
				[self.view setTransform:portraitTransform];
				[self.view setBounds:CGRectMake(0,0,320,480)];
				[self.view setCenter:CGPointMake(160,240)];
			} else if (flipViewCtrl.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
				NSLog(@"c");
				//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
				portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
				[self.view setTransform:portraitTransform];
				[self.view setBounds:CGRectMake(0,0,320,480)];
				[self.view setCenter:CGPointMake(160,240)];
			}
			//CGPointMake(_originalCenter.x+80,_originalCenter.y-80);
			//[self.view setCenter:CGPointMake(_originalCenter.x-80,_originalCenter.y+80)];
			/*UIScreen *screen = [UIScreen mainScreen];
			 [self.view setBounds:CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width)];
			 [self.view setTransform:CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(degreesToRadian(90)))];
			 [self.view setCenter:[[UIApplication sharedApplication] keyWindow].center];*/
			//self.view.frame.origin.y = 0.0;
			//[self.view setBounds:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		}
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		//CGContextRef context = UIGraphicsGetCurrentContext();
		//CGContextRotateCTM(context,degreesToRadian(90));
		//self.view.bounds  = CGRectMake(0.0, 0.0, 320.0, 480.0);
		//self.view.center  = CGPointMake (156.0, 240.0);
		//self.view.frame = CGRectMake(0,0,320,360);
		//[self.view
		
		////[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	_originalTransform = [self.view transform];
	_originalBounds = [self.view bounds];
	_originalCenter = [self.view center];
	initiated = YES;
	//[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight; 
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//self.selectedViewController.view.hidden = YES;
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//return NO;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	orientation
//}

/*- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	//if ([self.navigationController isNavigationBarHidden]) {
		//[self.navigationController setNavigationBarHidden:NO animated:NO];
		//[self.navigationController setNavigationBarHidden:TRUE animated:NO];
	self.selectedViewController.view.hidden = YES;
	//[self.view setNavigationBarHidden:TRUE animated:NO];
	//}
}*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
