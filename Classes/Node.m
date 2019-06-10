//
//  Node.m
//  REMAlarmClock
//
//  Created by John Bergbom on 4/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Node.h"


@implementation Node

@synthesize parent;
@synthesize children;
@synthesize key;
@synthesize value;
@synthesize subPhaseTime;

- (NSString *) getNodeName {
	return key;
	//return [self getValueForKey:@"Type"];
}

- (NSString *) getSoundThemeName {
	return [self getValueForKey:@"Name"];
}

- (NSString *) getDescription {
	return [self getValueForKey:@"Description"];
}

- (NSString *) getAuthor {
	return [self getValueForKey:@"Author"];
}

- (double) getVersion {
	return [[self getValueForKey:@"Version"] doubleValue];
}

- (int) getProbability {
	return [[self getValueForKey:@"Probability"] intValue];
}

- (int) getRounds {
	/* The default is one if no round is defined in the xml. */
	if ([self getValueForKey:@"Rounds"] == nil)
		return 1;
	else
		return [[self getValueForKey:@"Rounds"] intValue];
}

- (NSString *) getOrder {
	return [self getValueForKey:@"Order"];
}

- (void) zeroCounters {
	roundCount = 0;
	next_child_nbr = 0;
}

- (int) getChildCount {
	if (self.children == nil)
		return 0;
	else
		return [self.children count];
}

- (int) getGoodChildCount {
	int goodChildCount = 0;
	for (Node *node in self.children)
		if ([[node key] isEqualToString:@"Action"] || [[node key] isEqualToString:@"Phase"])
			goodChildCount++;
	return goodChildCount;
}

- (Node *) getGoodChild: (int) index {
	int goodChildCount = 0;
	for (Node *node in self.children){
		if ([[node key] isEqualToString:@"Action"] || [[node key] isEqualToString:@"Phase"]){
			if(goodChildCount == index){
				return node;
			}
			goodChildCount++;
		}
	}
	return nil;
}

/* returns a number >= 0 && number <= high */
- (int) get_random_number:(int)high {
	return (int) ((high+1)*(rand()/(RAND_MAX+1.0)));
}

/* This function returns the next child, or nil if no children left. */
- (Node *) getNextChild {
	
	if(roundCount >= [self getRounds]){
		roundCount = 0;
		return nil;
	}
	
	if([[self getOrder] isEqualToString:@"Random"]){
		int totalProbability = 0;
		for(int i=0; i<[self getGoodChildCount]; i++){
			int probability = [[self getGoodChild: i] getProbability];
			//NSLog(@"child prob = %d",probability);
			if (probability == 0) //will be 0 if tag not found, in which case the default is 100
				probability = 100;
			totalProbability += probability;
		}
		//NSLog(@"total prob = %d",totalProbability);
		
		int lotteryNumber = [self get_random_number:totalProbability];
		//NSLog(@"lotteryNumber = %d",lotteryNumber);
		
		//NSLog(@"john: lotteryNumber=%d, totalProbability=%d, getGoodChildCount=%d",lotteryNumber,totalProbability,[self getGoodChildCount]);
		
		int probabilityIndex = 0;
		
		for(int i=0; i<[self getGoodChildCount]; i++){
			int probability = [[self getGoodChild: i] getProbability];
			if (probability == 0) //will be 0 if tag not found, in which case the default is 100
				probability = 100;
			probabilityIndex += probability;
			if(probabilityIndex >= lotteryNumber){
				roundCount++;
				return [self getGoodChild: i];
			}
		}
		
		return nil;
		
	} else {
		if (next_child_nbr + 1 > [self getChildCount]){
			next_child_nbr = 0;
			roundCount++;
			return [self getNextChild];
		} else {
			next_child_nbr++;
			return [self.children objectAtIndex:next_child_nbr-1];
		}
	}
}

/*- (int) getREMLength {
	Node *n = [self getObjectForKey:@"REM"];
	NSString *n2 = [n getValueForKey:@"Length"];
	if (n2 == nil)
		return @"REM finns ej";
	else
		return n2; //@"REM finns";
	return [[[self getObjectForKey:@"REM"] getValueForKey:@"Length"] intValue];
}*/

/* Search through the child nodes of this node and return the one that matches
 the key, or nil if the key wasn't found. */
- (Node *) getObjectForKey:(NSString *)theKey {
	for (Node *node in self.children)
		if ([[node key] isEqualToString:theKey])
			return node;
	return nil;
}

/* Search through the child nodes of this node and return the value that matches
 the key, or nil if the key wasn't found. */
- (NSString *) getValueForKey:(NSString *)theKey {
	return [self getObjectForKey:theKey].value;
}

- (void)dealloc {
	if (subPhaseTime != nil) {
		[subPhaseTime release];
	}
    [super dealloc];
}

@end
