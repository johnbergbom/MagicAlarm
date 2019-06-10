//
//  SilentSound.m
//  REMAlarmClock
//
//  Created by John Bergbom on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
/* Shortly after the screen is locked (around 20 seconds according to some source) the device will
 go into sleep state, which means that the application won't run at all. We would like to have the
 screen shut off to save battery while still having the application running. This doesn't seem to
 be possible, so we do a work around here: whenever the applicationWillResignActive function is
 called (it's called when the screen is locked, or if an interrupt comes such as an incoming phone
 call) we'll start playing silent audio which stops the phone from going into sleep state. */

//THIS CLASS ISN'T ACTUALLY USED (this stuff is done in MagicAlarmAppDelegate instead)!

#import "SilentSound.h"
//#import "ClockView.h"
#import <AudioToolbox/AudioServices.h>


@implementation SilentSound

@synthesize silentSoundPlayer;
@synthesize soundPlaying;

- (id)initWithSoundPlaying:(int *)sp {
	/*self.soundPlaying = sp;
	silentSoundPlayerTimer = [NSTimer scheduledTimerWithTimeInterval:8.0
															  target:self selector:@selector(playSilentSound:)
															userInfo:nil repeats:YES];*/
	return self;
}

/* Play sound if not playing already. */
- (void)playSilentSound:(NSTimer*)theTimer {
	/*NSLog(@"In playSilentSound");
	if ((silentSoundPlayer == nil || silentSoundPlayer.playing == NO) && *soundPlaying == 0) {
		NSLog(@"In playSilentSound: starting new sound");
		if (silentSoundPlayer != nil) {
			[silentSoundPlayer release];
			silentSoundPlayer = nil;
		}
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: [[NSBundle mainBundle] pathForResource:@"silentsound" ofType:@"mp3"]];
		NSError *outError = nil;
		AVAudioPlayer *newPlayer =
		[[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
											   error: &outError];
		if (outError != nil) {
			NSLog(@"Error playing silent sound: %@",[outError localizedDescription]);
			return;
		}// else {
		//NSLog(@"No error playing silent sound.");
		//}
		[fileURL release];
		
		self.silentSoundPlayer = newPlayer;
		self.silentSoundPlayer.delegate = self;
		[newPlayer release];
		
		AudioSessionSetActive(true);
		//NSLog(@"silent sound volume = 0.20");
		[self.silentSoundPlayer setVolume:0.01]; //0.05
		self.silentSoundPlayer.numberOfLoops = 0;
		[self.silentSoundPlayer prepareToPlay];
		[self.silentSoundPlayer play];
	}*/
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	//do nothing
	/*NSLog(@"silent sound interrupted");*/
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	//resume playing after interruption
	/*NSLog(@"silent sound interruption stopped");
	[player play];*/
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)playerLoc successfully:(BOOL)flag {
	//silentSoundPlaying = NO;
	//Be a good iPhone citizen and set the audio to inactive when the sound finished
	/*NSLog(@"silent sound stopped");
	if (*soundPlaying == 0) {
		NSLog(@"silent: turning off audio session");
		AudioSessionSetActive(false);
	}*/
}

- (void)dealloc {
	/*NSLog(@"Destroying SilentSound object.");
	if (silentSoundPlayer != nil && silentSoundPlayer.playing)
		[silentSoundPlayer stop];
	[silentSoundPlayer release];
	if (silentSoundPlayerTimer != nil && [silentSoundPlayerTimer isValid]) {
		[silentSoundPlayerTimer invalidate];
		silentSoundPlayerTimer = nil;
	}*/
    [super dealloc];
}

@end
