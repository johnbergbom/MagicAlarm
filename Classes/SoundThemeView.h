//
//  SoundThemeView.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AdvancedSettingsTableViewCtrl.h"

@interface SoundThemeView : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	UIPickerView *pickerView;
	id parentObj;
	NSMutableArray *pickerItems;
	NSString *temp;
	UITableView	*myTableView;
	UILabel *textLabel;
}

- (id)initWithParent:(id)obj andTheme:(NSString *)theme;
- (void)initializeThemeList;
//- (void)selectedItem:(NSString *)theme;

@end
