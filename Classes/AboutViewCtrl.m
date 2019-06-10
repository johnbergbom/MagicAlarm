//
//  AboutViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AboutViewCtrl.h"

@implementation AboutViewCtrl

//@synthesize myTableView;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
        self.title = @"About";
        self.tabBarItem.image = [UIImage imageNamed:@"about.png"];
		
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
	myTableView.scrollEnabled = NO;
	myTableView.autoresizesSubviews = YES;
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
	if (indexPath.row == 0)
		return 340;//remAwakening.frame.size.height;
	else
		return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return @"Magic Alarm v. 1.0.1";
	else
		return @"Snooze interrupt";
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if (remAwakening == nil) {
		CGRect contentRect = [cell.contentView bounds];
		CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16/*myTableView.rowHeight-16*//*contentRect.size.height-16*/);
		//CGRect frame = CGRectMake(0,0,100,300);
		
		remAwakening = [[[UITextView alloc] initWithFrame:frame] autorelease];
		remAwakening.textColor = [UIColor blackColor];
		remAwakening.font = [UIFont fontWithName:@"Arial" size:18.0];
		//textView.delegate = self;
		remAwakening.backgroundColor = [UIColor whiteColor];
		
		remAwakening.text = @"Copyright (C) 2009\n\
		John Bergbom\nTomi Laurell\n\n\
		If you have any suggestions for new features, improvements, comments, bugs or other feedback, please send an email to magicalarm.bugs@gmail.com.\n\nWe look forward to your feedback for improving the application!";
		remAwakening.editable = NO;
		//textView.returnKeyType = UIReturnKeyDefault;
		//textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		
		//[cell.contentView addSubview:textView];
		//[cell layoutSubviews];
		remAwakening.scrollEnabled = YES;
		remAwakening.bounces = NO;
	}	
	//cell.editing = NO;
	//cell.editAction = nil;
	
	//remAwakening.frame = frame;
	//if (remAwakening != nil)
	[cell.contentView addSubview:remAwakening];
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
	[myTableView setDelegate:nil];
	[myTableView setDataSource:nil];
	[myTableView release];
    [super dealloc];
}

@end
