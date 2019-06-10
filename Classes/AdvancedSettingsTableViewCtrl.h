//
//  AdvancedSettingsTableViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#ifndef _ADVANCEDSETTINGSTABLEVIEWCTRL_
//#define _ADVANCEDSETTINGSTABLEVIEWCTRL_

#import <UIKit/UIKit.h>
#import "FontAndColorViewCtrl.h"
#import "ClockView.h"
#import "SoundThemeView.h"
#import "Node.h"

//int fontColor;

@interface AdvancedSettingsTableViewCtrl : UITableViewController {
	
	NSMutableArray *menuList;
	BOOL show_date;
	BOOL lock_screen; //qqq
	NSInteger snooze_interval;
	NSInteger goes_dim_after;
	NSInteger dimming_level;
	NSInteger rem_length;
	NSInteger wakeup_master_volume;
	UISlider *snoozeSlider;
	UISlider *goesDimSlider;
	UISlider *dimmingLevelSlider;
	UISlider *remLengthSlider;
	UISlider *wakeupVolumeSlider;
	FontAndColorViewCtrl *fontAndColorViewCtrl;
	int font;
	int fontColorIndex;
	//int backgroundColorIndex;
	//CGColorRef *fontColor;
	UIColor *fontColor;
	//CGColorRef bgColor;
	UIColor *bgColor;
	//BOOL american_time_style;
	//ClockView *fontAndColorSubView;
	Node *sound_theme;
	NSString *sound_theme_filename;
	SoundThemeView *soundThemeView;
	
	//int blinkBefore;
	id parentObj;
}

- (id)initWithParent:(id)obj;
- (NSMutableArray *)initializeClockSectionItems;
- (NSMutableArray *)initializeThemeSectionItems;

@property int font;
//@property CGColorRef *fontColor;
@property (retain) UIColor *fontColor;
//@property CGColorRef bgColor;
@property (retain) UIColor *bgColor;
@property (retain) Node *sound_theme;
@property (retain) NSString *sound_theme_filename;
//@property (retain) ClockView *fontAndColorSubView;
@property BOOL show_date;
@property BOOL lock_screen; //qqq
@property NSInteger dimming_level;
@property NSInteger goes_dim_after;
@property NSInteger snooze_interval;
@property NSInteger rem_length;
@property NSInteger wakeup_master_volume;
@property FontAndColorViewCtrl *fontAndColorViewCtrl;
@property id parentObj;

@end

//#endif       //_ADVANCEDSETTINGSTABLEVIEWCTRL_

