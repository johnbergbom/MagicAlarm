//
//  SilentSound.h
//  REMAlarmClock
//
//  Created by John Bergbom on 7/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
//#import <Foundation/Foundation.h>

//@class SettingsTableViewCtrl;

@interface SilentSound : NSObject <AVAudioPlayerDelegate> {
	NSTimer *silentSoundPlayerTimer;
	AVAudioPlayer *silentSoundPlayer;
	int *soundPlaying;
}

@property (assign) int *soundPlaying;
@property (retain) AVAudioPlayer *silentSoundPlayer;

@end
