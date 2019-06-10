//
//  SetTimeViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SetTimeViewCtrl.h"
#import "SettingsTableViewCtrl.h"

@implementation SetTimeViewCtrl

//@synthesize isViewPushed;
@synthesize datePicker;
@synthesize myTableView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
		self.navigationItem.title = @"Set wakeup time";
		//[self.view setBackgroundColor:[UIColor redColor]];
		//myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
		//myTableView.delegate = self;
		//myTableView.dataSource = self;
		//myTableView.scrollEnabled = YES;
		//myTableView.autoresizesSubviews = YES;
		//myTableView.bounces = NO;
		//self.view = myTableView;
		//pickerView = self.view;
		//[pickerView removeFromSuperview];
		//[self.view addSubview:pickerView];
		//[self.view addSubview:myTableView];
		datePicker = [[UIDatePicker alloc] init];
	}
	return self;
}

- (id)initWithParent:(id)obj {
    self = [super init];
    if (self) {
		parentObj = obj;
		//datePicker = [[UIDatePicker alloc] init];
	}
    return self;
}

 // Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.view = view;
    [view release];

	[self.view setBackgroundColor:[UIColor redColor]];
	//datePicker = [[UIDatePicker alloc] init];
	datePicker.datePickerMode = UIDatePickerModeTime;
	[self.view addSubview:datePicker];

	CGRect frame = datePicker.frame;
	frame.size.height = [UIScreen mainScreen].applicationFrame.origin.y + [UIScreen mainScreen].applicationFrame.size.height - (frame.origin.y + frame.size.height);
	frame.origin.y = datePicker.frame.origin.y + datePicker.frame.size.height;
	myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO;
	myTableView.bounces = NO;
	[self.view addSubview:myTableView];
}
 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*- (void)viewDidLoad {
    //[super viewDidLoad];
	//if(isViewPushed == NO) {
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  //initWithTitle:@"ZZZSettings"  style:UIBarButtonItemStyleBordered
											  //target:self action:@selector(cancel_Clicked:)] autorelease];
											  target:nil action:nil] autorelease];
	
	//}
}*/

-(void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *CellIdentifier = @"Cell";
	NSString *CellIdentifier = [[[NSString alloc] initWithFormat:@"Cell%d",indexPath.section] autorelease];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0 && indexPath.row == 0) {
		//if (wakeUpTimeInfo == nil) {
			//CGRect contentRect = [cell.contentView bounds];
			//CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			//wakeUpTimeInfo = [[[UILabel alloc] initWithFrame:frame] autorelease];
			if (((SettingsTableViewCtrl *)parentObj).alarm_turned_on == YES) {
				//NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
				//[inputFormatter setTimeStyle:NSDateFormatterShortStyle];
				//[inputFormatter setDateFormat:@"HH:mm"];
				//NSDate *curr_date = [[NSDate alloc] init];
				if (((SettingsTableViewCtrl *)parentObj).clockView.phase != PHASE_IDLE) {
					cell.text = @"Wakeup has started...";
				} else {
					NSTimeInterval interval = [((SettingsTableViewCtrl *)parentObj).alarm_time timeIntervalSinceDate:[NSDate date]];
					//[curr_date release];
					//NSLog(@"interval = %f",interval);
					//if (interval > 3600) {
					/* Possibly stop running alarms, in case the alarm time was changed enough. */
					if ([((SettingsTableViewCtrl *)parentObj).alarm_time timeIntervalSinceNow] > ((SettingsTableViewCtrl *)parentObj).advancedSettingsViewCtrl.rem_length*60)
						[((SettingsTableViewCtrl *)parentObj).clockView stopAlarmSound];
					int hours = (int)interval / 3600;
					int minutes = (int)(((int)interval) % 3600)/60;
					NSString *hoursStr = [[[NSString alloc] initWithFormat:
										   (hours > 9 ? @"%d" : @"0%d"),hours] autorelease];
					NSString *minutesStr = [[[NSString alloc] initWithFormat:
											 (minutes > 9 ? @"%d" : @"0%d"),minutes] autorelease];
					cell.text = [[[NSString alloc] initWithFormat:@"Time until wakeup: %@:%@",
								  hoursStr,minutesStr] autorelease];
				}
					//} else {
				//	cell.text = [[NSString alloc] initWithFormat:@"Time until wakeup: %d min",
				//				 (int)(((int)interval)%3600)/60];
				//}
				//NSString *dateStr = [inputFormatter stringFromDate:curr_date];
				//cell.text = [[NSString alloc] initWithFormat:@"Time until wakeup: %d hours",
				//			 dateStr];
				//[inputFormatter release];
			} else {
				cell.text = @"Alarm not turned on";
			}
			/*wakeUpTimeInfo.text = @"Quietly plays natural sounds (for example your neighbour's dog barks) a little before the\
			alarm goes off. The purpose is not to wake you up, but rather to prepare the body for\
			awakening. If you are already at a high point in the sleep cycle, then already these quiet\
			sounds will wake you up, and it will then be easy to get out of bed.";*/
			//wakeUpTimeInfo.numberOfLines = 0;
		//}
		//[cell.contentView addSubview:wakeUpTimeInfo];
	}
	return cell;
}

/*
 -(void) cancel_Clicked:(id)sender {
 [self.navigationController dismissModalViewControllerAnimated:YES];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	//self.view.frame = CGRectMake(20,20,320,216);
	//self.view.bounds = CGRectMake(20,20,320,216);
	//CGPoint cp;
	//cp.x = 100;//self.view.center.x + 10;
	//cp.y = 100;//self.view.center.y + 10;
	//self.view.center = cp;
	//return YES;
	
	/* There seems to be a bug in the UIDatePicker implementation that makes
	 the colors and size to be initialized the wrong way, and therefore let's not
	 support rotation of this view (because it looks quite ugly). */
	//return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
