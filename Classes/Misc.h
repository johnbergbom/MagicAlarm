//
//  Misc.h
//  REMAlarmClock
//
//  Created by John Bergbom on 5/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Misc : NSObject {

}

+ (NSDate *) setTimeInFuture:(NSDate *)targetTime;
+ (UIImage *) bgImageWithColor:(UIColor *)color andWidth:(size_t)width andHeight:(size_t)height;
+ (UIImage *) bgImageWithColor:(UIColor *)color;
+ (int) parseIntegerSpan:(NSString *) spanStr;
+ (int) get_random_number:(int)high;

@end
