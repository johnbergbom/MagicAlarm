//
//  Node.h
//  REMAlarmClock
//
//  Created by John Bergbom on 4/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Node : NSObject {
	
	Node *parent;
	NSMutableArray *children;
	NSString *key;
	NSString *value;
	int next_child_nbr;
	/* This is for handling the case where one wants to for example 5 times
	   go through the actions in a certain phase. */
	int roundCount;
	
	/* The value of subPhaseTime will not come from the xml file, but rather
	   be set programmatically for certain types of nodes (Sound, Pause
	   and Phase).*/
	NSDate *subPhaseTime;
}

- (NSString *) getNodeName;
- (NSString *) getSoundThemeName;
- (NSString *) getDescription;
- (NSString *) getAuthor;
- (double) getVersion;
- (int) getProbability;
- (NSString *) getOrder;
//- (int) getREMLength;
- (Node *) getObjectForKey:(NSString *)theKey;
- (NSString *) getValueForKey:(NSString *)theKey;
- (void) zeroCounters;
- (Node *) getNextChild;
- (int) getChildCount;

@property (retain) Node *parent;
@property (retain) NSMutableArray *children;
@property (retain) NSString *key;
@property (retain) NSString *value;
@property (assign) NSDate *subPhaseTime;

@end
