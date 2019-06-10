//
//  SetTimeViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#ifndef _SETTIMEVIEWCTRL_
//#define _SETTIMEVIEWCTRL_

#import <UIKit/UIKit.h>


@interface SetTimeViewCtrl : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	//UIPickerView *pickerView;
	UIDatePicker *datePicker;
	//UILabel *wakeUpTimeInfo;
	id parentObj;
}

@property (assign) UIDatePicker *datePicker;
@property (assign) UITableView	*myTableView;

- (id)initWithParent:(id)obj;

@end

//#endif       //_SETTIMEVIEWCTRL_
