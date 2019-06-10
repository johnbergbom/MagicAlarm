//
//  AdvancedSettingsTableViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AdvancedSettingsTableViewCtrl.h"
#import "XMLParser.h"

@implementation AdvancedSettingsTableViewCtrl

@synthesize font;
@synthesize fontColor;
@synthesize bgColor;
@synthesize sound_theme;
@synthesize sound_theme_filename;
//@synthesize fontAndColorSubView;
@synthesize show_date;
@synthesize lock_screen; //qqq
@synthesize dimming_level;
@synthesize goes_dim_after;
@synthesize snooze_interval;
@synthesize rem_length;
@synthesize wakeup_master_volume;
@synthesize fontAndColorViewCtrl;
@synthesize parentObj;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */

- (id)initWithParent:(id)obj {
    self = [super init];
    if (self) {
		parentObj = obj;
	}
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        //self.title = @"Advanced Settings";
        //self.tabBarItem.image = [UIImage imageNamed:@"settings.png"];
		self.navigationItem.title = @"Advanced Settings";
		
		/* Create the table view. */
		self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
													  style:UITableViewStyleGrouped];
		self.tableView.scrollEnabled = NO;

		/* There will be no stored settings the first time the user starts the program,
		   or if he has never changed any settings. Therefore use some hard coded
		   reasonable defaults in that case. */
		/*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"americanTimeStyle"] == nil)
			american_time_style = YES;
		else
			american_time_style = [[NSUserDefaults standardUserDefaults] boolForKey:@"americanTimeStyle"];*/
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showDate"] == nil)
			show_date = YES;
		else
			show_date = [[NSUserDefaults standardUserDefaults] boolForKey:@"showDate"];
		
		//qqq:
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lockScreen"] == nil)
			lock_screen = YES;
		else
			lock_screen = [[NSUserDefaults standardUserDefaults] boolForKey:@"lockScreen"];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"snoozeInterval"] == nil)
			snooze_interval = 5; //unit: minutes
		else
			snooze_interval = [[NSUserDefaults standardUserDefaults] integerForKey:@"snoozeInterval"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"goesDimAfter"] == nil)
			goes_dim_after = 2; //unit: minutes
		else
			goes_dim_after = [[NSUserDefaults standardUserDefaults] integerForKey:@"goesDimAfter"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dimmingLevel"] == nil)
			dimming_level = 7;
		else
			dimming_level = [[NSUserDefaults standardUserDefaults] integerForKey:@"dimmingLevel"];
		
		/* TODO: Varmista Tomin kanssa etta on ok laittaa vaan 10 minuuttia oletukseksi eikä 20 minuuttia.
		   (Perustelu: Jotkut tykkaa REM-toiminallisuudesta ja ne voi sitten helposti pidentää
		   sen jaksoa. Taas toisia voi häiritä paljon se REM juttu ja ne voi antaa meille huonoa
		   palautetta jos puhelin herätti heidät liian kauan ennen herätyshetki. Eli toisen sanoen
		   luulisin että huono vaikutus REM:n vihamiehille on paljon suurempi kuin se hyvä vaikutus
		   REM:n rakastajille (jos REM vaihe on liian pitkä).) */
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"remLength"] == nil)
			rem_length = 15; //unit: minutes
		else
			rem_length = [[NSUserDefaults standardUserDefaults] integerForKey:@"remLength"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"wakeupMasterVolume"] == nil)
			wakeup_master_volume = 6; //10 means that the max volume of this application is the same as the phone's master volume
		else
			wakeup_master_volume = [[NSUserDefaults standardUserDefaults] integerForKey:@"wakeupMasterVolume"];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clockFont"] == nil)
			font = 0;
		else
			font = [[NSUserDefaults standardUserDefaults] integerForKey:@"clockFont"];

		/*NSData *theData=[NSKeyedArchiver archivedDataWithRootObject:[UIColor redColor]];
		[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"clockFontBgColor"];
		theData=[NSKeyedArchiver archivedDataWithRootObject:[UIColor greenColor]];
		[[NSUserDefaults standardUserDefaults] setObject:theData forKey:@"clockFontColor"];*/

		
		
		NSData *theData=[[NSUserDefaults standardUserDefaults] dataForKey:@"clockFontColor"];
		
		if (theData == nil)
			//fontColor = [[UIColor greenColor] CGColor];
			self.fontColor = [UIColor colorWithRed:(float)0/255
										green:(float)255/255
										 blue:(float)0/255 alpha:1.0];
		else {
			//CGColorRef *fc = (CGColorRef *)[NSUnarchiver unarchiveObjectWithData:theData];

			self.fontColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:theData];
			//fontColor = [UIColor greenColor];
		}
		theData=[[NSUserDefaults standardUserDefaults] dataForKey:@"clockFontBgColor"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"clockFontBgColor"] == nil)
			self.bgColor = [UIColor colorWithRed:(float)0/255
									  green:(float)0/255
									   blue:(float)0/255 alpha:1.0];
		else {
			//bgColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"clockFont"];
			self.bgColor = (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:theData];
			//bgColor = [UIColor blackColor];
		}
		//fontColor = [UIColor redColor];
		//bgColor = [UIColor redColor];
		//CGRect frame = CGRectMake(165,8,self.view.bounds.size.width - (97 * 2.0),29);
		//CGRect frame = CGRectMake(200,3,75,38);
		////fontAndColorSubView = [[ClockView alloc] initWithFrame:frame andFont:font andFontColor:fontColor andBgColor:bgColor andStatic:YES];
		//fontAndColorSubView.backgroundColor = [UIColor whiteColor];
		//[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:bgColor];
		//[fontAndColorSubView setNeedsDisplay];
		//sound_theme = [[SoundThemeReader alloc] init];
		XMLParser *parser = [[XMLParser alloc] init];
		//[parser parseXMLFile:@"st1"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"soundTheme"] == nil)
			//sound_theme = @"Nature";
			sound_theme = [parser parseXMLFile:@"WindChimes"];
		else
			//sound_theme = [[NSUserDefaults standardUserDefaults] stringForKey:@"soundTheme"];
			sound_theme = [parser parseXMLFile:[[NSUserDefaults standardUserDefaults] stringForKey:@"soundTheme"]];
		//sound_theme = @"Nature";
		//soundThemeView = [[SoundThemeView alloc] init];
	
		/* Create the settings menu. */
		menuList = [[NSMutableArray alloc] init];
		[menuList addObject:[self initializeClockSectionItems]];
		[menuList addObject:[self initializeThemeSectionItems]];

		fontAndColorViewCtrl = [[FontAndColorViewCtrl alloc] init];
	}
    return self;
}


