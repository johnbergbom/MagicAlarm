//
//  ClockView.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ClockView.h"
//#import <AVAudioPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SettingsTableViewCtrl.h"
//#import "SoundThemeReader.h"
#import <AudioToolbox/AudioServices.h>
#import "Misc.h"
#import "FlipViewCtrl.h"

#define ALPHA_BACKGROUND8 0.2
#define DIMMING_LEVEL 0.5
//TODO: Set MAX_SNOOZE_COUNT_BEFORE_SHOCK to a reasonable default value (for example 2?)
#define MAX_SNOOZE_COUNT_BEFORE_SHOCK 2

@implementation ClockView

//@synthesize font;
//@synthesize fontColor;
//@synthesize bgColor;
@synthesize player;
@synthesize settings;
@synthesize last_activity_time;
@synthesize phase;
@synthesize screen_locked; //qqq
@synthesize dimmed_at;
//@synthesize soundPlaying;
@synthesize flipViewCtrl;
@synthesize subphases;

/* Scaling table for the volume is used, because without it the sound won't scale
   properly with regard to the ear's reception capability. */
/*int volume_scaling_table[101] = {
	0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,2,2,2,3,3,4,4,4,5,5,6,6,7,7,8,9,9,10,10,
	11,12,12,13,14,15,16,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,
	33,34,36,37,38,39,40,42,43,44,46,47,49,50,51,53,54,56,57,59,60,62,64,65,
	67,68,70,72,73,75,77,79,81,82,84,86,88,90,92,94,96,98,100
};*/
int volume_scaling_table[101] = {
	0,1,1,1,1,1,2,2,2,3,3,3,4,4,4,5,5,6,6,7,7,8,8,9,9,10,10,
	11,12,12,13,14,14,15,16,16,17,18,19,20,21,22,23,23,24,25,26,27,28,29,30,31,32,
	33,34,35,36,37,38,39,40,42,43,44,46,47,48,49,50,51,53,54,56,57,59,60,62,63,64,65,
	67,68,70,72,73,75,76,77,79,81,82,84,86,87,89,90,92,94,96,98,100
};
/*- (void)setAlpha:(CGFloat)a {
	self.alpha = 0.1;
	//return self.alpha;
}
*/

- (id)initWithSizeX:(int)sizeX andSizeY:(int)sizeY x:(int)originX y:(int)originY /*andFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol*/ andStatic:(BOOL)s {
	return [self initWithFrame:CGRectMake(originX,originY,sizeX,sizeY) /*andFont:f andFontColor:fontCol andBgColor:bgCol*/ andStatic:s];
}

- (id)initWithFrame:(CGRect)frame /*andFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol*/ andStatic:(BOOL)s {
	//font = f;
	//fontColor = fontCol;
	//bgColor = bgCol;
    if (self = [self initWithFrame:frame]) {
		//font = f;
		//self.fontColor = fontCol;
		//self.bgColor = bgCol;
		////self.backgroundColor = bgColor;
		statisk = s;
		//blinking = NO;
		blinking_state = 0;
		//self.delegate = self;
		phase = PHASE_IDLE;
		curr_subphase = nil;
		subphases = [[NSMutableArray alloc] init];
		//subphases_order = [[NSMutableArray alloc] init];
		if (!statisk)
			[self startUpdateTimer:1.0];
		last_activity_time = [[NSDate alloc] init];
		
		//NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		//font = [[NSUserDefaults standardUserDefaults] integerForKey:@"clockFont"];

		/* Initiate the random number generator seed from the system time. */
		time_t *t;
		t = (time_t *) malloc(1*sizeof(time_t));
		if (time(t) != -1) {
			//NSLog(@"ettan");
			srand((unsigned int)*t);
		}// else {
		//	NSLog(@"tvaan");
		//}
		free(t);
		
		//latteTest = [self get_random_number:1000];
		//NSString *latte = [[NSString alloc] initWithFormat:@"DDDlatteTest=%d:",latteTest];
		//NSLog(latte);
		//NSLog(@"self class = %@",[self class]);
	}
	return self;
}

- (void)stopUpdateTimer {
	//NSLog(@"stopUpdateTimer");
	if (timeUpdater != nil && [timeUpdater isValid]) {
		[timeUpdater invalidate];
		timeUpdater = nil;
		//[timeUpdater release];
	}
}

- (void)startUpdateTimer:(double)period {
	//NSLog(@"startUpdateTimer");
	timeUpdater = [NSTimer scheduledTimerWithTimeInterval:period
												   target:self selector:@selector(updateTime:)
												 userInfo:nil repeats:YES];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		background8[0] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_numberbackground" ofType:@"png"]];
		number_graphics[0][0] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_0_big" ofType:@"png"]];
		number_graphics[0][1] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_1_big" ofType:@"png"]];
		number_graphics[0][2] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_2_big" ofType:@"png"]];
		number_graphics[0][3] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_3_big" ofType:@"png"]];
		number_graphics[0][4] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_4_big" ofType:@"png"]];
		number_graphics[0][5] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_5_big" ofType:@"png"]];
		number_graphics[0][6] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_6_big" ofType:@"png"]];
		number_graphics[0][7] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_7_big" ofType:@"png"]];
		number_graphics[0][8] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_8_big" ofType:@"png"]];
		number_graphics[0][9] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_9_big" ofType:@"png"]];
		
		background8[1] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_numberbackground" ofType:@"png"]];
		number_graphics[1][0] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_0_big" ofType:@"png"]];
		number_graphics[1][1] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_1_big" ofType:@"png"]];
		number_graphics[1][2] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_2_big" ofType:@"png"]];
		number_graphics[1][3] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_3_big" ofType:@"png"]];
		number_graphics[1][4] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_4_big" ofType:@"png"]];
		number_graphics[1][5] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_5_big" ofType:@"png"]];
		number_graphics[1][6] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_6_big" ofType:@"png"]];
		number_graphics[1][7] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_7_big" ofType:@"png"]];
		number_graphics[1][8] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_8_big" ofType:@"png"]];
		number_graphics[1][9] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_9_big" ofType:@"png"]];
		
		colon_graphics[0] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font0_colon_big" ofType:@"png"]];
		colon_graphics[1] = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"font1_colon_big" ofType:@"png"]];
		alarm_on_icon = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"alarm_on" ofType:@"png"]];

		curr_time = [[NSDate alloc] init];
		
		dateLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		dateLabel.numberOfLines = 0;
		//[self playSoundFromResource:@"test" ofType:@"mp3" withVolume:19 withRepeats:1];
		//[self playSoundFromResource:@"relax3" ofType:@"mp3" withVolume:19 withRepeats:0];
		/*[self scheduleBgSoundWithResource:@"test"
								   ofType:@"mp3"
							 fadingVolume:YES
							  playingTime:1];*/
		screen_locked = NO; //qqq
		//soundPlaying = 0; //NO
		//curr_alarm_volume = 50;
		wakeup_curr_volume = 50; //wakeup_curr_volume will be used whenever no volume is given in the xml file
		//silentSound = [[SilentSound alloc] initWithSoundPlaying:&soundPlaying];
		//subPhaseTime = [NSDate alloc];
		phase_init_done = NO;
	}
    return self;
}

- (void)updateTime:(NSTimer*)theTimer {
	//NSLog(@"updateTime");
	////NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//NSLog(@"updateTime");
	if (curr_time != nil) {
		[curr_time release];
		curr_time = nil;
	}
	//curr_time = [NSDate init];
	curr_time = [[NSDate alloc] init];
	//NSDate *laff_time = [[NSDate alloc] init];
	//curr_time = [NSDate date];
	//TODO: Make sure that the numbers are redrawn only if it's actually necessary
	//(if a minute has passed, i.e. old_curr_time.minute != new_curr_time.minute)
	//Note: if relax sounds are played or we are in some phase other than PHASE_IDLE,
	//then we probably should call this method once per second, but otherwise once
	//per minute will probably do.
	
	[self checkSoundTheme];
	
	[self setNeedsDisplay];
	//NSLog(@"john: drawRect");
	//[self drawRect:self.frame];
	/*if (!statisk && latteTest == 0) {
		latteTest = 1;
		[self playSoundFromResource:@"test" ofType:@"mp3" withVolume:5 withRepeats:3];
	}*/
	//[curr_time autorelease];
	//[laff_time autorelease];
    ////[pool release];
}

/* Stops scheduled sounds if any. */
- (void) stopScheduledBgSound {
	if ([scheduled_sound_stop_time timeIntervalSinceNow] > 0 && player.playing) {
		//[self.player stop];
		[self stopSound];
	}
	scheduled_sound_stop_time = [[NSDate alloc] initWithTimeIntervalSinceNow:-1];  //TODO: this is probably a memory leak
}

/* Stops alarm sounds if any. */
- (void) stopAlarmSound {
	if (phase != PHASE_IDLE && player.playing) {
		//[self.player stop];
		[self stopSound];
	}
}

/* Schedule a sound to repeatedly play in the background. The volume argument should have a value between 0-100. */
- (void) scheduleBgSoundWithResource:(NSString *)fileName ofType:(NSString *)type
						fadingVolume:(BOOL)fadingVolume startVolume:(int)startVolume playingTime:(int)minutes {
	//NSLog(@"asd");
	//NSString *latte = [[NSString alloc] initWithFormat:@"innan stop=%f:",[scheduled_sound_stop_time timeIntervalSinceNow]];
	//NSLog(latte);
	scheduled_sound_start_time = [[NSDate alloc] initWithTimeIntervalSinceNow:0];  //TODO: this is probably a memory leak
	scheduled_sound_stop_time = [[NSDate alloc] initWithTimeIntervalSinceNow:minutes*60];  //TODO: this is probably a memory leak
	scheduled_sound_file_name = fileName;
	scheduled_sound_file_type = type;
	scheduled_sound_fading_volume = fadingVolume;
	scheduled_sound_start_volume = startVolume;
	//scheduled_sound_length = -1; //we don't know the length yet
	//latte = [[NSString alloc] initWithFormat:@"efter stop=%f:",[scheduled_sound_stop_time timeIntervalSinceNow]];
	//NSLog(latte);
	//latte = [[NSString alloc] initWithFormat:@"latteTest=%d:",latteTest];
	//NSLog(latte);
}

