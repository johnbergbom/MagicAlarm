//
//  XMLParser.h
//  REMAlarmClock
//
//  Created by John Bergbom on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Phase.h"
#import "Node.h"


@interface XMLParser : NSObject {

/*	int first_parse_pos;
	int second_parse_pos;
	NSString *name; //parse_pos = 1, second_parse_pos = 0
	float version; //parse_pos = 2, second_parse_pos = 0
	Phase *rem_phase; //parse_pos = 0, second_parse_pos = 1
	int rem_length; //parse_pos = 1, second_parse_pos = 1
 */
	
	Node *root;
	NSString *name;
	NSMutableArray *stack;

}

- (Node *) parseXMLFile:(NSString *)fileName;

/*@property (retain) NSString *name;
@property float version;
@property int rem_length;
@property (retain) Phase *rem_phase;
*/

@property (retain) Node *root;
@property (retain) NSString *name;
@property (retain) NSMutableArray *stack;

@end
