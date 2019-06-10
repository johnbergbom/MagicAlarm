//
//  HelpViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HelpViewCtrl.h"

@implementation HelpViewCtrl

//@synthesize myTableView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
        self.title = @"Help";
        self.tabBarItem.image = [UIImage imageNamed:@"help.png"];
		
		/*CGRect frame = CGRectMake(0,0,100,300);
		remAwakening = [[[UITextView alloc] initWithFrame:frame] autorelease];
		remAwakening.textColor = [UIColor blackColor];
		remAwakening.font = [UIFont fontWithName:@"Arial" size:18.0];
		//textView.delegate = self;
		remAwakening.backgroundColor = [UIColor whiteColor];
		remAwakening.text = @"REM awakening:\
		Quietly plays natural sounds (for example your neighbour's dog barks) a little before the \
		alarm goes off. The purpose is not to wake you up, but rather to prepare the body for \
		awakening. If you are already at a high point in the sleep cycle, then already these quiet \
		sounds will wake you up, and it will then be easy to get out of bed.";
		remAwakening.editable = NO;
		//textView.returnKeyType = UIReturnKeyDefault;
		//textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		//[cell.contentView addSubview:textView];
		//[cell layoutSubviews];
		remAwakening.scrollEnabled = NO;//YES;
		remAwakening.bounces = NO;*/
		
	}
	return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	/*UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
	//[view setBackgroundColor:_color];
	self.view = view;
	[view release];
	
	CGRect labelFrame = CGRectMake(48.0, 0.0, 100.0, 30.0);
	//UILabel *label = [[UILabel alloc] init];
	UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
	label.text = @"Help";
	[self.view addSubview:label];
	[label release];
	
	CGRect textFieldFrame = CGRectMake(40.0, 50.0, 200.0, 200.0);
	UITextView *textView = [[UITextView alloc] initWithFrame:textFieldFrame];
	textView.text = @"This view isn't yet implemented.";
	[self.view addSubview:textView];
	[textView release];
	//[self.view reloadData];
	*/
	/*self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	//tableView.delegate = self;
	//tableView.dataSource = self;
	//self.tableView.scrollEnabled = NO; //no scrolling for table view, rather do scrolling in the text view
	self.tableView.scrollEnabled = YES;
	self.tableView.autoresizesSubviews = YES;
	self.tableView.rowHeight = 300.0;*/
	
	//self.view = tableView;
	
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = YES;
	myTableView.autoresizesSubviews = YES;
	myTableView.bounces = NO;
	self.view = myTableView;
	
	/* Create the text view for the REM awakening help section. */
	/*
	CGRect frame = CGRectMake(0,0,100,300);
	remAwakening = [[[UITextView alloc] initWithFrame:frame] autorelease];
    remAwakening.textColor = [UIColor blackColor];
    remAwakening.font = [UIFont fontWithName:@"Arial" size:18.0];
    //textView.delegate = self;
    remAwakening.backgroundColor = [UIColor whiteColor];
	remAwakening.text = @"REM awakening:\n\
	Quietly plays natural sounds (for example your neighbour's dog barks) a little before the \
	alarm goes off. The purpose is not to wake you up, but rather to prepare the body for \
	awakening. If you are already at a high point in the sleep cycle, then already these quiet \
	sounds will wake you up, and it will then be easy to get out of bed.";
	remAwakening.editable = NO;
	remAwakening.scrollEnabled = NO;//YES;
	remAwakening.bounces = NO;
	*/
	
	
	
	
	
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0)
		return 430;
	else if (indexPath.section == 1 && indexPath.row == 0)
		return 110;
	else if (indexPath.section == 2 && indexPath.row == 0)
		return 90;
	else if (indexPath.section == 3 && indexPath.row == 0)
		return 130;
	else
		return 270;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 5; ///qqq: 5
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return @"REM Awakening";
	else if (section == 1)
		return @"Shock alarm";
	//else if (section == 2)
	//	return @"Teaser";
	else if (section == 2)
		return @"Snoring sounds";
	else if (section == 3)
		return @"Goes dim after";
	else
		return @"Battery saving";
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //[super viewDidLoad];
	//if(isViewPushed == NO) {
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  //initWithTitle:@"ZZZSettings"  style:UIBarButtonItemStyleBordered
											  //target:self action:@selector(cancel_Clicked:)] autorelease];
											  target:nil action:nil] autorelease];
	
	//}
}
*/

