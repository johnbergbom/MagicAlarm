//
//  ClockViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//The view is declared to change size automatically when changing the orientation
//of the phone, and the drawRect function of the ClockView makes sure that the
//clock's numbers are drawn relative to the width of the view.

#import "ClockViewCtrl.h"
#import "FlipViewCtrl.h"
#import "MainViewController.h"


@implementation ClockViewCtrl

@synthesize button;
@synthesize flipViewCtrl;
@synthesize old_orientation;
@synthesize new_orientation;
@synthesize old_pseudo_orientation;
@synthesize new_pseudo_orientation;
@synthesize correction_rotation_done;
@synthesize clockView;

 // The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
	  // Custom initialization
	  //self.navigationItem.title = @"Current time";
	  self.title = @"Clock";
	  self.tabBarItem.image = [UIImage imageNamed:@"clock.png"];

	  self.navigationItem.title = @"Current time";
	  //CGSize preferredSize;
	  //preferredSize.height = 100;
	  //preferred
	  //CGSize size = self.view.sizeThatFits;
	  
	  /* Don't do directly "self.view = clockView", because then it's not possible to
	   change the x/y starting coordinates. Rather make an empty view and put the
	   clockView inside that empty view. */
	  UIView *uiView = [[UIView alloc] init];
	  self.view = uiView; //[window addSubview:boardView];
	  [self.view setFrame:CGRectMake(0, 0, 320, 480)];
	  self.view.backgroundColor = [UIColor brownColor]; //zzz
	  self.view.autoresizesSubviews = YES;
	  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	  //self.view.userInteractionEnabled = YES;
	  //uiView.backgroundColor = [UIColor blackColor];
	  //uiView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	  //uiView.clearsContextBeforeDrawing = YES;
	  //uiView.contentMode = UIViewContentModeRedraw;
	  //[uiView sizeToFit];
	  self.correction_rotation_done = NO;
	  
	  UIScreen *screen = [UIScreen mainScreen];
	  //clockView = [[ClockView alloc] initWithSizeX:280 andSizeY:150 x:20 y:120 andFont:font andFontColor:fontColor andBgColor:bgColor andUpdateClock:YES];
	  clockView = [[ClockView alloc] initWithSizeX:280 andSizeY:340 x:20 y:screen.bounds.size.height/2-170-5 /*andFont:font andFontColor:fontColor andBgColor:bgColor*/ andStatic:NO];
	  //clockView.frame = CGRectMake(20.0, 120.0, 300.0, 150.0);
	  //[clockView setBounds:CGRectMake(20, screen.bounds.size.height/2-75, screen.bounds.size.width-40, 150)];
	  //ClockView *clockView = [[ClockView alloc] initWithSizeX:300 andSizeY:150 x:20 y:self.parentViewController.view.bounds.size.height];
	  //ClockView *clockView = [[ClockView alloc] initWithSizeX:300 andSizeY:150 x:self.view.center.x y:self.view.center.y];
	  //ClockView *clockView = [[ClockView alloc] initWithFrame:self.view.frame];
	  //ClockView *clockView = [[ClockView alloc] initWithSizeX:uiView.superview.bounds.size.width-20 andSizeY:uiView.superview.bounds.size.height-20 x:100 y:100];
	  //clockView.contentMode = UIViewContentModeRedraw;
	  //clockView.backgroundColor = [UIColor blackColor];
	  //clockView.autoresizesSubviews = YES;
	  //clockView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	  //clockView.userInteractionEnabled = YES;
	  //clockView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
	  clockView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
	  //[clockView sizeToFit];
	  
	  button = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
	  button.frame = CGRectMake(20.0, 20.0, 20.0, 20.0);
	  //button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 25.0, 25.0)];
	  ////[button setTitle:@"Detail Disclosure" forState:UIControlStateNormal];
	  button.backgroundColor = [UIColor clearColor];
	  //button.highlighted = YES;
	  button.enabled = YES;
	  button.showsTouchWhenHighlighted = YES;
	  //button.userInteractionEnabled = YES;
	  //button.exclusiveTouch = NO;
	  //button.selected = YES;
	  //[button addTarget:self action:@selector(toggleView:) forControlEvents:UIControlEventTouchUpInside];
	  //[uiButton release];
	  [self.view addSubview:button];
	  
	  [self.view addSubview:clockView];
	  //[self.view insertSubview:clockView belowSubview:button];
	  /*CGPoint cp;
	   cp.x = self.view.center.x + 10;
	   cp.y = self.view.center.y + 10;
	   clockView.center = cp;*/
	  
	  //CGRect redFrame = CGRectMake(10, 10, 100, 100);
	  //BoardView *boardView = [[BoardView alloc] initWithFrame:redFrame];
	  //boardView.backgroundColor = [UIColor redColor];
	  //if (self.view != nil)
	  //	self.view = uiView; //[window addSubview:boardView];
	  //else
	  //[self.view addSubview:clockView];
	  //[clockView release];
  }
  return self;
}

