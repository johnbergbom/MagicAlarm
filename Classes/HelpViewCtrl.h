//
//  HelpViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	UILabel *remAwakening;
	UILabel *snoozeInterrupt;
	UILabel *shockAlarm;
	UILabel *teaser;
	UILabel *goesDimAfter;
	UILabel *batterySaving;
	//UITextView *textView;
}

//@property (nonatomic, retain) UITableView *myTableView;

@end
