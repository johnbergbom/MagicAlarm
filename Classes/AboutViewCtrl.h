//
//  AboutViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	UITextView *remAwakening;
	UITextView *textView;
}

//@property (nonatomic, retain) UITableView *myTableView;

@end
