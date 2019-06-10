//
//  Misc.m
//  REMAlarmClock
//
//  Created by John Bergbom on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Misc.h"


@implementation Misc

/* This function returns an NSDate that is in the future. If the targetTime is already in
   the future then targetTime is returned, otherwise targetTime+24h is returned. This can
   be used for example to make sure that the alarm time is always set in the future. For
   example if at 01.00 o'clock the alarm is set to 07.00, then the alarm should go off 6
   hours later, but if the same thing is done at 08.00, then the alarm should go off 23
   hours later. */
+ (NSDate *) setTimeInFuture:(NSDate *)targetTime {
	NSDate *curr_time = [[NSDate alloc] init];
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:@"HH:mm:ss"];
	NSString *targetTimeStr = [inputFormatter stringFromDate:targetTime];
	NSString *currTimeStr = [inputFormatter stringFromDate:curr_time];
	//NSLog(@"targetTimeStr = %@",targetTimeStr);
	//NSLog(@"currTimeStr = %@",currTimeStr);
	BOOL targetTimeLater = NO;
	int i = 0;
	while (i < 8) {
		if ([targetTimeStr characterAtIndex:i]-'0' > [currTimeStr characterAtIndex:i]-'0') {
			targetTimeLater = YES;
			break;
		} else if ([targetTimeStr characterAtIndex:i]-'0' < [currTimeStr characterAtIndex:i]-'0') {
			break;
		}
		i++;
		if (i == 2 || i == 5) //don't need to compare the colons
			i++;
	}
	/*if (([targetTimeStr characterAtIndex:0]-'0' > [currTimeStr characterAtIndex:0]-'0') //hour[0] is more
	 || (([targetTimeStr characterAtIndex:0]-'0' == [currTimeStr characterAtIndex:0]-'0') //or (hour[0] is equal
	 && (([targetTimeStr characterAtIndex:1]-'0' > [currTimeStr characterAtIndex:1]-'0') //and (hour[1] is more
	 || ([targetTimeStr characterAtIndex:1]-'0' == [currTimeStr characterAtIndex:1]-'0') //or hour[1] is equal*/
	
	[inputFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *alarm_date = [inputFormatter stringFromDate:curr_time];
	[inputFormatter setDateFormat:@"HH"];
	NSString *hour = [inputFormatter stringFromDate:targetTime];
	[inputFormatter setDateFormat:@"mm"];
	NSString *minute = [inputFormatter stringFromDate:targetTime];
	NSString *date_str = [[NSString alloc] initWithFormat:@"%@ %@:%@:00",alarm_date,hour,minute];
	[inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *return_date;
	if (targetTimeLater) {
		return_date = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:date_str]];
		//NSLog(@"targetTimeLater = YES");
	} else {
		return_date = [[NSDate alloc] initWithTimeInterval:60*60*24 sinceDate:[inputFormatter dateFromString:date_str]];
		//NSLog(@"targetTimeLater = NO");
	}
	[curr_time release];
	return return_date;
}

/* Returns a an image using the specified color. */
+ (UIImage *) bgImageWithColor:(UIColor *)color andWidth:(size_t)width andHeight:(size_t)height {
	CGImageAlphaInfo alphaInfo        = kCGImageAlphaNoneSkipLast; //kCGImageAlphaNone;
	CGColorSpaceRef colorSpace      = CGColorSpaceCreateDeviceRGB(); //CGColorSpaceCreateWithName(kCGColorSpaceSRGB); //CGColorSpaceCreateDeviceRGB();
	size_t components      = 4; //CGColorSpaceGetNumberOfComponents( colorSpace );
	size_t bitsPerComponent = 8;
	size_t bytesPerRow      = (width * bitsPerComponent * components + 7)/8;
	//size_t dataLength      = bytesPerRow * height;
	
	//data = malloc( dataLength );
	//memset( data, 0, dataLength );
	
	CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height, bitsPerComponent,
														  bytesPerRow, colorSpace, alphaInfo );	
	//[[UIColor redColor] set];
	//UIColor *c = [UIColor blueColor];
	CGFloat *arr = (CGFloat *) CGColorGetComponents([color CGColor]);
	//CGContextSetRGBFillColor (bgPicContext, 1, 0, 0, 1);
	CGContextSetRGBFillColor (offscreenContext, arr[0],arr[1],arr[2],arr[3]);
	CGContextFillRect(offscreenContext, CGRectMake(0,0,96,130));
	CGImageRef ref = CGBitmapContextCreateImage(offscreenContext);
	UIImage *bgImage = [[UIImage alloc] initWithCGImage:ref];
	[ref release]; //zzz
	CGContextRelease(offscreenContext);
	CGColorSpaceRelease(colorSpace);
	//[arr release];
	return [bgImage autorelease];
}

/* Returns a an image using the specified color. */
+ (UIImage *) bgImageWithColor:(UIColor *)color {
	return [self bgImageWithColor:color andWidth:96 andHeight:130];
}

