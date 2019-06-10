//
//  ClockViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"
//#import "FlipViewCtrl.h"


@interface ClockViewCtrl : UIViewController {
	ClockView *clockView;
	UIButton *button;
	id flipViewCtrl;
	UIInterfaceOrientation old_orientation;
	UIInterfaceOrientation new_orientation;
	int old_pseudo_orientation;
	int new_pseudo_orientation;
	BOOL correction_rotation_done;
	CGAffineTransform _originalTransform;
	CGRect _originalBounds;
	CGPoint _originalCenter;
	BOOL initiated;
}

//- (void)toggleView:(id)sender;
-(void) turnAround;

@property (retain) UIButton *button;
@property (assign) id flipViewCtrl;
@property UIInterfaceOrientation old_orientation;
@property UIInterfaceOrientation new_orientation;
@property int old_pseudo_orientation;
@property int new_pseudo_orientation;
@property BOOL correction_rotation_done;
@property (assign) ClockView *clockView;

@end