- (NSMutableArray *)initializeClockSectionItems {
	NSMutableArray *clockSection = [[NSMutableArray alloc] init];
	//[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Time format",@"title",nil]];
	//[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Show date",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Lock screen",@"title",nil]]; //qqq
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Snooze interval",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Goes dim after",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Dimming level",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"REM length",@"title",nil]];
	[clockSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wakeup volume",@"title",nil]];
	return clockSection;
}

- (NSMutableArray *)initializeThemeSectionItems {
	NSMutableArray *alarmSection = [[NSMutableArray alloc] init];
	[alarmSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Font & color",@"title",nil]];
	[alarmSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Sound theme",@"title",nil]];
	//[alarmSection addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Customization",@"title",nil]];
	return alarmSection;
}


- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.view = view;
    [view release];
}


/*
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
	//										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  //initWithTitle:@"ZZZSettings"  style:UIBarButtonItemStyleBordered
											  //target:self action:@selector(cancel_Clicked:)] autorelease];
	//										  target:nil action:nil] autorelease];
	
}
*/


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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

	// Set up the cell...
	/*if (indexPath.section == 0 && indexPath.row == 0) {
		cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSArray *segmentTextContent = [NSArray arrayWithObjects: @"12H", @"24H", nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		[segmentedControl addTarget:self action:@selector(timeFormatAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex = (american_time_style ? 0 : 1);
		CGRect frame = CGRectMake(165,
								  8,
								  self.view.bounds.size.width - (97 * 2.0),
								  29);
		segmentedControl.frame = frame;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		[cell.contentView addSubview:segmentedControl];
		[segmentedControl release];
	} else */
	/*if (indexPath.section == 0 && indexPath.row == 0) {
		cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSArray *segmentTextContent;
		segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		[segmentedControl addTarget:self action:@selector(showDateAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex = (show_date ? 1 : 0);
		CGRect frame = CGRectMake(165,
								  8,
								  self.view.bounds.size.width - (97 * 2.0),
								  29);
		segmentedControl.frame = frame;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		[cell.contentView addSubview:segmentedControl];
		[segmentedControl release];		
	} else */

	//qqq:
	if (indexPath.section == 0 && indexPath.row == 0) {
		cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSArray *segmentTextContent;
		segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		[segmentedControl addTarget:self action:@selector(lockScreenAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex = (lock_screen ? 1 : 0);
		CGRect frame = CGRectMake(165,
								  8,
								  self.view.bounds.size.width - (97 * 2.0),
								  29);
		segmentedControl.frame = frame;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		[cell.contentView addSubview:segmentedControl];
		[segmentedControl release];
	} else
	
	if (indexPath.section == 0 && indexPath.row == 1) {
		//cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		//int f = [[NSUserDefaults standardUserDefaults] integerForKey:@"clockFont"];
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d min",
			[[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
			snooze_interval];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (snoozeSlider == nil) {
			snoozeSlider = [[UISlider alloc] init];
			[snoozeSlider addTarget:self action:@selector(snoozeIntervalAction:) forControlEvents:UIControlEventValueChanged];
		}
		//if (snoozeSliderRect == nil) {
			//snoozeSliderRect = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
			snoozeSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		//}
		snoozeSlider.minimumValue = 1;
		snoozeSlider.maximumValue = 30;
		snoozeSlider.value = snooze_interval;
		snoozeSlider.continuous = NO;
		[cell.contentView addSubview:snoozeSlider];
	} else if (indexPath.section == 0 && indexPath.row == 2) {
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d min",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 goes_dim_after];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (goesDimSlider == nil) {
			goesDimSlider = [[UISlider alloc] init];
			[goesDimSlider addTarget:self action:@selector(goesDimAction:) forControlEvents:UIControlEventValueChanged];
		}
		goesDimSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		goesDimSlider.minimumValue = 1;
		goesDimSlider.maximumValue = 30;
		goesDimSlider.value = goes_dim_after;
		goesDimSlider.continuous = NO;
		[cell.contentView addSubview:goesDimSlider];
	} else if (indexPath.section == 0 && indexPath.row == 3) {
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 dimming_level];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (dimmingLevelSlider == nil) {
			dimmingLevelSlider = [[UISlider alloc] init];
			[dimmingLevelSlider addTarget:self action:@selector(dimmingLevelAction:) forControlEvents:UIControlEventValueChanged];
		}
		dimmingLevelSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		dimmingLevelSlider.minimumValue = 1;
		dimmingLevelSlider.maximumValue = 9;
		dimmingLevelSlider.value = dimming_level;
		dimmingLevelSlider.continuous = NO;
		[cell.contentView addSubview:dimmingLevelSlider];
	} else if (indexPath.section == 0 && indexPath.row == 4) {
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d min",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 rem_length];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (remLengthSlider == nil) {
			remLengthSlider = [[UISlider alloc] init];
			[remLengthSlider addTarget:self action:@selector(remLengthAction:) forControlEvents:UIControlEventValueChanged];
		}
		remLengthSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		remLengthSlider.minimumValue = 1;
		remLengthSlider.maximumValue = 30;
		remLengthSlider.value = rem_length;
		remLengthSlider.continuous = NO;
		[cell.contentView addSubview:remLengthSlider];
	} else if (indexPath.section == 0 && indexPath.row == 5) {
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 wakeup_master_volume];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (wakeupVolumeSlider == nil) {
			wakeupVolumeSlider = [[UISlider alloc] init];
			[wakeupVolumeSlider addTarget:self action:@selector(wakeupVolumeAction:) forControlEvents:UIControlEventValueChanged];
		}
		wakeupVolumeSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		wakeupVolumeSlider.minimumValue = 1;
		wakeupVolumeSlider.maximumValue = 10;
		wakeupVolumeSlider.value = wakeup_master_volume;
		wakeupVolumeSlider.continuous = NO;
		[cell.contentView addSubview:wakeupVolumeSlider];
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		/*if (fontColor == nil)
			cell.text = @"fontColor nil";
		else
			cell.text = @"fontColor NOT nil";*/
		cell.text = [[NSString alloc] initWithFormat:@"%@:",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"]];
		/* For some reason calling the updateFont:andFontColor:andBgColor function of the fontAndColorSubView doesn't
		   work when updating the background color (although it _does_ work for the font and the font color). I could never
		   get this to work properly, so a workaround is therefore to skip displaying the font view in the Advanced Settings
		   view. (This works if one removes the fontAndColorSubView from its parent view every time and then create a new object,
		   BUT only if one avoids releasing the old object. If the old object is released then it doesn't work - weird. We don't
		   want to have any memory leaks, and therefore I removed this altogether.) The problem could possibly have something
		   to do with caching of objects(?), for example it could have something to do with the following line in the beginning
		   of this method:
		   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		   */
		
		//if (fontAndColorSubView == nil) {
			//fontAndColorSubView = [[ClockView alloc] initWithFrame:frame andFont:font andFontColor:fontColor andBgColor:bgColor andUpdateClock:YES];
			//fontAndColorSubView.backgroundColor = bgColor;
			////[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:bgColor];
			/*UIColor *tempColorBlue = [UIColor blueColor];
			UIColor *tempColorYellow = [UIColor yellowColor];
			if (CFEqual([fontColor CGColor],[tempColorBlue CGColor]))
				[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:[UIColor yellowColor]];
			else if (CFEqual([fontColor CGColor],[tempColorYellow CGColor]))
				[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:[UIColor blueColor]];
			else*/
		
			/* For some reason calling the updateFont:andFontColor:andBgColor function of the fontAndColorSubView doesn't
			   work when updating the background color (although it _does_ work for the font and the font color). Therefore
			   we rather create a new ClockView object here. I don't know why that is so. */
			////[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:bgColor];
			/*if (fontAndColorSubView != nil) {
				[fontAndColorSubView removeFromSuperview];
				[fontAndColorSubView stopUpdateTimer];
				[fontAndColorSubView release];
				fontAndColorSubView = nil;
			}
			if (fontAndColorSubView == nil) {
				CGRect frame = CGRectMake(200,3,75,38);
				fontAndColorSubView = [[ClockView alloc] initWithFrame:frame andFont:font andFontColor:fontColor andBgColor:bgColor andStatic:YES];
			}
			[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:bgColor];*/
		
			//fontAndColorSubView.backgroundColor = [UIColor grayColor];
			//[fontAndColorSubView setNeedsDisplay];
			//cell.contentView.backgroundColor = bgColor;
			//fontAndColorSubView.backgroundColor = bgColor;
			////[cell.contentView addSubview:fontAndColorSubView];
			//[self.tableView reloadData];
			//[fontAndColorSubView setNeedsDisplay];
			//fontAndColorSubView.backgroundColor = bgColor;
			//[fontAndColorSubView setNeedsDisplay];
		//} else {
		//	[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:[UIColor redColor]];
		//	[fontAndColorSubView updateFont:font andFontColor:fontColor andBgColor:[UIColor grayColor]];
		//	fontAndColorSubView.backgroundColor = [UIColor grayColor];
		//	[fontAndColorSubView setNeedsDisplay];
		//}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if (indexPath.section == 1 && indexPath.row == 1) {
		//cell.text = [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		cell.text = [[NSString alloc] initWithFormat:@"%@: %@",
					 [[[menuList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 [sound_theme getSoundThemeName]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
    return cell;
}

/*- (void)timeFormatAction:(id)sender {
	american_time_style = [sender selectedSegmentIndex] == 0;
	[[NSUserDefaults standardUserDefaults] setBool:american_time_style forKey:@"americanTimeStyle"];
}*/

- (void)showDateAction:(UISegmentedControl *)sender {
	show_date = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:show_date forKey:@"showDate"];
}

//qqq:
- (void)lockScreenAction:(UISegmentedControl *)sender {
	lock_screen = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:lock_screen forKey:@"lockScreen"];
	//[UIApplication sharedApplication].idleTimerDisabled = (lock_screen == NO);
}

- (void)snoozeIntervalAction:(UISlider *)sender {
	//snooze_interval = (NSInteger) [sender value];
	float val = (float) sender.value;
	snooze_interval = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:snooze_interval forKey:@"snoozeInterval"];
	[self.tableView reloadData];
}

- (void)goesDimAction:(UISlider *)sender {
	float val = (float) sender.value;
	goes_dim_after = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:goes_dim_after forKey:@"goesDimAfter"];
	[self.tableView reloadData];
}

- (void)dimmingLevelAction:(UISlider *)sender {
	float val = (float) sender.value;
	dimming_level = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:dimming_level forKey:@"dimmingLevel"];
	[self.tableView reloadData];
}