- (void) updateScheduledSoundFileName:(NSString *)fileName ofType:(NSString *)type {
	scheduled_sound_file_name = fileName;
	scheduled_sound_file_type = type;
	/* If we are already playing something, then stop the current soundfile and right away
	   start playing the new one. */
	if ([scheduled_sound_stop_time timeIntervalSinceNow] > 0 && player.playing) {
		//[self.player stop];
		[self stopSound];
		double vol = 1.0;
		if (scheduled_sound_fading_volume) {
			/* Decrease the volume according to how much time is left. */
			vol = [scheduled_sound_stop_time timeIntervalSinceNow] / [scheduled_sound_stop_time timeIntervalSinceDate:scheduled_sound_start_time];
		}
		[self playSoundFromResource:scheduled_sound_file_name ofType:scheduled_sound_file_type withVolume:(int)(scheduled_sound_start_volume*vol) withRepeats:0];
	}
}

- (void) updateScheduledSoundPlayingTime:(int)seconds {
	if ([scheduled_sound_stop_time timeIntervalSinceNow] > 0 && player.playing) {
		[scheduled_sound_stop_time release];
		scheduled_sound_stop_time = [[NSDate alloc] initWithTimeIntervalSinceNow:seconds];
	}
}

- (void) updateScheduledSoundStartingVolume:(int)startVolume {
	//NSLog(@"Updating the scheduled starting volume");
	scheduled_sound_start_volume = startVolume;
	if ([scheduled_sound_stop_time timeIntervalSinceNow] > 0 && player.playing) {
		double vol = 1.0;
		if (scheduled_sound_fading_volume) {
			/* Decrease the volume according to how much time is left. */
			vol = [scheduled_sound_stop_time timeIntervalSinceNow] / [scheduled_sound_stop_time timeIntervalSinceDate:scheduled_sound_start_time];
		}
		[self.player setVolume: (double) volume_scaling_table[(int)(scheduled_sound_start_volume*vol)]/100];    // available range is 0.0 through 1.0, and input is 0-100, so transform value
	}
}

/* This method plays one sound file, and first stops any already playing sounds. If the repeats
   parameter is zero, then the sound will be played once. The volume argument should have a value
   between 0-100. */
- (void) playSoundFromResource:(NSString *)fileName ofType:(NSString *)type withVolume:(int)volume
				   withRepeats:(NSInteger) repeats {
	//NSString *latte = [[NSString alloc] initWithFormat:@"latteTest=%d:",latteTest];
	//NSLog(latte);
	/*NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:soundPath], &soundID);
	AudioServicesPlaySystemSound (soundID);
	[soundPath release];
	return;*/
	//soundPlaying = 1; //YES
	//NSLog(@"volume = %d",volume);
	if (volume > 100)
		volume = 100;
	else if (volume <= 0) {
		NSLog(@"Skipping playing of sound");
		return;
	}
	//NSLog(@"playing sound");
	if (player != nil) {
		if (player.playing)
			[self.player stop];
		[player release];
		player = nil;
	}
	//NSString *soundFilePath =
	//[[NSBundle mainBundle] pathForResource:fileName ofType:type];
	NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:fileName ofType:type]];
	NSError *outError = nil;
	AVAudioPlayer *newPlayer =
	[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
										   error: &outError];
	if (outError != nil) {
		NSLog(@"Error playing sound: %@",[outError localizedDescription]);
		return;
	}// else
	//	NSLog(@"No error");
	[fileURL release];
	
	self.player = newPlayer;
	self.player.delegate = self;
	[newPlayer release];
	
	//ccc
	//NSString *latte = [[NSString alloc] initWithFormat:@"duration=%f:",player.duration];
	//NSLog(latte);
	
	/* Store the duration value if we are playing a scheduled sound. */
	/*if ([scheduled_sound_stop_time timeIntervalSinceNow] >= 0) {
		scheduled_sound_length = player.duration;
	}*/
	
	AudioSessionSetActive(true);
	NSLog(@"volym = %d",volume);
	//[self.player setVolume: (double) volume/100];    // available range is 0.0 through 1.0, and input is 0-100, so transform value
	[self.player setVolume: (double) volume_scaling_table[volume]/100];    // available range is 0.0 through 1.0, and input is 0-100, so transform value
	self.player.numberOfLoops = repeats;
	//NSLog(@"john: %d",self.player.numberOfLoops);
	[self.player prepareToPlay];
	[self.player play];
	
	
	/*player.volume = 0.0001;
	[player play];
	[player pause];
	[self.player setVolume: volume];    // available range is 0.0 through 1.0
	[player play];*/
	
	
	//NSLog(@"john2");
	//[self.player setDelegate: self];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	//do nothing
	NSLog(@"sound interrupted");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	//resume playing after interruption
	NSLog(@"sound interruption stopped");
	[self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playerLoc successfully:(BOOL)flag {
	//Be a good iPhone citizen and set the audio to inactive when the sound finished
	[self stopSound];
	//NSLog(@"sound stopped");
	//[self.player release];
	//self.player = nil;
}

- (void)stopSound {
	if (player != nil && player.playing)
		[self.player stop];
	//soundPlaying = 0; //NO
	//NSLog(@"clockView: turning off audio session");
	AudioSessionSetActive(false);
}

CGImageRef CopyImageAndAddAlphaChannel(CGImageRef sourceImage) {
	CGImageRef retVal = NULL;
	
	size_t width = CGImageGetWidth(sourceImage);
	size_t height = CGImageGetHeight(sourceImage);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, 
														  8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	if (offscreenContext != NULL) {
		CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
		
		retVal = CGBitmapContextCreateImage(offscreenContext);
		CGContextRelease(offscreenContext);
	}
	
	CGColorSpaceRelease(colorSpace);
	
	return retVal;
}

- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
	CGImageRef maskRef = maskImage.CGImage;
	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
										CGImageGetHeight(maskRef),
										CGImageGetBitsPerComponent(maskRef),
										CGImageGetBitsPerPixel(maskRef),
										CGImageGetBytesPerRow(maskRef),
										CGImageGetDataProvider(maskRef), NULL, false);
	
	CGImageRef sourceImage = [image CGImage];
	CGImageRef imageWithAlpha = sourceImage;
	//add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
	//this however has a computational cost
	if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone/* || CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNoneSkipFirst*/) { 
		imageWithAlpha = CopyImageAndAddAlphaChannel(sourceImage);
	}
	
	CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
	CGImageRelease(mask);
	
	//release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
	if (sourceImage != imageWithAlpha) {
		CGImageRelease(imageWithAlpha);
	}
	
	UIImage* retImage = [UIImage imageWithCGImage:masked];
	CGImageRelease(masked);
	
	return retImage;
}

/*- (void) dimmedColor:(UIColor)col {
	CGFloat *arr = (CGFloat *) CGColorGetComponents([color CGColor]);
	//CGContextSetRGBFillColor (bgPicContext, 1, 0, 0, 1);
	CGContextSetRGBFillColor (offscreenContext, arr[0],arr[1],arr[2],arr[3]);
}*/

/* This function parses a color string from the xml file and returns a color corresponding
   to that value, or the default color if the color string wasn't understood. */
- (UIColor *) parseColor:(NSString *)colorStr withFallbackColor:(UIColor *)defaultCol {
	if ([colorStr hasPrefix:@"RGB:"]) {
		//NSLog(@"parseColor: using xml specified color");
		NSArray *rgbComp = [[colorStr substringFromIndex:4] componentsSeparatedByString:@","];
		return [UIColor colorWithRed:(float)[[rgbComp objectAtIndex:0] intValue]/255
							   green:(float)[[rgbComp objectAtIndex:1] intValue]/255
								blue:(float)[[rgbComp objectAtIndex:2] intValue]/255 alpha:1.0];
	} else/* if ([colorStr isEqualToString:@"Rainbow"] || [colorStr isEqualToString:@"Random"])*/ { //default is random
		//NSLog(@"parseColor: using random color");
		return [UIColor colorWithRed:(float)[Misc get_random_number:255]/255
							   green:(float)[Misc get_random_number:255]/255
								blue:(float)[Misc get_random_number:255]/255 alpha:1.0];
	}
	//NSLog(@"parseColor: using default color");
	//return defaultCol;
}

