//
//  SettingsTableViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsTableViewCtrl.h"
#import "Misc.h"


@implementation SettingsTableViewCtrl

@synthesize alarm_turned_on;
@synthesize rem_turned_on;
@synthesize alarm_time;
@synthesize advancedSettingsViewCtrl;
@synthesize shock_alarm_turned_on;
@synthesize snooze_interrupt_turned_on;
@synthesize clockView;
@synthesize timeViewCtrl;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];

		/* Create the table view. */
		self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
													  style:UITableViewStyleGrouped];
		self.tableView.scrollEnabled = NO;
		//self.tableView.alpha = 1.0;
		
		//self.tableView.delegate = self;
		//self.tableView.dataSource = self;
		//self.tableView.rowHeight = 54;
		//[self.tableView reloadData];

		/* There will be no stored settings the first time the user starts the program,
		   or if he has never changed any settings. Therefore use some hard coded
		   reasonable defaults in that case. */
		/*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"alarmTurnedOn"] == nil)
			alarm_turned_on = NO;
		else
			alarm_turned_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"alarmTurnedOn"];*/
		alarm_turned_on = YES;
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"remTurnedOn"] == nil)
			rem_turned_on = YES;
		else
			rem_turned_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"remTurnedOn"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"snoozeInterruptTurnedOn"] == nil)
			snooze_interrupt_turned_on = YES;
		else
			snooze_interrupt_turned_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"snoozeInterruptTurnedOn"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"shockAlarmTurnedOn"] == nil)
			shock_alarm_turned_on = YES;
		else
			shock_alarm_turned_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"shockAlarmTurnedOn"];
		/*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"teaserTurnedOn"] == nil)
			teaser_turned_on = YES;
		else
			teaser_turned_on = [[NSUserDefaults standardUserDefaults] boolForKey:@"teaserTurnedOn"];*/
		if (alarm_time == nil) {
			if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wakeUpTime"] == nil) {
				/* For some reason it's not possible to initiate alarm_time directly using
				   alarm_time = [inputFormatter dateFromString:@"07:00"], and therefore we
				   create a temporary object. */
				NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
				[inputFormatter setDateFormat:@"HH:mm"];
				//alarm_time = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:@"07:00"]];
				alarm_time = [Misc setTimeInFuture:[[NSDate alloc] initWithTimeInterval:0 sinceDate:[inputFormatter dateFromString:@"07:00"]]];
			} else {
				//alarm_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"wakeUpTime"];
				alarm_time = [Misc setTimeInFuture:[[NSUserDefaults standardUserDefaults] objectForKey:@"wakeUpTime"]];
			}
		}
		
		/* Create the settings menu. */
		menuList = [[NSMutableArray alloc] init];
		[menuList addObject:[self initializeAlarmSectionItems]];
		[menuList addObject:[self initializeClockSectionItems]];
		[menuList addObject:[self initializeAdvancedSectionItems]];
		//self.navigationController.view.backgroundColor = [UIColor redColor];
		//self.tableView.backgroundColor = [UIColor greenColor];
		//latte = @"start";
		
		advancedSettingsViewCtrl = /*[*/[[AdvancedSettingsTableViewCtrl alloc] initWithParent:self];//WithNibName:nil bundle:nil] autorelease];
	}
    return self;
}