- (void)remLengthAction:(UISlider *)sender {
	float val = (float) sender.value;
	rem_length = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:rem_length forKey:@"remLength"];
	[self.tableView reloadData];
}

- (void)wakeupVolumeAction:(UISlider *)sender {
	float val = (float) sender.value;
	wakeup_master_volume = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:wakeup_master_volume forKey:@"wakeupMasterVolume"];
	[self.tableView reloadData];
}

/*
- (void)fontAndColorChanged:(UIPickerView *) picker {
	//alarm_time = ((UIDatePicker *)timeViewCtrl.view).date;
	//alarm_time = ((UIDatePicker *)sender).date;
	//alarm_time = (NSDate *)sender;
	alarm_time = picker.date;
	//alarm_time = [[NSDate alloc] initWithTimeInterval:0 sinceDate:picker.date];
	//if ([sender selectedSegmentIndex] == 0)
	//	american_time_style = YES;
	//else
	//	american_time_style = NO;
	//latte = @"vvv";
	[self.tableView reloadData];
	//[self.view setNeedsDisplay];	
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 0) {
		if(fontAndColorViewCtrl == nil) {
			//fontAndColorViewCtrl = [[FontAndColorViewCtrl alloc] initWithParent:self andFont:font andFontColor:fontColor andBgColor:bgColor];
			fontAndColorViewCtrl = [[FontAndColorViewCtrl alloc] init];
			//[fontAndColorViewCtrl.view addTarget:self action:@selector(fontAndColorChanged:) forControlEvents:UIControlEventValueChanged];
			//[fontAndColorViewCtrl setFontColorObject:&fontColor];
			//[fontAndColorViewCtrl setParentObject:self];
		}
		//((UIDatePicker *)timeViewCtrl.view).date = alarm_time;
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:fontAndColorViewCtrl animated:YES];
	} else if (indexPath.section == 1 && indexPath.row == 1) {
		if(soundThemeView == nil) {
			soundThemeView = [[SoundThemeView alloc] initWithParent:self andTheme:[sound_theme getSoundThemeName]];
		}
		//[soundThemeView selectedItem:sound_theme];
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:soundThemeView animated:YES];
	}
}

/*
- (void)latteTest {
}
*/

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
	[snoozeSlider release];
	[goesDimSlider release];
	[dimmingLevelSlider release];
	[remLengthSlider release];
	[wakeupVolumeSlider release];
	[fontAndColorViewCtrl release];
	[soundThemeView release];
	[sound_theme release];
	//[fontAndColorSubView stopUpdateTimer];
	//[fontAndColorSubView release];
    [super dealloc];
}


@end