- (void)ownFontsDrawRect:(CGRect)rect withFont:(int)f andFontColor:(UIColor *)fC andBgColor:(UIColor *)bgC
		  andDimingLevel:(int)dimmingLevel andLightAction:(Node *)light_action {
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	// Determine if glow is used
	/*float glowAfter = 1.0;
	
	CGFloat *array1;
	array1 = (CGFloat *) CGColorGetComponents([fC CGColor]);
	
	CGFloat *array2;
	array2 = (CGFloat *) CGColorGetComponents([bgC CGColor]);
	
	float red_multipler = 0.6;
	float green_multipler = 0.5;
	float blue_multipler = 1.0;
	
	float glowIndex1 = array1[0]*red_multipler + array1[1]*green_multipler + array1[2]*blue_multipler;
	float glowIndex2 = array2[0]*red_multipler + array2[1]*green_multipler + array2[2]*blue_multipler;
	
	NSLog(@"tomi: foreGround array[0]=%f, array[1]=%f, array[2]=%f, array[3]=%f, glowIndex=%f", array1[0],array1[1],array1[2],array1[3],glowIndex1);
	NSLog(@"tomi: backGround array[0]=%f, array[1]=%f, array[2]=%f, array[3]=%f, glowIndex=%f", array2[0],array2[1],array2[2],array2[3],glowIndex2);
	
	if(glowIndex2 - glowIndex1 >= glowAfter)
		NSLog(@"tomi: Glow is used");*/
	
    // Drawing code
	
	/* If light_action is set, then determine the proper colors to use, and make sure there is no dimming. */
	////UIColor *oldBgCol = nil;
	if (light_action != nil) {
		/*for (Node *node in light_action.children) {
			NSLog(@"Child has key %@",[node key]);
			//if ([[node key] isEqualToString:@"Type"])
			//	return node;
		}*/
		if ([[light_action getValueForKey:@"Type"] isEqualToString:@"Steady_light"]) {
			//NSLog(@"Steady light light_action in ownFontsDrawRect");
			bgC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:bgC];
			fC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:fC];
		} else if ([[light_action getValueForKey:@"Type"] isEqualToString:@"Blinking_light"]) {
			//NSLog(@"Blinking light light_action in ownFontsDrawRect");
			if (blinking_state == 0) {
				bgC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor blackColor]];
				////oldBgCol = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor whiteColor]];
				fC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor whiteColor]];
				blinking_state = 1;
			} else {
				bgC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor whiteColor]];
				////oldBgCol = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor blackColor]];
				fC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor blackColor]];
				blinking_state = 0;
			}
		}// else {
			//NSLog(@"Unknown light_action in ownFontsDrawRect (type=%@, first child=%@)",[light_action getValueForKey:@"Type"],[[light_action.children objectAtIndex:0] getNodeName]);
		//}
		dimmingLevel = 0;
	}

	/* Make the screen black if dimingLevel == 10. */
	if (dimmingLevel == 10) {
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; //black
		[self superview].backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; //black
		return;
	} else { // if (dimmingLevel == 1) {
		/* Use darker colors if dimmed.
		   It's not possible to mask the own font images with white color, and therefore if
		   the foreground is white, then we'll mask it with something _almost_ white instead.
		   Same thing goes for gray. */
		CGFloat *arr;
		
		/* Dim the background color. */
		/*if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor whiteColor] CGColor])) {
			//turn white into gray
			bgC = [UIColor colorWithRed:0.99*(10-dimmingLevel)/10 green:0.99*(10-dimmingLevel)/10 blue:0.99*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor grayColor] CGColor])) {
			bgC = [UIColor colorWithRed:0.4*(10-dimmingLevel)/10 green:0.4*(10-dimmingLevel)/10 blue:0.4*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor blackColor] CGColor])) {
			//do nothing if color is already black
		} else {*/
			arr = (CGFloat *) CGColorGetComponents([bgC CGColor]);
			bgC = [UIColor colorWithRed:arr[0]*(10-dimmingLevel)/10 green:arr[1]*(10-dimmingLevel)/10 blue:arr[2]*(10-dimmingLevel)/10 alpha:1.0];
		//}
		
		/* Dim the foreground color. */
		/*if (CFEqual([((UIColor *)fC) CGColor],[[UIColor whiteColor] CGColor])) {
			//turn white into gray
			fC = [UIColor colorWithRed:0.99*(10-dimmingLevel)/10 green:0.99*(10-dimmingLevel)/10 blue:0.99*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)fC) CGColor],[[UIColor grayColor] CGColor])) {
			fC = [UIColor colorWithRed:0.4*(10-dimmingLevel)/10 green:0.4*(10-dimmingLevel)/10 blue:0.4*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)fC) CGColor],[[UIColor blackColor] CGColor])) {
			//do nothing if color is already black
		} else {*/
			arr = (CGFloat *) CGColorGetComponents([fC CGColor]);
			fC = [UIColor colorWithRed:arr[0]*(10-dimmingLevel)/10 green:arr[1]*(10-dimmingLevel)/10 blue:arr[2]*(10-dimmingLevel)/10 alpha:1.0];
		//}
	}

	/* I couldn't get the outer surrounding view to update its color at the same time as the
	   inner one (always "one step behind"). Therefore I made a hack here that delays the
	   update for the surrounding view one "step". */
	self.backgroundColor = bgC;
	if (oldBgCol != nil) {
		[self superview].backgroundColor = oldBgCol;
		[oldBgCol release];
	}
	oldBgCol = [[UIColor alloc] initWithCGColor:[bgC CGColor]];

	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateStr = [inputFormatter stringFromDate:curr_time];

	/* Check the different time styles. */
	int american_time_style = NO;
	BOOL atAM = NO;
	if ([dateStr hasSuffix:@" AM"]) {
		american_time_style = YES;
		atAM = YES;
		dateStr = [dateStr stringByReplacingOccurrencesOfString:@" AM" withString:@""];
	} if ([dateStr hasSuffix:@" PM"]) {
		american_time_style = YES;
		dateStr = [dateStr stringByReplacingOccurrencesOfString:@" PM" withString:@""];
	}
	BOOL onlyThreeNumbers = NO;
	if ([dateStr characterAtIndex:1]-'0' < 0 || [dateStr characterAtIndex:1]-'0' > 9) {
		onlyThreeNumbers = YES;
	}
	
	[inputFormatter setDateFormat:@"EEE MMM d"];
	NSString *weekDay = [inputFormatter stringFromDate:curr_time];
	[inputFormatter release];
	float numberWidth;
	float dayHalfWidth;
	float dayHalfHeight;
	if (!onlyThreeNumbers) {
		/* Use four numbers for the time. */
		numberWidth = 2*self.bounds.size.width/9; //3*self.bounds.size.width/13;
	} else {
		/* Use three numbers for the time. */
		//numberWidth = 2*self.bounds.size.width/7; //3*self.bounds.size.width/10;
		numberWidth = 2*self.bounds.size.width/9; //3*self.bounds.size.width/13;
	}
	float numberHeight = number_graphics[f][0].size.height*numberWidth/number_graphics[f][0].size.width;
	float dotWidth = numberWidth/2;
	float dotHeight = colon_graphics[f].size.height*dotWidth/colon_graphics[f].size.width;
	float y_offset = self.bounds.size.height/2-numberHeight/2;
	float x_offset = self.bounds.size.width/5;

	//CGContextRef context = UIGraphicsGetCurrentContext();
	[fC set];
	if (settings != nil) {
		if (settings.alarm_turned_on) { //ccc
			//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			UIImage *bgImage = [Misc bgImageWithColor:fC];
			//NSLog (@"1: retain count is:%d",[bgImage retainCount]);
			BOOL vertical = NO;
			if (self.bounds.size.width < self.bounds.size.height)
				vertical = YES;
			/* The bell should be blinking whenever the alarm is turned on. */
			if (light_action == nil || blinking_state == 0) {
				if (vertical)
					[[self maskImage:bgImage withMask:alarm_on_icon] drawInRect:CGRectMake(x_offset/6,3*y_offset/4,x_offset/2,x_offset/2)];
				else
					[[self maskImage:bgImage withMask:alarm_on_icon] drawInRect:CGRectMake(x_offset/6,y_offset/4,x_offset/2,x_offset/2)];
			}
			//[bgImage release];
			//NSLog (@"2: retain count is:%d",[bgImage retainCount]);
			//[pool drain];
			//NSLog (@"3: retain count is:%d",[bgImage retainCount]);
		}
	}
	if (american_time_style) {
		//NSData *dat = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"]];
		//NSXMLParser *pars = [[NSXMLParser alloc] initWithData:dat];
		//[pars initWithData:dat];
		/*SoundThemeReader *parser = [[SoundThemeReader alloc] init];
		NSString *result = [parser parse];
		//NSString *result = @"asd";
		if (result == nil) {
			dayHalfWidth = [@"NN" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].width;
			dayHalfHeight = [@"NN" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].height;
			[@"NN" drawInRect:CGRectMake(self.bounds.size.width-dayHalfWidth*1.5,y_offset-numberHeight/5,dayHalfWidth,dayHalfHeight) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
		} else {
			dayHalfWidth = [result sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].width;
			dayHalfHeight = [result sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].height;
			[result drawInRect:CGRectMake(self.bounds.size.width-dayHalfWidth*1.5,y_offset-numberHeight/5,dayHalfWidth,dayHalfHeight) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
		}*/
		if (atAM) {
			dayHalfWidth = [@"AM" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].width;
			dayHalfHeight = [@"AM" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].height;
			[@"AM" drawInRect:CGRectMake(self.bounds.size.width-dayHalfWidth*1.5,y_offset-numberHeight/5,dayHalfWidth,dayHalfHeight) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
		} else {
			dayHalfWidth = [@"PM" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].width;
			dayHalfHeight = [@"PM" sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].height;
			[@"PM" drawInRect:CGRectMake(self.bounds.size.width-dayHalfWidth*1.5,y_offset-numberHeight/5,dayHalfWidth,dayHalfHeight) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
		}
	}
	
	if (!onlyThreeNumbers) { //four numbers
		UIImage *bgImage = [Misc bgImageWithColor:fC];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:0]-'0']] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:1]-'0']] drawInRect:CGRectMake(1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:colon_graphics[f]] drawInRect:CGRectMake(2*numberWidth, y_offset + 0*dotHeight, dotWidth, dotHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(2*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:3]-'0']] drawInRect:CGRectMake(2*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(2*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:4]-'0']] drawInRect:CGRectMake(2*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		//[bgImage release];
	} else {
		UIImage *bgImage = [Misc bgImageWithColor:fC];
		/*[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:0]-'0']] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:colon_graphics[f]] drawInRect:CGRectMake(1*numberWidth, y_offset + 0*dotHeight, dotWidth, dotHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(1*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:2]-'0']] drawInRect:CGRectMake(1*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(1*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:3]-'0']] drawInRect:CGRectMake(1*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		 */
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		//[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:0]-'0']] drawInRect:CGRectMake(0*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:0]-'0']] drawInRect:CGRectMake(1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:colon_graphics[f]] drawInRect:CGRectMake(2*numberWidth, y_offset + 0*dotHeight, dotWidth, dotHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(2*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:2]-'0']] drawInRect:CGRectMake(2*numberWidth + dotWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];
		[[self maskImage:bgImage withMask:background8[f]] drawInRect:CGRectMake(2*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight) blendMode:kCGBlendModeNormal alpha:ALPHA_BACKGROUND8];
		[[self maskImage:bgImage withMask:number_graphics[f][[dateStr characterAtIndex:3]-'0']] drawInRect:CGRectMake(2*numberWidth + dotWidth + 1*numberWidth, y_offset + 0*numberHeight, numberWidth, numberHeight)];

		//[bgImage release];
	}

	
	/*[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *targetTime = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:@"1970-03-03 21:39:00"]];
	NSDate *alarm_time = [self setAlarmTime:targetTime];
	weekDay = [inputFormatter stringFromDate:alarm_time];*/

	/*NSDate *alarm_time = nil;
	if (!statisk && settings != nil) {
		alarm_time = settings.alarm_time;
	}*/
	//alarm_time = [[NSDate alloc] init]; //TODO: this is probably a memory leak
	//int latte = [alarm_time timeIntervalSinceNow];
	//latte = [self get_random_number:3];	
	//weekDay = [[NSString alloc] initWithFormat:@"act: %d sec, %@",latte,latteStr];

	//Node *sound_theme = settings.advancedSettingsViewCtrl.sound_theme;
	//weekDay = [sound_theme getSoundThemeName];
	//weekDay = [sound_theme getVersion];
	//weekDay = [sound_theme getREMLength];
	//weekDay = [sound_theme getNodeName];
	//weekDay = [[NSString alloc] initWithFormat:@"remL: %d",[sound_theme getREMLength]];

	//weekDay = [[NSString alloc] initWithFormat:@"phase: %d",phase];

	//weekDay = [[NSString alloc] initWithFormat:@"phase: %d",[self get_random_number:100]];

	//weekDay = latteStr;
	
	if (settings != nil && settings.advancedSettingsViewCtrl != nil && settings.advancedSettingsViewCtrl.show_date) {
		dayHalfWidth = [weekDay sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].width;
		dayHalfHeight = [weekDay sizeWithFont:[UIFont italicSystemFontOfSize:numberWidth/5]].height;
		if ([dateStr characterAtIndex:0]-'0' == 1)
			[weekDay drawInRect:CGRectMake(numberWidth/2,y_offset+numberHeight,dayHalfWidth+10,dayHalfHeight+10) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
		else
			[weekDay drawInRect:CGRectMake(numberWidth/10,y_offset+numberHeight,dayHalfWidth+10,dayHalfHeight+10) withFont:[UIFont italicSystemFontOfSize:numberWidth/5]];
	}
    //[pool release];
	//[pool drain];
}