-(void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *CellIdentifier = @"Cell";
	NSString *CellIdentifier = [[NSString alloc] initWithFormat:@"Cell%d",indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (indexPath.section == 0 && indexPath.row == 0) {
		if (remAwakening == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16/*myTableView.rowHeight-16*//*contentRect.size.height-16*/);
			//CGRect frame = CGRectMake(0,0,100,300);
			
			remAwakening = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//remAwakening.textColor = [UIColor blackColor];
			//remAwakening.font = [UIFont fontWithName:@"Arial" size:18.0];
			//textView.delegate = self;
			//remAwakening.backgroundColor = [UIColor whiteColor];
			
			remAwakening.text = @"Quietly plays natural sounds (for example a mosquito gets into your bedroom) a little before the\
 alarm goes off. This will gradually raise the level of sleep by playing sounds of increasing intensity. If your body has\
 gotten enough sleep you will wake up at some point during this phase. If you are very tired or if you have set the\
 volume too low, then you'll at the latest wake up when the actual alarm goes off. Note that the actual alarm will go off at the time\
 that's set as wake up time. The REM phase will start before that, and the length of the REM phase is configurable. Different sound themes\
 will use different tactics during the REM phase. Select the one that's the most natural for you.";
			//remAwakening.text = [[NSBundle mainBundle] pathForResource:@"1_iso" ofType:@"png"];
			//remAwakening.text = [[NSBundle mainBundle] pathForResource:@"1_iso" ofType:@"png" inDirectory:@"Resources/fonts/font1"];
			//remAwakening.backgroundColor = [UIColor clearColor];
			//remAwakening.lineBreakMode = UILineBreakModeWordWrap;
			remAwakening.numberOfLines = 0;
			//remAwakening.editable = NO;
			//textView.returnKeyType = UIReturnKeyDefault;
			//textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
			
			//[cell.contentView addSubview:textView];
			//[cell layoutSubviews];
			//remAwakening.scrollEnabled = YES;
			//remAwakening.bounces = NO;
		}
		[cell.contentView addSubview:remAwakening];
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		if (shockAlarm == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			shockAlarm = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//shockAlarm.lineBreakMode = UILineBreakModeWordWrap;
			shockAlarm.numberOfLines = 0;
			shockAlarm.text = @"Recommended if you have a hard time getting up in the morning. It will\
 give you a shock if you snooze more than three times..";
			//shockAlarm.text = [[NSBundle mainBundle] bundlePath];
			//shockAlarm.text = [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:@"fonts"];
			//shockAlarm.text = [[NSBundle mainBundle] resourcePath];
			//shockAlarm.text = [[NSBundle bundleWithPath:@"Resources"] bundlePath];
			//shockAlarm.text = [[NSBundle mainBundle] pathForResource:@"5_iso" ofType:@"png" inDirectory:@"/Applications/REMAlarmClock.app/Resources/fonts/font1"];
			//shockAlarm.backgroundColor = [UIColor clearColor];
		}
		[cell.contentView addSubview:shockAlarm];
	} /*else if (indexPath.section == 2 && indexPath.row == 0) {
		if (teaser == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			teaser = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//teaser.lineBreakMode = UILineBreakModeWordWrap;
			teaser.numberOfLines = 0;
			teaser.text = @"This one can be recommended if you tend to half asleep turn off the alarm clock and then continue sleeping.\
 The teaser makes sure that you aren't able to turn off the alarm unless you can prove to the application that\
 you are really awake! (This is done by not turning off the alarm until you have passed a\
 test that's too tricky to solve if you are half asleep..)";
			//teaser.backgroundColor = [UIColor clearColor];
		}
		[cell.contentView addSubview:teaser];
	}*/ else if (indexPath.section == 2 && indexPath.row == 0) {
		if (snoozeInterrupt == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			snoozeInterrupt = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//snoozeInterrupt.lineBreakMode = UILineBreakModeWordWrap;
			snoozeInterrupt.numberOfLines = 0;
			snoozeInterrupt.text = @"Disturbing noise between snoozing, such as for example snoring. Makes it harder for you to fall asleep again.";
			//snoozeInterrupt.backgroundColor = [UIColor clearColor];
		}
		[cell.contentView addSubview:snoozeInterrupt];
	} else if (indexPath.section == 3 && indexPath.row == 0) {
		if (goesDimAfter == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			goesDimAfter = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//goesDimAfter.lineBreakMode = UILineBreakModeWordWrap;
			goesDimAfter.numberOfLines = 0;
			goesDimAfter.text = @"This setting sets the number of minutes until the clock fades away.\
 The clock will appear again by once tapping the screen. If you tap\
 again, then the clock will fade away again.";
			//goesDimAfter.backgroundColor = [UIColor clearColor];
		}
		[cell.contentView addSubview:goesDimAfter];
	} else if (indexPath.section == 4 && indexPath.row == 0) {
		if (batterySaving == nil) {
			CGRect contentRect = [cell.contentView bounds];
			CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
			batterySaving = [[[UILabel alloc] initWithFrame:frame] autorelease];
			//batterySaving.lineBreakMode = UILineBreakModeWordWrap;
			batterySaving.numberOfLines = 0;
			batterySaving.text = @"If you experience that the alarm clock drains to battery too quickly\
 it's possible to turn on the Lock screen setting. With this setting turned on the built in iPhone screen\
 saver will be turned on around two minutes after the screen in dimmed. This in turn means that the screen\
 saver will be turned on when the alarm goes off, so then you need to manually unlock the screen before\
 snoozing/turning off the alarm.";
			//batterySaving.backgroundColor = [UIColor clearColor];
		}
		[cell.contentView addSubview:batterySaving];
	}
	//cell.editing = NO;
	//cell.editAction = nil;

	//remAwakening.frame = frame;
	//if (remAwakening != nil)
	//[cell layoutSubviews];
	return cell;
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}
*/

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
	[remAwakening release];
	[snoozeInterrupt release];
	[shockAlarm release];
	[goesDimAfter release];
	[myTableView setDelegate:nil];
	[myTableView setDataSource:nil];
	[myTableView release];
    [super dealloc];
}

@end
