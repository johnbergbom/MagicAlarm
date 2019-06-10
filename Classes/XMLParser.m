//
//  XMLParser.m
//  REMAlarmClock
//
//  Created by John Bergbom on 4/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "XMLParser.h"


@implementation XMLParser

/*@synthesize name;
@synthesize version;
@synthesize rem_length;
@synthesize rem_phase;

- (id) init {
    if (self = [super init]) {
		name = nil;
		rem_length = 0;
		version = 0.0;
		first_parse_pos = 0;
		second_parse_pos = 0;
	}
	return self;
}

/*- (NSString *) getNameForXML:(NSString *)fileName {
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"]];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	BOOL success = [parser parse];
	if (success)
		return name;
	else
		return @"failed";
}/

- (BOOL) parseXMLFile:(NSString *)fileName {
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"]];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	return [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	//at_name = NO;
	if (first_parse_pos == 0 && second_parse_pos == 0 && [elementName isEqualToString:@"Name"]) {
		first_parse_pos = 1;
        return;
	} else if (first_parse_pos == 1 && second_parse_pos == 0 && [elementName isEqualToString:@"Version"]) {
		first_parse_pos = 2;
		return;
	} else if (first_parse_pos == 2 && second_parse_pos == 0 && [elementName isEqualToString:@"REM"]) {
		first_parse_pos = 0;
		second_parse_pos++;
		return;
	} else if (first_parse_pos == 0 && second_parse_pos == 1 && [elementName isEqualToString:@"Length"]) {
		first_parse_pos = 1;
		return;
	}
	//parse_pos = 0;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (first_parse_pos == 1 && second_parse_pos == 0) {
		name = [[NSString alloc] initWithString:string];
    } else if (first_parse_pos == 2 && second_parse_pos == 0) {
		version = [string floatValue];
    } else if (first_parse_pos == 0 && second_parse_pos == 1) {
		//do nothing, REM tag
    } else if (first_parse_pos == 1 && second_parse_pos == 1) {
		rem_length = [string intValue];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // ignore root and empty elements
    if ([elementName isEqualToString:@"REM"]) {
		first_parse_pos = 2
		second_parse_pos--;
	} else if ([elementName isEqualToString:@"REM"]) {
	parse_pos = 0;
	return;
}
*/

@synthesize root;
@synthesize name;
@synthesize stack;

- (Node *) parseXMLFile:(NSString *)fileName {
	self.root = [[Node alloc] init];
	self.root.parent = nil;
	self.root.key = nil;
	self.root.value = nil;
	self.root.children = [[NSMutableArray alloc] init];
	self.stack = [[NSMutableArray alloc] init];
	[self.stack addObject:self.root];

	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"]];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
	//self.name = @"Nature";
	//self.name = ((Node *)[self.root.children lastObject]).key;
	////return [parser parse];
	//return YES;
	return (Node *)[self.root.children lastObject];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	Node *leaf = [[Node alloc] init];
	leaf.parent = ((Node *)[stack lastObject]);
	//leaf.parent = self.root;
	
	[leaf.parent.children addObject:leaf];
	//[self.root.children addObject:leaf];
	
	leaf.key = elementName;
	leaf.value = nil;
	leaf.children = [[NSMutableArray alloc] init];
	[self.stack addObject:leaf];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	//((Node *)[self.stack lastObject]).value = string;
	((Node *)[self.stack lastObject]).value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return;

	/* Make sure that the all the data for the tag is read even if the data is spread out
	   across several lines. */
	/*if (((Node *)[self.stack lastObject]).value == nil) {
		//((Node *)[self.stack lastObject]).value = string;
		((Node *)[self.stack lastObject]).value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	} else {
		//((Node *)[self.stack lastObject]).value = [NSString stringWithFormat:@"%@%@", ((Node *)[self.stack lastObject]).value, string];
		((Node *)[self.stack lastObject]).value = [NSString stringWithFormat:@"%@%@", ((Node *)[self.stack lastObject]).value, [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}*/
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	[self.stack removeLastObject];
}

@end