- (void)systemFontsDrawRect:(CGRect)rect withFont:(int)f andFontColor:(UIColor *)fC andBgColor:(UIColor *)bgC
			 andDimingLevel:(int)dimmingLevel andLightAction:(Node *)light_action {
    // Drawing code

	/* If light_action is set, then determine the proper colors to use, and make sure there is no dimming. */
	////UIColor *oldBgCol = nil;
	if (light_action != nil) {
		if ([[light_action getValueForKey:@"Type"] isEqualToString:@"Steady_light"]) {
			bgC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:bgC];
			fC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:fC];
		} else if ([[light_action getValueForKey:@"Type"] isEqualToString:@"Blinking_light"]) {
			if (blinking_state == 0) {
				bgC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor blackColor]];
				////oldBgCol = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor whiteColor]];
				fC = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor whiteColor]];
				blinking_state = 1;
			} else {
				bgC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor whiteColor]];
				////oldBgCol = [self parseColor:[light_action getValueForKey:@"BgColor"] withFallbackColor:[UIColor blackColor]];
				fC = [self parseColor:[light_action getValueForKey:@"FgColor"] withFallbackColor:[UIColor blackColor]];
				blinking_state = 0;
			}
		}
		dimmingLevel = 0;
	}
	
	/* Make the screen black if dimingLevel == 10. */
	if (dimmingLevel == 10) {
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; //black
		[self superview].backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; //black
		return;
	} else { // if (dimmingLevel > 0) {
		/* Use darker colors if dimmed.
		   It's not possible to mask the own font images with white color, and therefore if
		   the foreground is white, then we'll mask it with something _almost_ white instead.
		   Same thing goes for gray. */
		CGFloat *arr;

		/* Dim the background color. */
		/*if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor whiteColor] CGColor])) {
			//turn white into gray
			bgC = [UIColor colorWithRed:0.99*(10-dimmingLevel)/10 green:0.99*(10-dimmingLevel)/10 blue:0.99*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor grayColor] CGColor])) {
			bgC = [UIColor colorWithRed:0.4*(10-dimmingLevel)/10 green:0.4*(10-dimmingLevel)/10 blue:0.4*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)bgC) CGColor],[[UIColor blackColor] CGColor])) {
			//do nothing if color is already black
		} else {*/
			arr = (CGFloat *) CGColorGetComponents([bgC CGColor]);
			bgC = [UIColor colorWithRed:arr[0]*(10-dimmingLevel)/10 green:arr[1]*(10-dimmingLevel)/10 blue:arr[2]*(10-dimmingLevel)/10 alpha:1.0];
		//}
		
		/* Dim the foreground color. */
		/*if (CFEqual([((UIColor *)fC) CGColor],[[UIColor whiteColor] CGColor])) {
			//turn white into gray
			fC = [UIColor colorWithRed:0.99*(10-dimmingLevel)/10 green:0.99*(10-dimmingLevel)/10 blue:0.99*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)fC) CGColor],[[UIColor grayColor] CGColor])) {
			fC = [UIColor colorWithRed:0.4*(10-dimmingLevel)/10 green:0.4*(10-dimmingLevel)/10 blue:0.4*(10-dimmingLevel)/10 alpha:1.0];
		} else if (CFEqual([((UIColor *)fC) CGColor],[[UIColor blackColor] CGColor])) {
			//do nothing if color is already black
		} else {*/
			arr = (CGFloat *) CGColorGetComponents([fC CGColor]);
			fC = [UIColor colorWithRed:arr[0]*(10-dimmingLevel)/10 green:arr[1]*(10-dimmingLevel)/10 blue:arr[2]*(10-dimmingLevel)/10 alpha:1.0];
		//}
	}
	
	/* I couldn't get the outer surrounding view to update its color at the same time as the
	   inner one (always "one step behind"). Therefore I made a hack here that delays the
	   update for the surrounding view one "step". */
	self.backgroundColor = bgC;
	if (oldBgCol != nil) {
		[self superview].backgroundColor = oldBgCol;
		[oldBgCol release];
	}
	oldBgCol = [[UIColor alloc] initWithCGColor:[bgC CGColor]];

	//[self superview].contentMode = UIViewContentModeRedraw;
	//[[self superview] drawRect:CGRectMake(0,0,200,200)];
	//[[self superview] setNeedsLayout];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateStr = [inputFormatter stringFromDate:curr_time];
	
	/* Handle the different time styles. */
	int american_time_style = NO;
	BOOL atAM = NO;
	if ([dateStr hasSuffix:@" AM"]) {
		american_time_style = YES;
		atAM = YES;
		dateStr = [dateStr stringByReplacingOccurrencesOfString:@" AM" withString:@""];
	} if ([dateStr hasSuffix:@" PM"]) {
		american_time_style = YES;
		dateStr = [dateStr stringByReplacingOccurrencesOfString:@" PM" withString:@""];
	}
	
	[inputFormatter setDateFormat:@"EEE MMM d"];
	NSString *weekDay = [inputFormatter stringFromDate:curr_time];
	[inputFormatter release];

	/* Get the right font. */
	NSString *fontName;
	int fontSize = 0;
	BOOL vertical = NO;
	if (self.bounds.size.width < self.bounds.size.height)
		vertical = YES;
	if (f == 2) {
		fontName = @"MarkerFelt-Thin"; //intressant
		if (vertical)
			fontSize = 144;
		else
			fontSize = 216;
	} else if (f == 3) {
		fontName = @"Verdana-Italic";
		if (vertical)
			fontSize = 118;
		else
			fontSize = 177;
	} else if (f == 4) {
		fontName = @"ArialRoundedMTBold"; //intressant
		if (vertical)
			fontSize = 133;
		else
			fontSize = 200;
	} else if (f == 5) {
		fontName = @"Zapfino"; //intressant?
		if (vertical)
			fontSize = 83;
		else
			fontSize = 125;
	}
	else if (f == 6) {
		fontName = @"Trebuchet-BoldItalic"; //intressant
		if (vertical)
			fontSize = 131;
		else
			fontSize = 197;
	} else {
		//use a system default font
		fontName = [UIFont italicSystemFontOfSize:15].fontName;
		f = 7;
		if (vertical)
			fontSize = 143;
		else
			fontSize = 215;
	}
	
	/* If the font wasn't found, then use a system default font. */
	if ([UIFont fontWithName:fontName size:15] == nil) {
		fontName = [UIFont italicSystemFontOfSize:15].fontName;
		f = 7;
		if (vertical)
			fontSize = 143;
		else
			fontSize = 215;
	}
		
	/* Stupid way to find out the right font, but I don't know of any other way to do it. */
	/*fontSize = 500;
	//NSLog(@"dateStr = %@",dateStr);
	while ([dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width > self.bounds.size.width) {
		//NSLog(@"fontSize = %d",fontSize);
		fontSize--;
	}
	NSLog(@"fontSize = %d",fontSize);*/
	if (f == 2 || f == 4 || f == 6 || f == 7)
		fontSize -= 15*fontSize/30; //42;
	else
		fontSize -= 13*fontSize/30; //30;
	
	/* If american timestyle (AM/PM string at the end), then we need to reserve more space
	   if two numbers are needed for the hours. */
	NSRange range = NSMakeRange(0,2);
	//NSLog(@"dateStr = %@",dateStr);
	if (american_time_style
		&& ([dateStr compare:@"10" options:NSLiteralSearch range:range] == NSOrderedSame
			|| [dateStr compare:@"11" options:NSLiteralSearch range:range] == NSOrderedSame
			|| [dateStr compare:@"12" options:NSLiteralSearch range:range] == NSOrderedSame)) {
		//NSLog(@"Fore = %d",fontSize);
		fontSize = (int) fontSize * 0.9;
		if (f == 5) //Zapfino requires an even smaller font in order to be displayed correctly in all cases
			fontSize = (int) fontSize * 0.9;
		//NSLog(@"Efter = %d",fontSize);
	}
	
	float numberHeight = [dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].height;
	float y_offset = self.bounds.size.height/2-numberHeight/2;
	float x_offset = self.bounds.size.width/5;
	if (f == 5)
		y_offset += numberHeight/8;

	//CGContextRef context = UIGraphicsGetCurrentContext();
	[fC set];
	if (settings != nil) {
		if (settings.alarm_turned_on) {
			UIImage *bgImage = [Misc bgImageWithColor:fC];
			/* The bell should be blinking whenever the alarm is turned on. */
			if (light_action == nil || blinking_state == 0) {
				if (vertical)
					[[self maskImage:bgImage withMask:alarm_on_icon] drawInRect:CGRectMake(x_offset/6,3*y_offset/4,x_offset/2,x_offset/2)];
				else
					[[self maskImage:bgImage withMask:alarm_on_icon] drawInRect:CGRectMake(x_offset/6,y_offset/4,x_offset/2,x_offset/2)];
			}
			//[bgImage release];
		}
	}
	if (american_time_style) {
		if (atAM) {
			NSString *amStr = @"AM";
			int dayHalfWidth = [amStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize/5]].width;
			int dayHalfHeight = [amStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize/5]].height;
			if (f == 2 || f == 3 || f == 7)
				[amStr drawInRect:CGRectMake([dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width+x_offset+x_offset/6, y_offset,self.bounds.size.width-0.2*dayHalfWidth,dayHalfHeight) withFont:[UIFont fontWithName:fontName size:fontSize/5]];
			else
				[amStr drawInRect:CGRectMake([dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width+x_offset+x_offset/6, y_offset,self.bounds.size.width-0.2*dayHalfWidth,dayHalfHeight) withFont:[UIFont fontWithName:fontName size:fontSize/5]];
		} else {
			NSString *pmStr = @"PM";
			int dayHalfWidth = [pmStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize/5]].width;
			int dayHalfHeight = [pmStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize/5]].height;
			if (f == 2 || f == 3 || f == 7)
				[pmStr drawInRect:CGRectMake([dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width+x_offset+x_offset/6, y_offset,self.bounds.size.width-0.2*dayHalfWidth,dayHalfHeight) withFont:[UIFont fontWithName:fontName size:fontSize/5]];
			else
				[pmStr drawInRect:CGRectMake([dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width+x_offset+x_offset/6, y_offset,self.bounds.size.width-0.2*dayHalfWidth,dayHalfHeight) withFont:[UIFont fontWithName:fontName size:fontSize/5]];
		}
	}
	[dateStr drawInRect:CGRectMake(x_offset, y_offset,[dateStr sizeWithFont:[UIFont fontWithName:fontName size:fontSize]].width,numberHeight) withFont:[UIFont fontWithName:fontName size:fontSize]];
	if (settings != nil && settings.advancedSettingsViewCtrl != nil && settings.advancedSettingsViewCtrl.show_date) {
		if (f == 2 || f == 7) {
			if ([dateStr characterAtIndex:0]-'0' == 1)
				[weekDay drawInRect:CGRectMake(x_offset+x_offset/5,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
			else
				[weekDay drawInRect:CGRectMake(x_offset,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
		} else if (f == 5)
			[weekDay drawInRect:CGRectMake(x_offset,y_offset+numberHeight/1.5,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
		else {
			if (f == 4) {
				if ([dateStr characterAtIndex:0]-'0' == 1)
					[weekDay drawInRect:CGRectMake(x_offset+x_offset/8,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
				else
					[weekDay drawInRect:CGRectMake(x_offset+x_offset/16,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
			} else if (f == 6) {
				if ([dateStr characterAtIndex:0]-'0' == 1)
					[weekDay drawInRect:CGRectMake(x_offset+x_offset/8,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
				else
					[weekDay drawInRect:CGRectMake(x_offset,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
			} else if (f == 3) {
				if ([dateStr characterAtIndex:0]-'0' == 1)
					[weekDay drawInRect:CGRectMake(x_offset,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
				else
					[weekDay drawInRect:CGRectMake(x_offset-x_offset/16,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
			} else {
				[weekDay drawInRect:CGRectMake(x_offset,y_offset+numberHeight,self.bounds.size.width,[weekDay sizeWithFont:[UIFont fontWithName:fontName size:fontSize/4]].height) withFont:[UIFont fontWithName:fontName size:fontSize/4]];
			}
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
	NSSet *aSet = [event touchesForView:self];
	//NSSet *aSet = [event allTouches];
	if ([aSet count] > 0) {
		//NSDate *temp_date = [[NSDate alloc] dateWithCalendarFormat:@"1970-01-01 00:00:00 +0300" timeZone:nil];
		//NSDate *temp_date = [NSDate dateWithString:@"1970-01-01 00:00:00 +0300"];
		//NSDate *temp_date = [[NSDate alloc] distantPast];
		if (phase != PHASE_IDLE) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good morning!" message:@"Do you want to turn off the alarm?"
														   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
			[alert show];
			[alert release];
		} else {
			NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
			[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			//NSDate *temp_date = [inputFormatter dateFromString:@"1970-01-01 00:00:00"];
			NSDate *temp_date = [[[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:@"1970-01-01 00:00:00"]] autorelease];
			if ([temp_date isEqualToDate:last_activity_time]) {
				[last_activity_time release];
				last_activity_time = [[NSDate alloc] init];
				if (!statisk && timeUpdater.timeInterval > 2.0) {
					NSLog(@"Updating the screen every second.");
					[self stopUpdateTimer];
					[self startUpdateTimer:1.0];
				}
			} else {
				//turn on dimming by setting last_activity_time to a proper value
				[last_activity_time release];
				last_activity_time = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:@"1970-01-01 00:00:00"]];
				if (dimmed_at != nil) {
					[dimmed_at release];
					dimmed_at = nil;
				}
				dimmed_at = [[NSDate alloc] init];
			}
			[inputFormatter release];
		}
	}
	/* I couldn't get it to work that the outer view's color is updated in sync with
	   the inner view's colors. Therefore the following hack is done: First call setNeedsDisplay,
	   which will in turn call the drawRect function. Then set a timer that will call updateTime
	   50 milliseconds later. */
	[self setNeedsDisplay];
	NSTimer *tempTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
														  target:self selector:@selector(updateTime:)
														userInfo:nil repeats:NO];
}

/* This function is called when the user presses the Snooze or Wakeup button. */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	/*if (dimmed_at != nil) {
		[dimmed_at release];
		dimmed_at = nil;
	}*/
	[last_activity_time release];
	last_activity_time = [[NSDate alloc] init];
	if (buttonIndex == 0) {
		/* Change to snooze phase + make sure that we will immediately move to the
		   snooze phase by removing all phases in the subphases stack. */
		phase = PHASE_SNOOZE;
		phase_init_done = NO;
		[subphases removeAllObjects];
		snoozeTimer = [[NSDate alloc] init]; //TODO: this is probably a memory leak
		snooze_counter++;
		if (player.playing) {
			//[self.player stop];
			[self stopSound];
		}
	} else {
		//Turn off the alarm and set the alarm time to 24 hours into the future.
		if (!statisk && settings != nil) {
			settings.alarm_turned_on = NO;
			settings.alarm_time = [Misc setTimeInFuture:settings.alarm_time];
			//[settings.alarm_time addTimeInterval:60*60*24]; //24 hours later
		}
		phase = PHASE_IDLE;
		[subphases removeAllObjects];
		if (player.playing) {
			//[self.player stop];
			[self stopSound];
		}
		/* Update the "Time until wakeup" string in the Set wakeup time view. */
		[settings.timeViewCtrl.myTableView reloadData];
		phase_init_done = NO;
	}
}

- (void) setSubPhaseTimeForNode:(Node *)node {
	/* Determine sub phase length. For Sound and Phase actions the length means
	   min(length of sound file,length value). Or in other words the sound will
	   be cut off if the length value is shorter than the length of the sound file. */
	//if (subPhaseTime != nil)
	//	[subPhaseTime release];
	int sub_phase_length;
	if ([node getValueForKey:@"Length"] == nil) {
		//NSLog(@"Length == nil");
		/* If the Length tag doesn't exist we should take different actions depending on if it's
		   a Sound- or a Pause tag. For Sound tags the default is to play to the end of the sound,
		   and for pauses a default of 5 seconds will be used. */
		if ([[node getValueForKey:@"Type"] isEqualToString:@"Sound"]
			|| [[node getNodeName] isEqualToString:@"Phase"]) {
			//NSLog(@"En timme");
			sub_phase_length = 3600; //an hour should be enough time to play until the end of the sound...
		} else {
			//NSLog(@"Fem sekunder");
			sub_phase_length = 5;
		}
	} else {
		//NSLog(@"Length NOT nil");
		sub_phase_length = [Misc parseIntegerSpan:[node getValueForKey:@"Length"]];
		//NSLog(@"Setting Length = %d",sub_phase_length);
	}
	/* Since this function is called only once per second it will take another second for it to
	   discover that the sound should end. Therefore we decrease the value by one second to make sure
	   that a sound length of 2 actually means 2 seconds and not 3. */
	sub_phase_length--;
	if (node != nil && node.subPhaseTime != nil)
		[node.subPhaseTime release];
	if (sub_phase_length >= 0)
		node.subPhaseTime = [[NSDate alloc] initWithTimeIntervalSinceNow:sub_phase_length];
	else
		node.subPhaseTime = nil;
}

/* This function goes through the current sound theme and updates the curr_sound_action
   and curr_light_action. It also takes care of playing sounds, but nothing is drawn
   to the screen. */
- (void)checkSoundTheme {
	//NSLog(@"checkSoundTheme");
	NSDate *alarm_time = nil;
	BOOL alarm_turned_on = NO;
	BOOL rem_in_use = NO;
	Node *sound_theme;
	NSInteger snooze_interval = 5;
	BOOL shock_alarm_in_use = NO;
	BOOL snoring_sounds_turned_on = NO;
	int wakeup_start_volume = 50;
	int rem_length = 10*60; //10 minutes
	if (!statisk && settings != nil) {
		alarm_time = settings.alarm_time;
		rem_in_use = settings.rem_turned_on;
		alarm_turned_on = settings.alarm_turned_on;
		shock_alarm_in_use = settings.shock_alarm_turned_on;
		snoring_sounds_turned_on = settings.snooze_interrupt_turned_on;
		if (settings.advancedSettingsViewCtrl != nil) {
			sound_theme = settings.advancedSettingsViewCtrl.sound_theme;
			snooze_interval = settings.advancedSettingsViewCtrl.snooze_interval;
			//wakeup_start_volume goes from 0-100 whereas the slider goes from 0-10, so multiply by 10:
			wakeup_start_volume = settings.advancedSettingsViewCtrl.wakeup_master_volume*10;
			//The value of the slider in the user interface is in minutes and here
			//we work with seconds, so therefore we need to multiply by 60 here:
			rem_length = settings.advancedSettingsViewCtrl.rem_length*60;
		}
	}
	
	/* Update the "Time until wakeup" string in the Set wakeup time view.
	   TODO: This really only needs to be done once per minute, and it's not actually
	   necessary to do at all if the Set wakeup time view is the current view on the
	   "settings-flip side" (because the "Time until wakeup" string is automatically
	   updated anyway whenever we go from the Settings view to the Set wakeup time
	   view). */
	if (alarm_turned_on)
		[settings.timeViewCtrl.myTableView reloadData];
	
	/* Make the screen start blinking if we are close to waking up. */
	int last_master_phase = phase;
	if (alarm_turned_on && sound_theme != nil) {

		//qqq
		/* Disable screen saver one minute before the REM phase starts (if enabled). Note that
		   this won't actually unlock the screen saver (if that's somehow possibly, then that
		   should be done here, but as far as I know that's not possible), but rather it'll
		   just make sure that if the user unlocks the screen saver when the REM phase starts,
		   then the screen shouldn't get locked again. */
		if (!statisk && [alarm_time timeIntervalSinceNow] < (rem_length+1*60)
			/*&& settings.advancedSettingsViewCtrl.lock_screen == YES*/
			/*&& [UIApplication sharedApplication].idleTimerDisabled == NO*/
			&& screen_locked == YES) {
			NSLog(@"Disabling screen saver one minute before REM phase starts.");
			[self disableScreenSaver];
		}

		/* In order to save battery the screen will just be updated once every tenth second during
		   the dimming phase. However this should be increased to once every second when the rem
		   phase starts. => I think that in reality this hardly has any effect on battery life,
		   the big battery drain seems to be the screen. */
		if (!statisk && [alarm_time timeIntervalSinceNow] < (rem_length+1*60)
			&& timeUpdater.timeInterval > 2.0) {
			NSLog(@"Updating the screen every second.");
			[self stopUpdateTimer];
			[self startUpdateTimer:1.0];
		}

		/* Check if it's time to switch from one phase to another. */
		if ([alarm_time timeIntervalSinceNow] < rem_length) {
			if ([alarm_time timeIntervalSinceNow] > 0) {
				if (rem_in_use){
					phase = PHASE_REM;
				} else {
					phase = PHASE_IDLE;
				}
			} else if (phase == PHASE_REM || (!rem_in_use && phase == PHASE_IDLE)){
				phase = PHASE_WAKEUP;
				snooze_counter = 0;
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good morning!" message:@"Time to wake up... :-)"
															   delegate:self cancelButtonTitle:@"Snooze" otherButtonTitles:@"Wakeup", nil];
				[alert show];
				[alert release];
			} else if(phase == PHASE_SNOOZE){
				if([snoozeTimer timeIntervalSinceNow] < -snooze_interval*60) {
					/*if (!shock_alarm_in_use)
						NSLog(@"No shock alarm");
					else
						NSLog(@"Shock alarm");
					NSLog(@"snooze_counter = %d, max snooze count = %d",snooze_counter,MAX_SNOOZE_COUNT_BEFORE_SHOCK);*/
					if(shock_alarm_in_use && snooze_counter > MAX_SNOOZE_COUNT_BEFORE_SHOCK){
						phase = PHASE_SHOCK;
						//snooze_counter = 0;
					} else {
						phase = PHASE_WAKEUP;
						//snooze_counter++;
					}
					if (player.playing) {
						//[self.player stop];
						[self stopSound];
					}
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Good morning!" message:@"Time to wake up... :-)"
																   delegate:self cancelButtonTitle:@"Snooze" otherButtonTitles:@"Wakeup", nil];
					[alert show];
					[alert release];
				}
			}
		} else {
			phase = PHASE_IDLE;
		}
		
		/* Set the current volume if we got to the REM phase, or if the REM phase should have
		   started if REM was turned on. */
		/*if (last_master_phase == PHASE_IDLE && [alarm_time timeIntervalSinceNow] < rem_length
			&& [alarm_time timeIntervalSinceNow] > 0) {
			wakeup_curr_volume = 50; //wakeup_curr_volume will be used whenever no volume is given in the xml file
		}*/
		
		/* This section will be gone through only if some action are needed */
		//NSLog(@"latte");
		if(phase != PHASE_IDLE){
			
			/* Check if any parent phase has ran for enough time. */
			BOOL parent_should_stop = NO;
			for (int i = 0; i < [subphases count]; i++) {
				Node *parent = [subphases objectAtIndex:i];
				if (parent.subPhaseTime != nil && [parent.subPhaseTime timeIntervalSinceNow] < 0) {
					//NSLog(@"Parent should stop (i = %d)",i);
					parent_should_stop = YES;
					//break;
					[subphases removeObjectsInRange:NSMakeRange(i,[subphases count]-i)];
					curr_subphase = [subphases lastObject];
				}
			}

			if(parent_should_stop //any of the parents have ran for at least as much time as specified
			   || phase != last_master_phase  // master phase has been changed
			   //om inte length finns sa kommer subPhaseTime att initieras till 'now', dvs. da vi kommer hit kommer det att vara "forr i tiden" ([subPhaseTime timeIntervalSinceNow] < 0)
			   //om length finns sa kommer subPhaseTime att initieras till "framtiden", dvs. da vi kommer hit kommer det att vara ungefar 'now'
			   || ([curr_action.subPhaseTime timeIntervalSinceNow] < 0 && player != nil && player.playing) // is playing and sound length has been reached
			   || ((player == nil || player.playing == NO) && [[curr_action getValueForKey:@"Type"] isEqualToString:@"Pause"] == NO) // sound has ended and is not pause
			   || ([curr_action.subPhaseTime timeIntervalSinceNow] < 0 && [[curr_action getValueForKey:@"Type"] isEqualToString:@"Pause"])) { // is pause and pause length has been reached
				//NSLog(@"latte2");
				
				/* If sound is playing and sound length has been reached, then we should stop
				   any playing sound. If we are in a Phase action then get out of the phase if
				   the time is up. Also quit any playing sounds if we switch phases. */
				if ((curr_action.subPhaseTime != nil && [curr_action.subPhaseTime timeIntervalSinceNow] < 0)
					|| parent_should_stop || phase != last_master_phase) {
					//NSLog(@"latte3");
					if (player != nil && player.playing)
						[self stopSound];
					//[subphases removeLastObject];
					//curr_subphase = [subphases lastObject];
				}
				
				/* If the phase changed, then empty the phase stack in order to make sure that
				   we immediately move to the new phase. For example if REM is turned on, then
				   don't wait for it to get out of deeply nested phases/actions if the REM phase
				   before the alarm is turned on. Also make sure that initialization can be done
				   for the new phase. */
				if(phase != last_master_phase) {
					//NSLog(@"latte4");
					[subphases removeAllObjects];
					phase_init_done = NO;
				}
				
				curr_subphase = [subphases lastObject];
				if (curr_subphase == nil) {
					if (phase == PHASE_REM) {
						curr_subphase = [sound_theme getObjectForKey:@"REM"];
					} else if (phase == PHASE_WAKEUP) {
						curr_subphase = [sound_theme getObjectForKey:@"Wake_up"];
					} else if (phase == PHASE_SNOOZE) {
						curr_subphase = [sound_theme getObjectForKey:@"Snooze_interrupt"];
					} else if (phase == PHASE_SHOCK) {
						curr_subphase = [sound_theme getObjectForKey:@"Shock_alarm"];
					}
					if (curr_subphase != nil) {
						[curr_subphase zeroCounters];
						[subphases addObject:curr_subphase];
					}
				}
				
				if (curr_subphase != nil) {
					//NSLog(@"latte5");
					/*if (curr_action != nil && curr_action.subPhaseTime != nil) {
						[curr_action.subPhaseTime release];
						curr_action.subPhaseTime = nil;
					}*/
					curr_action = nil;
					while (curr_action == nil) {
						Node *child = [curr_subphase getNextChild];
						if (child == nil) {
							//back out from this node
							/*if (curr_subphase.subPhaseTime != nil) {
								[curr_subphase.subPhaseTime release];
								curr_subphase.subPhaseTime = nil;
							}*/
							[subphases removeLastObject];
							curr_subphase = [subphases lastObject];
							if (curr_subphase == nil){  //will be nil if we back out from the "root" phase (e.g. REM node)
								//NSLog(@"Backing out from root node");
								//NSLog(@"latte6");
								break;
							}
						} else {
							if ([[child getNodeName] isEqualToString:@"Action"]) {
								//NSLog(@"Hit action node");
								//NSLog(@"Action node of type %@",[child getValueForKey:@"Type"]);
								//this node is an action node, initialization nodes should just be done once, otherwise no restrictions
								if ([[child getValueForKey:@"Type"] isEqualToString:@"Initialization"] == NO || phase_init_done == NO) {
									//if ([[child getValueForKey:@"Type"] isEqualToString:@"Initialization"])
									//	NSLog(@"Doing initialization node.");
									curr_action = child;
								}// else
									//NSLog(@"Skipping initialization node.");
								//NSLog(@"john: type=%@, freq=%@, snd=%@, length=%@",[curr_action getValueForKey:@"Type"],[curr_action getValueForKey:@"Frequency"],[curr_action getValueForKey:@"SoundResource"],[curr_action getValueForKey:@"Length"]);
							} else if ([[child getNodeName] isEqualToString:@"Phase"]) {
								//NSLog(@"Hit phase node");
								curr_subphase = child;
								//NSLog(@"Setting duration for Phase.");
								[self setSubPhaseTimeForNode:curr_subphase];
								[child zeroCounters];
								[subphases addObject:curr_subphase];
								//NSLog(@"john: rounds=%@, ord=%@",[curr_subphase getValueForKey:@"Rounds"],[curr_subphase getValueForKey:@"Order"]);
							}
						}
					}
				}

				//NSLog(@"latte7");
				if (phase == PHASE_SNOOZE && !snoring_sounds_turned_on) {
					//NSLog(@"latte8");
					curr_action = nil;
					curr_sound_action = nil;
					curr_light_action = nil;
				}
				
				if (curr_action != nil && ([[curr_action getValueForKey:@"Type"] isEqualToString:@"Sound"]
										   || [[curr_action getValueForKey:@"Type"] isEqualToString:@"Pause"]
										   /*|| [[curr_action getValueForKey:@"Type"] isEqualToString:@"Phase"]*/)) {
					//NSLog(@"latte9");
					//NSLog(@"type = %@",[curr_action getValueForKey:@"Type"]);
					curr_sound_action = curr_action;
					[self setSubPhaseTimeForNode:curr_action];
					
					/* Playes the audio if needed*/
					if ([[curr_action getValueForKey:@"Type"] isEqualToString:@"Sound"]) {
						//NSLog(@"latte10");
						/* Figure out the right volume to use. We always keep track of the wakeup_curr_volume
						   which is the default volume if nothing else is specified. There are three different
						   tags which can be used to override the wakeup_curr_volume:
						   RelativeVolume: value is specified in relation to wakeup_curr_volume (scaled according to wakeup_start_volume)
						   Volume: "hard" value, but still scaled according to wakeup_start_volume
						   HardVolume: absolute value, not scaled according to wakeup_start_volume
						 
						   The volume will always be scaled according to wakeup_start_volume (which is the Wakeup volume
						   setting in the Advanced settings view), with one exception: HardVolume
						 */
						int vol = wakeup_curr_volume;
						//NSLog(@"wakeup_curr_volume = %d",wakeup_curr_volume);
						if ([curr_sound_action getValueForKey:@"RelativeVolume"] != nil) {
							//NSLog(@"Setting RelativeVolume");
							vol += [Misc parseIntegerSpan:[curr_sound_action getValueForKey:@"RelativeVolume"]];
							//int rel_vol = [Misc parseIntegerSpan:[curr_sound_action getValueForKey:@"RelativeVolume"]];
							//NSLog(@"volstring = %@, rel_vol = %d",[curr_sound_action getValueForKey:@"RelativeVolume"],rel_vol);
						} else if ([curr_sound_action getValueForKey:@"Volume"] != nil) {
							//NSLog(@"Setting Volume");
							vol = [Misc parseIntegerSpan:[curr_sound_action getValueForKey:@"Volume"]];
						} else if ([curr_sound_action getValueForKey:@"HardVolume"] != nil) {
							//NSLog(@"Setting HardVolume");
							vol = [Misc parseIntegerSpan:[curr_sound_action getValueForKey:@"HardVolume"]];
						}
						//NSLog(@"volume before scaling = %d",vol);
						if ([curr_sound_action getValueForKey:@"HardVolume"] == nil) {
							//NSLog(@"Scaling volume");
							vol = vol*wakeup_start_volume/100;
							if (vol == 0)
								vol = 1; //round upward if zero
						}// else {
							//NSLog(@"Not scaling volume");
						//}
						//NSLog(@"volume after scaling = %d",vol);

						/* Only start playing if subPhaseTime is set. */
						if (curr_action.subPhaseTime != nil) {
							[self playSoundFromResource:[curr_sound_action getValueForKey:@"SoundResource"]
												 ofType:[curr_sound_action getValueForKey:@"SoundResourceType"]
											 withVolume:vol withRepeats:0];
							//NSLog(@"a");
						}// else
						//	NSLog(@"b");
					}
					
				} else if (curr_action != nil && ([[curr_action getValueForKey:@"Type"] isEqualToString:@"Volume"]
												  || [[curr_action getValueForKey:@"Type"] isEqualToString:@"Initialization"])) { //request to change the current volume
					if ([[curr_action getValueForKey:@"Type"] isEqualToString:@"Initialization"])
						phase_init_done = YES;
					//NSLog(@"latte11");
					//NSLog(@"Adjusting volume");
					NSString *val = [curr_action getValueForKey:@"AdjustVolume"];
					if (val != nil) {
						if ([val characterAtIndex:0] == '+') {
							wakeup_curr_volume += [[val substringFromIndex:1] intValue];
						} else if ([val characterAtIndex:0] == '-') {
							wakeup_curr_volume -= [[val substringFromIndex:1] intValue];
						} else {
							wakeup_curr_volume = [val intValue];
						}
						if (wakeup_curr_volume > 100)
							wakeup_curr_volume = 100;
						else if (wakeup_curr_volume < 0)
							wakeup_curr_volume = 0;
					} else {
						/* The AdjustVolumeByPhaseLength tag sets the volume according to for how
						   long we've been in the current phase. For example a value of 100 means that
						   the volume is 40 if we have done 40% of the current phase, a value of 200
						   means that the wakeup_curr_volume is 80 if we have done 40% of the current
						   phase. */
						double progress = 0;
						//NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
						//[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
						//NSString *dateStr = [inputFormatter stringFromDate:alarm_time];
						//NSLog(@"alarm_time = %@",dateStr);

						if (phase == PHASE_REM) {
							NSDate *rem_phase_start = [alarm_time addTimeInterval:-rem_length];
							//NSLog(@"rem_phase_start = %@",[inputFormatter stringFromDate:rem_phase_start]);
							NSTimeInterval secondsInPhase = [[NSDate date] timeIntervalSinceDate:rem_phase_start];
							progress = secondsInPhase/rem_length;
							//NSLog(@"secondsInPhase = %f, progress = %f",secondsInPhase,progress);
						} else if (phase == PHASE_SNOOZE) {
							//NSLog(@"snoozeTimer = %@",[inputFormatter stringFromDate:snoozeTimer]);
							NSTimeInterval secondsInPhase = [[NSDate date] timeIntervalSinceDate:snoozeTimer];
							progress = secondsInPhase/(snooze_interval*60);
							//NSLog(@"snooze: secondsInPhase = %f, progress = %f",secondsInPhase,progress);
						} else {
							NSLog(@"Warning: AdjustVolumeByPhaseLength is valid only in REM and SNOOZE phases, setting progress to zero.");
							progress = 0;
						}
						val = [curr_action getValueForKey:@"AdjustVolumeByPhaseLength"];
						wakeup_curr_volume = progress*[Misc parseIntegerSpan:val]/*/100*/;
						//NSLog(@"New wakeup_curr_volume + %d",wakeup_curr_volume);
					}
				} else if (curr_action != nil){ // if only light action
					//NSLog(@"latte12");
					curr_light_action = curr_action;
				}
			}
		}
	} else {
		phase = PHASE_IDLE;
	}
	
	/* Zero the some stuff if we are in idle phase. */ 
	if (phase == PHASE_IDLE) {
		if ([subphases count] > 0)
			[subphases removeAllObjects];
		/*if (curr_subphase.subPhaseTime != nil) {
			[curr_subphase.subPhaseTime release];
			curr_subphase.subPhaseTime = nil;
		}
		if (curr_action.subPhaseTime != nil) {
			[curr_action.subPhaseTime release];
			curr_action.subPhaseTime = nil;
		}*/
		curr_subphase = nil;
		curr_sound_action = nil;
		curr_light_action = nil;
		//if (subPhaseTime != nil)
		//	[subPhaseTime release];
		//subPhaseTime = nil;
		//TODO: Make sure that audio is stopped here!
		//stop audio;
		//NSLog(@"sekunder kvar att spela = %f",[scheduled_sound_stop_time timeIntervalSinceNow]);
		if ([scheduled_sound_stop_time timeIntervalSinceNow] > 0) {
			//NSLog(@"nisse");
			if (!player.playing) {
				double vol = 1.0;
				if (scheduled_sound_fading_volume) {
					/* Decrease the volume according to how much time is left. */
					vol = [scheduled_sound_stop_time timeIntervalSinceNow] / [scheduled_sound_stop_time timeIntervalSinceDate:scheduled_sound_start_time];
					//NSLog(@"sekunder kvar att spela = %f, intervallets langd = %f",[scheduled_sound_stop_time timeIntervalSinceNow],[scheduled_sound_stop_time timeIntervalSinceDate:scheduled_sound_start_time]);
				}
				//NSLog(@"LATTEvol = %f, lattevol2 = %d",vol,(int)(scheduled_sound_start_volume*vol));
				[self playSoundFromResource:scheduled_sound_file_name ofType:scheduled_sound_file_type withVolume:(int)(scheduled_sound_start_volume*vol) withRepeats:0];
			}
		}// else {
			//NSLog(@"pelle: sekunder kvar att spela = %f",[scheduled_sound_stop_time timeIntervalSinceNow]);
		//}
	}

	/* When we switch from the idle phase to another phase, let's disable dimming and
	   reset the last activity time. */
	if (phase != PHASE_IDLE && last_master_phase == PHASE_IDLE) {
		if (dimmed_at != nil) {
			[dimmed_at release];
			dimmed_at = nil;
		}
		[last_activity_time release];
		last_activity_time = [[NSDate alloc] init];
	}

	/* Always switch to the clock view whenever we switch phases.
	   => Actually skip this, because otherwise it behaves in a stupid way when
	   setting the alarm in the SetTimeViewCtrl. */
	/*if (last_master_phase != phase) {
		if (flipViewCtrl != nil && ((FlipViewCtrl *)flipViewCtrl).clockViewShown == NO)
			[((FlipViewCtrl *)flipViewCtrl) switchToClockView];
	}*/

}

- (void) disableScreenSaver {
	[UIApplication sharedApplication].idleTimerDisabled = YES; //qqq
	//last_activity_time = [[NSDate alloc] init]; //so that screen saver won't go on again!
	screen_locked = NO;
	//if (silentSound != nil)
	//	[silentSound release];
}

- (void) enableScreenSaver {
	[UIApplication sharedApplication].idleTimerDisabled = NO; //qqq
	screen_locked = YES;
	//if (silentSound != nil)
	//	[silentSound release];
	//silentSound = [[SilentSound alloc] initWithSoundPlaying:&soundPlaying];
}

- (void)drawRect:(CGRect)rect {
	//if (silentSound == nil)
	//	silentSound = [[SilentSound alloc] initWithSoundPlaying:&soundPlaying];
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	//NSLog(@"drawRect");
	int f = 0; //defalt font = thick digital
	UIColor *fC = [UIColor greenColor]; //default = green
	UIColor *bgC = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]; //default = black
	NSInteger dL = 5;
	NSInteger dimsAfter = 5;
	int rem_length = 10*60; //10 minutes
	NSDate *alarm_time = nil;
	if (!statisk && settings != nil) {
		alarm_time = settings.alarm_time;
		if (settings.advancedSettingsViewCtrl != nil) {
			dL = settings.advancedSettingsViewCtrl.dimming_level;
			dimsAfter = settings.advancedSettingsViewCtrl.goes_dim_after;
			rem_length = settings.advancedSettingsViewCtrl.rem_length*60;
			if (settings.advancedSettingsViewCtrl.fontAndColorViewCtrl != nil) {
				if (settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fontViewCtrl != nil)
					f = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fontViewCtrl.font;
				if (settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fgColorViewCtrl != nil) {
					NSInteger r_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fgColorViewCtrl.r_level;
					NSInteger g_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fgColorViewCtrl.g_level;
					NSInteger b_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.fgColorViewCtrl.b_level;
					fC = [UIColor colorWithRed:(float)r_level/255 green:(float)g_level/255 blue:(float)b_level/255 alpha:1.0];
				}
				if (settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.bgColorViewCtrl != nil) {
					NSInteger r_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.bgColorViewCtrl.r_level;
					NSInteger g_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.bgColorViewCtrl.g_level;
					NSInteger b_level = settings.advancedSettingsViewCtrl.fontAndColorViewCtrl.bgColorViewCtrl.b_level;
					bgC = [UIColor colorWithRed:(float)r_level/255 green:(float)g_level/255 blue:(float)b_level/255 alpha:1.0];
				}
			}
		}
	}
	
	/* Dim or undim the screen depending on the value of last_activity_time. */
	int dimingLevel = 0;
	if (dimmed_at != nil && [last_activity_time timeIntervalSinceNow] > -dimsAfter*60) {
		[dimmed_at release];
		dimmed_at = nil;
	} else if (dimmed_at == nil && !statisk && [last_activity_time timeIntervalSinceNow] < -dimsAfter*60)
		dimmed_at = [[NSDate alloc] init];
	if (dimmed_at != nil)
		dimingLevel = dL;

	/* Possibly lock the screen if user has been inactive for a certain amount of time. */
	/*if (screen_locked == NO)
		NSLog(@"screen_locked = NO");
	else
		NSLog(@"screen_locked = YES");*/

	//qqq:
	if (!statisk && settings.advancedSettingsViewCtrl.lock_screen == YES && screen_locked == NO
		&& dimmed_at != nil && [dimmed_at timeIntervalSinceNow] < -1*60
		/*&& [UIApplication sharedApplication].idleTimerDisabled == YES*/
		&& [alarm_time timeIntervalSinceNow] > (rem_length+2*60) && phase == PHASE_IDLE) {
		NSLog(@"Enabling screen saver one minute after dimming is turned on.");
		[self enableScreenSaver];
		//[UIApplication sharedApplication].idleTimerDisabled = NO; //qqq
		//screen_locked = YES;
	}

	/* In order to save battery make sure that the screen will just be updated every tenth second
	   after the dimming has been turned on for 10 minutes. */
	if (!statisk && dimmed_at != nil && [dimmed_at timeIntervalSinceNow] < -10*60
		&& [alarm_time timeIntervalSinceNow] > (rem_length+2*60)
		&& phase == PHASE_IDLE && timeUpdater.timeInterval < 9.0) {
		NSLog(@"Updating the screen every tenth second.");
		[self stopUpdateTimer];
		[self startUpdateTimer:10.0];
	}

	if (f == 0 || f == 1)
		[self ownFontsDrawRect:rect withFont:f andFontColor:fC andBgColor:bgC andDimingLevel:dimingLevel andLightAction:curr_light_action];
	else
		[self systemFontsDrawRect:rect withFont:f andFontColor:fC andBgColor:bgC andDimingLevel:dimingLevel andLightAction:curr_light_action];
    //[pool release];
}
				
				
/* This function redraws the view if the font or colors have changed. */
/*-(void)updateFont:(int)f andFontColor:(UIColor *)fontCol andBgColor:(UIColor *)bgCol {
	//if (f != font || fontCol != fontColor || bgCol != bgColor) {
		font = f;
		fontColor = fontCol;
		bgColor = bgCol;
		[self setNeedsDisplay];
	//}
}*/

/* This function redraws the view if the font has changed. */
/*-(void)updateFont:(int)f {
	//if (f != font) {
		font = f;
		[self setNeedsDisplay];
	//}
}*/

/* This function redraws the view if the font color has changed. */
/*-(void)updateFontColor:(UIColor *)fontCol {
	//if (fontCol != fontColor) {
		fontColor = fontCol;
		[self setNeedsDisplay];
	//}
}*/

/* This function redraws the view if the background color has changed. */
/*-(void)updateBgColor:(UIColor *)bgCol {
	//if (bgCol != bgColor) {
		bgColor = bgCol;
		//self.backgroundColor = bgColor;
		[self setNeedsDisplay];
	//}
}*/

- (void)dealloc {
	//TODO: Here we probably need to deallocate a lot of stuff, such as the images etc.
	if (timeUpdater != nil && [timeUpdater isValid]) {
		[timeUpdater invalidate];
		timeUpdater = nil;
	}
    [super dealloc];
}


@end
