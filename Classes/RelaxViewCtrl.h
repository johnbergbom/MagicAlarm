//
//  RelaxViewCtrl.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockView.h"

@interface RelaxViewCtrl : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource> {
	UITableView	*myTableView;
	NSMutableArray *settingsList;
	//BOOL fading;
	BOOL playing_started;
	NSInteger starting_volume;
	UISlider *startingVolumeSlider;
	NSInteger playing_time;
	UISlider *playingTimeSlider;
	UIPickerView *picker;
	NSMutableArray *relaxList;
	NSString *chosen_relax_sound;
	UIProgressView *progressView;
	UIImage *start_button_image;
	UIImage *stop_button_image;
	UISegmentedControl *startStopSegmentedControl;
	ClockView *clockView;
	NSTimer *automaticSoundStopper;
	NSDate *relaxSoundStartingTime;
	NSTimer *progressUpdater;
}

- (NSMutableArray *)initializeSettingsItems;
- (void)initializeRelaxingSoundItems;

@property (retain) NSString *chosen_relax_sound;
@property (assign) ClockView *clockView;

@end
