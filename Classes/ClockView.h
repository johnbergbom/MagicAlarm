//
//  ClockView.h
//  REMAlarmClock
//
//  Created by John Bergbom on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//#ifndef _CLOCKVIEW_
//#define _CLOCKVIEW_

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
//#import "SettingsTableViewCtrl.h"
#import "Node.h"
//#import "SilentSound.h"

@class SettingsTableViewCtrl;

#define PHASE_IDLE 0
#define PHASE_REM 1
#define PHASE_WAKEUP 2
#define PHASE_SNOOZE 3
#define PHASE_SHOCK 4

@interface ClockView : UIView <AVAudioPlayerDelegate, UIAlertViewDelegate> {
	//float cellWidth;
	//float cellHeight;
	//float numberWidth;
	//float numberHeight;
	//float letterWidth;
	//float letterHeight;
	//float dotWidth;
	//float dotHeight;
	//float light[4];
	//float dark[4];
	//float select[4];
	//float lastmove_color[4];
	UIImage *number_graphics[2][10];
	//UIImage *dot_graphics[3];
	UIImage *colon_graphics[2];
	/*UIImage *a_graphics[3];
	UIImage *d_graphics[3];
	UIImage *e_graphics[3];
	UIImage *f_graphics[3];
	UIImage *h_graphics[3];
	UIImage *i_graphics[3];
	UIImage *m_graphics[3];
	UIImage *n_graphics[3];
	UIImage *o_graphics[3];
	UIImage *p_graphics[3];
	UIImage *r_graphics[3];
	UIImage *s_graphics[3];
	UIImage *t_graphics[3];
	UIImage *u_graphics[3];
	UIImage *w_graphics[3];*/
	UIImage *background8[6];
	/*UIImage *bgGreen;
	UIImage *bild;
	UIImage *mask;
	UIImage *aa;
	UIImage *bb;*/
	BOOL statisk;
	//UIImage *clock_icon;
	UIImage *alarm_on_icon;
	NSDate *curr_time;
	NSDate *last_activity_time;
	NSDate *dimmed_at;
	//int font;
	//UIColor *fontColor;
	//UIColor *bgColor;
	NSTimer *timeUpdater;
	AVAudioPlayer *player;
	//CGFloat alpha;
	UILabel *dateLabel;
	SettingsTableViewCtrl *settings;
	//BOOL blinking;
	int blinking_state;
	int phase;
	NSMutableArray *subphases;
	//NSMutableArray *subphases_order;
	Node *curr_subphase;
	Node *curr_sound_action;
	Node *curr_light_action;
	Node *curr_action;
	//NSDate *subPhaseTime;
	NSDate *scheduled_sound_start_time;
	NSDate *scheduled_sound_stop_time;
	NSString *scheduled_sound_file_name;
	NSString *scheduled_sound_file_type;
	BOOL scheduled_sound_fading_volume;
	int scheduled_sound_start_volume;
	//double scheduled_sound_length;
	//int latteTest;
	NSDate *snoozeTimer;
	int snooze_counter;
	int wakeup_curr_volume;
	//NSDate *last_soundtheme_check;
	BOOL screen_locked; //qqq
	//int soundPlaying;
	//SilentSound *silentSound;
	id flipViewCtrl;
	//int curr_alarm_volume;
	UIColor *oldBgCol;
	BOOL phase_init_done;
}

//- (id)initWithSizeX:(int)sizeX andSizeY:(int)sizeY x:(int)originX y:(int)originY;
- (id)initWithSizeX:(int)sizeX andSizeY:(int)sizeY x:(int)originX y:(int)originY /*andFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol*/ andStatic:(BOOL)s;
- (id)initWithFrame:(CGRect)frame /*andFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol*/ andStatic:(BOOL)s;
//- (void)updateFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol;
//-(void)updateFont:(int)f;
//-(void)updateFontColor:(UIColor *)fontCol;
//-(void)updateBgColor:(UIColor *)bgCol;
- (void)stopUpdateTimer;
//- (void)setAlpha:(CGFloat)a;
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
- (void) playSoundFromResource:(NSString *)fileName ofType:(NSString *)type withVolume:(int)volume
				   withRepeats:(NSInteger) repeats;
- (void) stopScheduledBgSound;
- (void) scheduleBgSoundWithResource:(NSString *)fileName ofType:(NSString *)type
						fadingVolume:(BOOL)fadingVolume startVolume:(int)startVolume playingTime:(int)minutes;
//- (UIImage *) bgImageWithColor:(UIColor *)color;
- (void)checkSoundTheme;
- (void) stopAlarmSound;
- (void)startUpdateTimer:(double)period;
- (void) updateScheduledSoundFileName:(NSString *)fileName ofType:(NSString *)type;
- (void) updateScheduledSoundPlayingTime:(int)seconds;
- (void) updateScheduledSoundStartingVolume:(int)startVolume;
- (void) disableScreenSaver;
- (void) enableScreenSaver;

//@property int font;
//@property (retain) UIColor *fontColor;
//@property (retain) UIColor *bgColor;
@property (retain) AVAudioPlayer *player;
//@property CGFloat alpha;
@property (assign) SettingsTableViewCtrl *settings;
@property (assign) NSDate *last_activity_time;
@property int phase;
@property BOOL screen_locked; //qqq
@property NSDate *dimmed_at;
//@property int soundPlaying;
@property id flipViewCtrl;
@property NSMutableArray *subphases;

@end

//#endif       //_CLOCKVIEW_
