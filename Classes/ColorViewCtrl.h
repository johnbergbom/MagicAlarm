//
//  ColorViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	NSInteger r_level;
	NSInteger g_level;
	NSInteger b_level;
	UISlider *rLevelSlider;
	UISlider *gLevelSlider;
	UISlider *bLevelSlider;
	NSMutableArray *colors;
	NSMutableArray *buttons;
	NSString *prefix;
}

- (id)initWithHeadline:(NSString *)headline andColors:(NSMutableArray *)colorArray andPrefix:(NSString *)prefixStr;
- (void) initButtons;
- (void) storeRGBValues;

@property NSInteger r_level;
@property NSInteger g_level;
@property NSInteger b_level;

@end