/* Takes a string formed by two integers separated by '-' and returns a random integer
   between these two number. Examples of valid strings:
   9-10 (from plus 9 to plus 10, same as 9-+10)
   -7 (-7 will be returned)
   -5-5 (from minus 5 to plus 5, same as -5-+5)
   -5--1 (from minus 5 to minus 1)
   -5-1 (from minus 5 to plus 1, same as -5-+1).
   For non parsable strings 0 will be returned. */
+ (int) parseIntegerSpan:(NSString *)spanStr {
	int retVal = 0;
	if (spanStr == nil) {
		NSLog(@"Warning: span is empty, returning a value of 0.");
		return retVal;
	}
	NSString *val = [spanStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	//NSLog(@"spanStr = %@, val = %@",spanStr,val);
	if ([val isEqualToString:@""]) {
		NSLog(@"Warning: span is empty, returning a value of 0.");
		return retVal;
	}
	NSArray *subPhaseLengthArr = [val componentsSeparatedByString:@"-"];
	/*NSLog(@"count = %d",[subPhaseLengthArr count]);
	for (int i = 0; i < [subPhaseLengthArr count]; i++) {
		NSLog(@"substring = %@",[subPhaseLengthArr objectAtIndex:i]);
	}*/
	if ([subPhaseLengthArr count] == 1) {
		retVal = [[subPhaseLengthArr objectAtIndex:0] intValue];
	} else if ([subPhaseLengthArr count] == 2) {
		/* The second substring is empty if the string ends with a '-', so in that case we'll treat
		 it as a hard number. Eg. '50-' means '50'. */
		if ([[subPhaseLengthArr objectAtIndex:1] isEqualToString:@""]) {
			retVal = [[subPhaseLengthArr objectAtIndex:0] intValue];
			NSLog(@"Warning: %@ is treated as %d",[subPhaseLengthArr objectAtIndex:0],retVal);
		} else if ([[subPhaseLengthArr objectAtIndex:0] isEqualToString:@""])
			retVal = [val intValue];
		else {
			int minVal = [[subPhaseLengthArr objectAtIndex:0] intValue];
			int maxVal = [[subPhaseLengthArr objectAtIndex:1] intValue];
			if (minVal > maxVal) {
				NSLog(@"Warning: minVal > maxVal, correcting.");
				int temp = maxVal;
				maxVal = minVal;
				minVal = temp;
			}
			//NSLog(@"minVal = %d, maxVal = %d",minVal,maxVal);
			retVal = [self get_random_number:maxVal-minVal];
			retVal += minVal;
		}
	} else if ([subPhaseLengthArr count] == 3) {
		if ([[subPhaseLengthArr objectAtIndex:0] isEqualToString:@""])  { //first character starts with '-'
			int minVal = [val intValue];
			int maxVal = [[subPhaseLengthArr objectAtIndex:2] intValue];
			if (minVal > maxVal) {
				NSLog(@"Warning: minVal > maxVal, correcting.");
				int temp = maxVal;
				maxVal = minVal;
				minVal = temp;
			}
			//NSLog(@"minVal = %d, maxVal = %d",minVal,maxVal);
			retVal = [self get_random_number:maxVal-minVal];
			retVal += minVal;
		} else if ([[subPhaseLengthArr objectAtIndex:1] isEqualToString:@""])  { //contains a  '--'
			int minVal = [val intValue];
			int maxVal = -[[subPhaseLengthArr objectAtIndex:2] intValue];
			if (minVal > maxVal) {
				NSLog(@"Warning: minVal > maxVal, correcting.");
				int temp = maxVal;
				maxVal = minVal;
				minVal = temp;
			}
			//NSLog(@"minVal = %d, maxVal = %d",minVal,maxVal);
			retVal = [self get_random_number:maxVal-minVal];
			retVal += minVal;
		} else {
			NSLog(@"Warning, faulty span value, returning a value of 0.");
		}
	} else if ([subPhaseLengthArr count] == 4) {
		if ([[subPhaseLengthArr objectAtIndex:0] isEqualToString:@""]        //first character starts with '-'
			&& [[subPhaseLengthArr objectAtIndex:2] isEqualToString:@""])  { //and contains a  '--'
			int minVal = [val intValue];
			int maxVal = -[[subPhaseLengthArr objectAtIndex:3] intValue];
			if (minVal > maxVal) {
				NSLog(@"Warning: minVal > maxVal, correcting.");
				int temp = maxVal;
				maxVal = minVal;
				minVal = temp;
			}
			//NSLog(@"minVal = %d, maxVal = %d",minVal,maxVal);
			retVal = [self get_random_number:maxVal-minVal];
			retVal += minVal;
		} else {
			NSLog(@"Warning, faulty span value, returning a value of 0.");
		}
	} else {
		NSLog(@"Warning, faulty span value, returning a value of 0.");
	}
	return retVal;
}

/* returns a number >= 0 && number <= high */
+ (int) get_random_number:(int)high {
	return (int) ((high+1)*(rand()/(RAND_MAX+1.0)));
}

@end
