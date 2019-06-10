//
//  FontAndColorViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FontAndColorViewCtrl.h"


@implementation FontAndColorViewCtrl

@synthesize fontViewCtrl;
@synthesize fgColorViewCtrl;
@synthesize bgColorViewCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.navigationItem.title = @"Font & color";
		
		/* Create the table view. */
		self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
													  style:UITableViewStyleGrouped];
		self.tableView.scrollEnabled = NO;
		
		/* Create the settings menu. */
		menuList = [[NSMutableArray alloc] init];
		[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Font",@"title",nil]];
		[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Foreground color",@"title",nil]];
		[menuList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Background color",@"title",nil]];
		
		//Specify the foreground and background colors
		[self initFgColors];
		[self initBgColors];

		fontViewCtrl = [[FontViewCtrl alloc] initWithHeadline:@"Font"];
		fgColorViewCtrl = [[ColorViewCtrl alloc] initWithHeadline:@"Foreground color" andColors:fgColors andPrefix:@"fg"];
		bgColorViewCtrl = [[ColorViewCtrl alloc] initWithHeadline:@"Background color" andColors:bgColors andPrefix:@"bg"];
	}
    return self;
}

- (void) initFgColors {
	fgColors = [[NSMutableArray alloc] init];
	[fgColors addObject:[UIColor redColor]];
	[fgColors addObject:[UIColor greenColor]];
	[fgColors addObject:[UIColor blueColor]];
	[fgColors addObject:[UIColor yellowColor]];
	[fgColors addObject:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]]; //black
	[fgColors addObject:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]; //white
	[fgColors addObject:[UIColor cyanColor]];
	[fgColors addObject:[UIColor magentaColor]];
	[fgColors addObject:[UIColor purpleColor]];
	[fgColors addObject:[UIColor orangeColor]];
	[fgColors addObject:[UIColor brownColor]];
	[fgColors addObject:[UIColor colorWithRed:(float)112/255 green:(float)112/255 blue:(float)112/255 alpha:1.0]]; //gray
}

- (void) initBgColors {
	bgColors = [[NSMutableArray alloc] init];
	[bgColors addObject:[UIColor colorWithRed:(float)150/255 green:(float)0/255 blue:(float)0/255 alpha:1.0]]; //dark red
	[bgColors addObject:[UIColor colorWithRed:(float)40/255 green:(float)100/255 blue:(float)50/255 alpha:1.0]]; //dark green
	[bgColors addObject:[UIColor colorWithRed:(float)0/255 green:(float)0/255 blue:(float)150/255 alpha:1.0]]; //dark blue
	[bgColors addObject:[UIColor colorWithRed:(float)200/255 green:(float)200/255 blue:(float)0/255 alpha:1.0]]; //dark yellow
	[bgColors addObject:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]]; //black
	[bgColors addObject:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]; //white
	[bgColors addObject:[UIColor colorWithRed:(float)0/255 green:(float)175/255 blue:(float)175/255 alpha:1.0]]; //dark cyan
	[bgColors addObject:[UIColor colorWithRed:(float)150/255 green:(float)0/255 blue:(float)150/255 alpha:1.0]]; //dark magenta
	[bgColors addObject:[UIColor colorWithRed:(float)70/255 green:(float)0/255 blue:(float)70/255 alpha:1.0]]; //dark purple
	[bgColors addObject:[UIColor colorWithRed:(float)200/255 green:(float)100/255 blue:(float)0/255 alpha:1.0]]; //dark orange
	[bgColors addObject:[UIColor colorWithRed:(float)90/255 green:(float)60/255 blue:(float)30/255 alpha:1.0]]; //dark brown
	[bgColors addObject:[UIColor colorWithRed:(float)112/255 green:(float)112/255 blue:(float)112/255 alpha:1.0]]; //gray
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.view = view;
    [view release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [menuList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.text = [[menuList objectAtIndex:indexPath.row] objectForKey:@"title"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0) {
		if(fontViewCtrl == nil) {
			fontViewCtrl = [[FontViewCtrl alloc] initWithHeadline:@"Font"];
		}
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:fontViewCtrl animated:YES];
	} else if (indexPath.section == 0 && indexPath.row == 1) {
		if(fgColorViewCtrl == nil) {
			fgColorViewCtrl = [[ColorViewCtrl alloc] initWithHeadline:@"Foreground color" andColors:fgColors andPrefix:@"fg"];
		}
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:fgColorViewCtrl animated:YES];
	} else if (indexPath.section == 0 && indexPath.row == 2) {
		if(bgColorViewCtrl == nil) {
			bgColorViewCtrl = [[ColorViewCtrl alloc] initWithHeadline:@"Background color" andColors:bgColors andPrefix:@"bg"];
		}
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:bgColorViewCtrl animated:YES];
	}
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
