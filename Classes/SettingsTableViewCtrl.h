//
//  SettingsTableViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#ifndef _SETTINGSTABLEVIEWCTRL_
//#define _SETTINGSTABLEVIEWCTRL_

#import <UIKit/UIKit.h>
#import "SetTimeViewCtrl.h"
#import "AdvancedSettingsTableViewCtrl.h"
#import "ClockView.h"

//@protocol UIControl
//@protocol UIPickerViewDelegate
//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
//@end

@interface SettingsTableViewCtrl : UITableViewController /*<UIPickerViewDelegate>*/ {

	NSMutableArray *menuList;
	SetTimeViewCtrl *timeViewCtrl;
	AdvancedSettingsTableViewCtrl *advancedSettingsViewCtrl;
	NSDate *alarm_time;
	BOOL alarm_turned_on;
	BOOL rem_turned_on;
	BOOL snooze_interrupt_turned_on;
	BOOL shock_alarm_turned_on;
	//BOOL teaser_turned_on;
	ClockView *clockView;
	//int test;
}

- (NSMutableArray *)initializeAlarmSectionItems;
- (NSMutableArray *)initializeClockSectionItems;
- (NSMutableArray *)initializeAdvancedSectionItems;
- (void)wakeUpTimeChanged:(UIDatePicker *) picker;
//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@property BOOL alarm_turned_on;
@property BOOL rem_turned_on;
@property NSDate *alarm_time;
@property AdvancedSettingsTableViewCtrl *advancedSettingsViewCtrl;
@property BOOL shock_alarm_turned_on;
@property BOOL snooze_interrupt_turned_on;
@property ClockView *clockView;
@property SetTimeViewCtrl *timeViewCtrl;

@end

//#endif       //_SETTINGSTABLEVIEWCTRL_
