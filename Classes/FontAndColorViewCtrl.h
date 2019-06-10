//
//  FontAndColorViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontViewCtrl.h"
#import "ColorViewCtrl.h"


@interface FontAndColorViewCtrl : UITableViewController {
	NSMutableArray *menuList;
	FontViewCtrl *fontViewCtrl;
	ColorViewCtrl *fgColorViewCtrl;
	ColorViewCtrl *bgColorViewCtrl;
	NSMutableArray *fgColors;
	NSMutableArray *bgColors;
}

- (void) initFgColors;
- (void) initBgColors;

@property FontViewCtrl *fontViewCtrl;
@property ColorViewCtrl *fgColorViewCtrl;
@property ColorViewCtrl *bgColorViewCtrl;

@end