-(void) setSettings:(SettingsTableViewCtrl *)settings {
	//NSLog(@"john: setSettings called");
	clockView.settings = settings;
	//if(settings == nil)
	//	NSLog(@"john: settings set to NIL");	
}

-(void) setFlippis:(FlipViewCtrl *)flipViewCtrl {
	//NSLog(@"john: setSettings called");
	clockView.flipViewCtrl = flipViewCtrl;
	//if(settings == nil)
	//	NSLog(@"john: settings set to NIL");	
}

/*- (void)toggleView:(id)sender {
	//[flipViewCtrl toggleView:sender];
	//[clockView updateTime:nil];
	[clockView removeFromSuperview];
	[self.view setNeedsDisplay];
}*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	//if(isViewPushed == NO) {
		
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
												  //initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
												  initWithTitle:@"Settings"  style:UIBarButtonItemStyleBordered
												  target:self action:@selector(cancel_Clicked:)] autorelease];
		//UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
		//							   initWithTitle:@"Show clock" style:UIBarButtonItemStyleBordered target:self action:@selector(info_clicked:)];
		/*self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
		 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
		 target:nil action:nil] autorelease];*/
		
		
	//}
}

- (void) viewWillDisappear:(BOOL)animated {
	//old_orientation = self.interfaceOrientation;
	_originalTransform = [self.view transform];
	_originalBounds = [self.view bounds];
	_originalCenter = [self.view center];
	initiated = YES;
}