- (NSMutableArray *)initializeAlarmSectionItems {
	NSMutableArray *alarmSection = [[NSMutableArray alloc] init];
	//temp = UITableViewCellAccessoryDisclosureIndicator;
	//nsInt = &temp;
	[alarmSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wake up time",@"title",nil]];
	[alarmSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Alarm",@"title",nil]];
	return alarmSection;
}

- (NSMutableArray *)initializeClockSectionItems {
	NSMutableArray *clockSection = [[NSMutableArray alloc] init];
	//[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Time format",@"title",nil]];
	//[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Show date",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"REM awakening",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shock alarm",@"title",nil]];
	//[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Teaser",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Snoring sounds",@"title",nil]];
	return clockSection;
}

- (NSMutableArray *)initializeAdvancedSectionItems {
	NSMutableArray *advancedSection = [[NSMutableArray alloc] init];
	[advancedSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Advanced settings",@"title",nil]];
	return advancedSection;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    //[view setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    //[view setBackgroundColor:_color];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//self.title = @"REMAlarmClockkkk";
	//self.tabBarItem.image = [UIImage imageNamed:@"Green.png"];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/


// Override to allow orientations other than the default portrait orientation.
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
  //return YES;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [menuList count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[menuList objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
		//if (timeViewCtrl != nil) {
		//	UIDatePicker *v = (UIDatePicker *) timeViewCtrl.view;
			//alarm_time = v.date;
		//}
		
		// Set up the cell...
		//cell.accessoryType = (UITableViewCellAccessoryType) [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"accessoryType"];
		if (indexPath.section == 0 && indexPath.row == 0) {
			//if (alarm_time != nil)
			NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
			[inputFormatter setTimeStyle:NSDateFormatterShortStyle];
			NSString *dateStr = [inputFormatter stringFromDate:alarm_time];
			cell.text = [[NSString alloc] initWithFormat:@"%@: %@",
						 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
						 dateStr/*[alarm_time descriptionWithCalendarFormat:@"%H:%M" timeZone:[NSTimeZone defaultTimeZone] locale:nil]*/];
			//[dateStr release];
			[inputFormatter release];
			//[dateStr release];
			//cell.text = latte;//[[NSString alloc] initWithFormat:@"%@ %@",
						 //[[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
						 //latte];
			//if (rem_turned_on == NO)
			//	cell.text = @"Opt awak OFF";
			//else
			//	cell.text = @"Opt awak ON";
			//latte = @"start2";
			//else
			//	cell.text = @"asd";
			//cell.text = [[NSString alloc] initWithFormat:@"Wakeup at %@",
			//			 [alarm_time descriptionWithCalendarFormat:@"%H:%M"
			//											  timeZone:[NSTimeZone defaultTimeZone]
			//												locale:nil]];
			//[[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.section == 2 && indexPath.row == 0) {
			cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else if (indexPath.section == 0 || indexPath.section == 1) {
			cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
			NSArray *segmentTextContent;
			UISegmentedControl *segmentedControl;
			if (indexPath.section == 0 && indexPath.row == 1) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				[segmentedControl addTarget:self action:@selector(alarmTurnedOnAction:) forControlEvents:UIControlEventValueChanged];
				segmentedControl.selectedSegmentIndex = (alarm_turned_on ? 1 : 0);
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}/* else if (indexPath.section == 1 && indexPath.row == 0) {
				segmentTextContent = [NSArray arrayWithObjects: @"12H", @"24H", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				[segmentedControl addTarget:self action:@selector(timeFormatAction:) forControlEvents:UIControlEventValueChanged];
				segmentedControl.selectedSegmentIndex = (american_time_style ? 0 : 1);
			}*//* else if (indexPath.section == 1 && indexPath.row == 1) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				segmentedControl.selectedSegmentIndex = (show_date ? 1 : 0);
				[segmentedControl addTarget:self action:@selector(showDateAction:) forControlEvents:UIControlEventValueChanged];
			}*/ else if (indexPath.section == 1 && indexPath.row == 0) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				segmentedControl.selectedSegmentIndex = (rem_turned_on ? 1 : 0);
				[segmentedControl addTarget:self action:@selector(remAction:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			} else if (indexPath.section == 1 && indexPath.row == 1) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				segmentedControl.selectedSegmentIndex = (shock_alarm_turned_on ? 1 : 0);
				[segmentedControl addTarget:self action:@selector(shockAlarmAction:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}/* else if (indexPath.section == 1 && indexPath.row == 2) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				segmentedControl.selectedSegmentIndex = (teaser_turned_on ? 1 : 0);
				[segmentedControl addTarget:self action:@selector(teaserAction:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}*/ else if (indexPath.section == 1 && indexPath.row == 2) {
				segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
				segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
				segmentedControl.selectedSegmentIndex = (snooze_interrupt_turned_on ? 1 : 0);
				[segmentedControl addTarget:self action:@selector(snoozeInterruptAction:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			CGRect frame = CGRectMake(165,
									  8,
									  self.view.bounds.size.width - (97 * 2.0),
									  29);
			segmentedControl.frame = frame;
			//segmentedControl.tintColor = [UIColor darkGrayColor];
			//segmentedControl.backgroundColor = [UIColor clearColor];
			//[segmentedControl sizeToFit];
			segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
			[cell.contentView addSubview:segmentedControl];
			[segmentedControl release];
		}
	
    return cell;
}

- (void)alarmTurnedOnAction:(id)sender {
	alarm_turned_on = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:alarm_turned_on forKey:@"alarmTurnedOn"];
	[timeViewCtrl.myTableView reloadData];
	[clockView stopAlarmSound];
}

/*
- (void)timeFormatAction:(id)sender {
	american_time_style = [sender selectedSegmentIndex] == 0;
}
*/

/*
- (void)showDateAction:(id)sender {
	show_date = [sender selectedSegmentIndex] == 1;
}
*/

- (void)remAction:(id)sender {
	rem_turned_on = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:rem_turned_on forKey:@"remTurnedOn"];
}

- (void)snoozeInterruptAction:(id)sender {
	snooze_interrupt_turned_on = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:snooze_interrupt_turned_on forKey:@"snoozeInterruptTurnedOn"];
}

- (void)shockAlarmAction:(id)sender {
	shock_alarm_turned_on = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:shock_alarm_turned_on forKey:@"shockAlarmTurnedOn"];
}

/*- (void)teaserAction:(id)sender {
	teaser_turned_on = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:teaser_turned_on forKey:@"teaserTurnedOn"];
}*/

//- (void)wakeUpTimeChanged:(id) picker {
- (void)wakeUpTimeChanged:(UIDatePicker *) picker {
	NSLog(@"Gick till wakeUpTimeChanged");
	//alarm_time = ((UIDatePicker *)timeViewCtrl.view).date;
	//alarm_time = ((UIDatePicker *)sender).date;
	//alarm_time = (NSDate *)sender;
	//alarm_time = ((UIDatePicker *)picker).date;
	if (clockView.phase != PHASE_IDLE) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The wakeup process has already started. Trying to change wakeup time has no effect."
													   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		alarm_time = [Misc setTimeInFuture:((UIDatePicker *)picker).date];
	}
	//alarm_time = [[NSDate alloc] initWithTimeInterval:0 sinceDate:picker.date];
	//if ([sender selectedSegmentIndex] == 0)
	//	american_time_style = YES;
	//else
	//	american_time_style = NO;
	//latte = @"vvv";
	[[NSUserDefaults standardUserDefaults] setObject:alarm_time forKey:@"wakeUpTime"];
	[self.tableView reloadData];
	[timeViewCtrl.myTableView reloadData];
	//NSLog(@"lattetest");
	//[self.view setNeedsDisplay];
	/*NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setTimeStyle:NSDateFormatterFullStyle];
	[inputFormatter setDateStyle:NSDateFormatterFullStyle];
	NSString *dateStr = [inputFormatter stringFromDate:alarm_time];
	[inputFormatter release];
	NSLog(@"alarm set to go off at %@",dateStr);*/
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0) {
		if(timeViewCtrl == nil) {
			////timeViewCtrl = [[SetTimeViewCtrl alloc] initWithNibName:@"SetTimeView" bundle:[NSBundle mainBundle]];
			timeViewCtrl = [[SetTimeViewCtrl alloc] initWithParent:self];
			////[timeViewCtrl.view addTarget:self action:@selector(wakeUpTimeChanged:) forControlEvents:UIControlEventValueChanged];
			[timeViewCtrl.datePicker addTarget:self action:@selector(wakeUpTimeChanged:) forControlEvents:UIControlEventValueChanged];
		}
		((UIDatePicker *)timeViewCtrl.datePicker).date = alarm_time;
		[self wakeUpTimeChanged:(UIDatePicker *)timeViewCtrl.datePicker];
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:timeViewCtrl animated:YES];
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		if(advancedSettingsViewCtrl == nil) {
			//advancedSettingsViewCtrl = [[SetTimeViewCtrl alloc] initWithNibName:@"SetTimeView" bundle:[NSBundle mainBundle]];
			advancedSettingsViewCtrl = /*[*/[[AdvancedSettingsTableViewCtrl alloc] initWithParent:self];//WithNibName:nil bundle:nil] autorelease];
			//[advancedSettingsViewCtrl.view addTarget:self action:@selector(wakeUpTimeChanged:) forControlEvents:UIControlEventValueChanged];
		}
		//((UIDatePicker *)advancedSettingsViewCtrl.view).date = alarm_time;
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:advancedSettingsViewCtrl animated:YES];
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[menuList release];
	[timeViewCtrl release];
	[alarm_time release];
	[advancedSettingsViewCtrl release];
    [super dealloc];
}


@end

