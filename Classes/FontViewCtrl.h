//
//  FontViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FontViewCtrl : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource> {
	UITableView	*myTableView;
	NSMutableArray *fontList;
	UIPickerView *picker;
	int font;
}

- (id)initWithHeadline:(NSString *)headline;
- (void)initFontsMenu;

@property int font;

@end