-(void) turnAround {
	return;
	if (old_orientation != UIInterfaceOrientationPortrait
		&& self.interfaceOrientation == UIInterfaceOrientationPortrait
		&& (((FlipViewCtrl *) flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeLeft
			|| ((FlipViewCtrl *) flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		int dir;
		CGAffineTransform portraitTransform;
		CGRect b;
		CGPoint cp;
		portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
		b = CGRectMake(0,0,320,460);
		cp = CGPointMake(160,230);
		[self.view setTransform:portraitTransform];
	}
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	return;
	/*return;
	if (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation != UIInterfaceOrientationPortrait) {
		int dir = (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeRight ? -1 : 1);
		if (initiated) {
			CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			if (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
				portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			else
				portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			[self.view setTransform:portraitTransform];
			[self.view setBounds:_originalBounds];
			[self.view setCenter:_originalCenter];
		}
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
	}
	return;*/
	if (1 == 0 && self.interfaceOrientation != UIInterfaceOrientationPortrait) {
		CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(0));
		[self.view setTransform:portraitTransform];
		[self.view setBounds:CGRectMake(0,0,320,480)];
		[self.view setCenter:CGPointMake(160,240)];
	}
	if (1 == 1 || self.interfaceOrientation != old_orientation /*((FlipViewCtrl *) flipViewCtrl).interfaceOrientation*/ /*[UIApplication sharedApplication].statusBarOrientation*/
		/*&& old_orientation != UIInterfaceOrientationPortrait*/
		/*&& [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait*/) {
		if (/*(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
			 && old_orientation == UIInterfaceOrientationPortrait)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				&& old_orientation == UIInterfaceOrientationPortraitUpsideDown)
			|| */(/*(((FlipViewCtrl *) flipViewCtrl).tabBarController).interfaceOrientation != UIInterfaceOrientationPortrait
				  && */
				  /*((((FlipViewCtrl *) flipViewCtrl).tabBarController).interfaceOrientation == UIInterfaceOrientationPortrait
				   || old_orientation == UIInterfaceOrientationPortrait)*/
				  //((FlipViewCtrl *) flipViewCtrl).interfaceOrientation == (((FlipViewCtrl *) flipViewCtrl).tabBarController).interfaceOrientation
				  //(((FlipViewCtrl *) flipViewCtrl).tabBarController).interfaceOrientation != UIInterfaceOrientationPortrait
				  /*!correction_rotation_done
				  && */old_orientation != UIInterfaceOrientationPortrait
				  && self.interfaceOrientation == UIInterfaceOrientationPortrait
				&& (((FlipViewCtrl *) flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				  || ((FlipViewCtrl *) flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeRight))
			/*|| (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				&& old_orientation == UIInterfaceOrientationLandscapeRight)
			
			|| (self.interfaceOrientation == UIInterfaceOrientationPortrait
				&& old_orientation == UIInterfaceOrientationLandscapeRight)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				&& old_orientation == UIInterfaceOrientationLandscapeLeft)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				&& old_orientation == UIInterfaceOrientationPortrait)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
				&& old_orientation == UIInterfaceOrientationPortraitUpsideDown)*/) {
			int dir;
			CGAffineTransform portraitTransform;
			CGRect b;
			CGPoint cp;
			//portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(0));
			//[self.view setTransform:portraitTransform];
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[self.view setTransform:portraitTransform];
			//[self.view setBounds:b];
			//[self.view setCenter:cp];
			//[clockView removeFromSuperview];
			correction_rotation_done = YES;
		} else if (1 == 0) {
			CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(0));
			[self.view setTransform:portraitTransform];
			//[self.view setBounds:CGRectMake(0,0,320,480)];
			//[self.view setCenter:CGPointMake(160,240)];
		}
		//[clockView removeFromSuperview];
	}
	return;
	if (self.interfaceOrientation != old_orientation /*((FlipViewCtrl *) flipViewCtrl).interfaceOrientation*/ /*[UIApplication sharedApplication].statusBarOrientation*/
		&& old_orientation != UIInterfaceOrientationPortrait
		&& [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
		if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
			&& old_orientation == UIInterfaceOrientationPortrait)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				&& old_orientation == UIInterfaceOrientationPortraitUpsideDown)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortrait
				&& old_orientation == UIInterfaceOrientationLandscapeLeft)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				&& old_orientation == UIInterfaceOrientationLandscapeRight)
			
			|| (self.interfaceOrientation == UIInterfaceOrientationPortrait
				&& old_orientation == UIInterfaceOrientationLandscapeRight)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				&& old_orientation == UIInterfaceOrientationLandscapeLeft)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				&& old_orientation == UIInterfaceOrientationPortrait)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
				&& old_orientation == UIInterfaceOrientationPortraitUpsideDown)) {
			int dir;
			CGAffineTransform portraitTransform;
			CGRect b;
			CGPoint cp;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[self.view setTransform:portraitTransform];
			//[self.view setBounds:b];
			//[self.view setCenter:cp];
			//[clockView removeFromSuperview];
		}
		//[clockView removeFromSuperview];
	}
	return;
	if (self.interfaceOrientation != old_orientation /*((FlipViewCtrl *) flipViewCtrl).interfaceOrientation*/ /*[UIApplication sharedApplication].statusBarOrientation*/) {
		if ((self.interfaceOrientation == UIInterfaceOrientationLandscapeRight
			 && old_orientation == UIInterfaceOrientationLandscapeLeft)
			|| (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft
				&& old_orientation == UIInterfaceOrientationLandscapeRight)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortrait
				&& old_orientation == UIInterfaceOrientationPortraitUpsideDown)
			|| (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
				&& old_orientation == UIInterfaceOrientationPortrait)) {
			int dir;
			CGAffineTransform portraitTransform;
			CGRect b;
			CGPoint cp;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[self.view setTransform:portraitTransform];
			//[self.view setBounds:b];
			//[self.view setCenter:cp];
			[clockView removeFromSuperview];
		}
		//[clockView removeFromSuperview];
	}
	return;
	//[UIApplication sharedApplication].statusBarOrientation = ((FlipViewCtrl *)flipViewCtrl).interfaceOrientation;
	//return;
	if (old_orientation != self.interfaceOrientation) {
		//[UIApplication sharedApplication].statusBarOrientation = self.interfaceOrientation;
		//return;
		int dir;
		CGAffineTransform portraitTransform;
		CGRect b;
		CGPoint cp;
		if (old_orientation == UIInterfaceOrientationPortrait
			&& self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			dir = -1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationPortrait
				   && self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			dir = 1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationPortrait
				   && self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			[clockView removeFromSuperview];

		} else if (old_orientation == UIInterfaceOrientationLandscapeRight
				   && self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			dir = 1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);
			[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationLandscapeRight
				   && self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);
			[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationLandscapeRight
				   && self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			dir = -1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);
			[clockView removeFromSuperview];

		} else if (old_orientation == UIInterfaceOrientationLandscapeLeft
				   && self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			/*dir = -1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);*/
			//[clockView removeFromSuperview]; //zzz: start->Clock view->(rotate right)->info->Clock view
			dir = 1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			b = CGRectMake(0,0,320,480);
			cp = CGPointMake(160,240);
		} else if (old_orientation == UIInterfaceOrientationLandscapeLeft
				   && self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);
			//[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationLandscapeLeft
				   && self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			dir = 1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			b = CGRectMake(0,0,460,320);
			cp = CGPointMake(230,160);
			//[clockView removeFromSuperview];

		} else if (old_orientation == UIInterfaceOrientationPortraitUpsideDown
				   && self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
			dir = 1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			//[clockView removeFromSuperview];
		} else if (old_orientation == UIInterfaceOrientationPortraitUpsideDown
				   && self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
			dir = -1;
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			//[clockView removeFromSuperview];
		} else { //if (old_orientation == UIInterfaceOrientationPortraitUpsideDown
				 //  && self.interfaceOrientation == UIInterfaceOrientationPortrait) {
			portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(180));
			b = CGRectMake(0,0,320,460);
			cp = CGPointMake(160,230);
			//[clockView removeFromSuperview];
		}
		[self.view setTransform:portraitTransform];
		[self.view setBounds:b];
		[self.view setCenter:cp];
		//[clockView removeFromSuperview];
		self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.view.autoresizesSubviews = YES;
		//[UIApplication sharedApplication].statusBarOrientation = ((FlipViewCtrl *)flipViewCtrl).interfaceOrientation;
		//[UIApplication sharedApplication].statusBarOrientation = self.interfaceOrientation;
	}
	return;
	if (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation != UIInterfaceOrientationPortrait) {
		int dir = (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeRight ? -1 : 1);
		//if (initiated) {
			CGAffineTransform portraitTransform = CGAffineTransformMakeRotation(degreesToRadian(dir*90));
			if (((FlipViewCtrl *)flipViewCtrl).interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
				portraitTransform = CGAffineTransformTranslate (portraitTransform, -80.0, -80.0);
			else
				portraitTransform = CGAffineTransformTranslate (portraitTransform, 80.0, 80.0);
			[self.view setTransform:portraitTransform];
			////[self.view setBounds:_originalBounds];
			//CGPointMake(_originalCenter.x+80,_originalCenter.y-80);
			//[self.view setCenter:CGPointMake(_originalCenter.x-80,_originalCenter.y+80)];
			////[self.view setCenter:_originalCenter];
			/*UIScreen *screen = [UIScreen mainScreen];
			 [self.view setBounds:CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width)];
			 [self.view setTransform:CGAffineTransformConcat(self.view.transform, CGAffineTransformMakeRotation(degreesToRadian(90)))];
			 [self.view setCenter:[[UIApplication sharedApplication] keyWindow].center];*/
			//self.view.frame.origin.y = 0.0;
			//[self.view setBounds:CGRectMake(0.0, 0.0, 320.0, 480.0)];
		//}
		//CGContextRef context = UIGraphicsGetCurrentContext();
		//CGContextRotateCTM(context,degreesToRadian(90));
		//self.view.bounds  = CGRectMake(0.0, 0.0, 320.0, 480.0);
		//self.view.center  = CGPointMake (156.0, 240.0);
		//self.view.frame = CGRectMake(0,0,320,360);
		//[self.view
		
		//[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
	}
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[clockView setNeedsDisplay];
}

-(void) cancel_Clicked:(id)sender {
	
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//[self.view setNeedsDisplay];
	//CGAffineTransform transform = CGAffineTransformMakeRotation(3.14159/2);
	//CGAffineTransform transform = CGAffineTransformMakeRotation(3.14159/2);
	//self.view.transform = transform;
	
	//correction_rotation_done = YES;
	old_orientation = interfaceOrientation;
	return YES; //return no here, because rotation is taken care of programmatically
}*/

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[clockView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//}

- (void)dealloc {
	[button release];
	[clockView stopUpdateTimer];
	[clockView release];
    [super dealloc];
}


@end
