//
//  ColorViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 7/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ColorViewCtrl.h"
#import "Misc.h"

@implementation ColorViewCtrl

@synthesize r_level;
@synthesize g_level;
@synthesize b_level;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (id)initWithHeadline:(NSString *)headline andColors:(NSMutableArray *)colorArray andPrefix:(NSString *)prefixStr {
    if (self = [super init]) {
		self.navigationItem.title = headline;
		//[self initColors];
		colors = colorArray;
		prefix = prefixStr;

		/* The default colors are white if prefix = "fg" and otherwise black. */
		if ([prefix isEqualToString:@"fg"]) {
			r_level = 255;
			g_level = 255;
			b_level = 255;
		} else {
			r_level = 0;
			g_level = 0;
			b_level = 0;
		}
		/* Fetch stored values if any exist. */
		NSString *key = [NSString stringWithFormat:@"%@RLevel",prefix];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil)
			r_level = [[NSUserDefaults standardUserDefaults] integerForKey:key];
		key = [NSString stringWithFormat:@"%@GLevel",prefix];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil)
			g_level = [[NSUserDefaults standardUserDefaults] integerForKey:key];
		key = [NSString stringWithFormat:@"%@BLevel",prefix];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:key] != nil)
			b_level = [[NSUserDefaults standardUserDefaults] integerForKey:key];
		
		[self initButtons];
    }
    return self;
}

- (void) initButtons {
	buttons = [[NSMutableArray alloc] init];
	int scrWidth = (int) [[UIScreen mainScreen] applicationFrame].size.width;
	int spaceWidth = 20;
	int sqWidth = (scrWidth-20-20 - spaceWidth*5)/6;
	UIButton *button;
	
	int col = 0;
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 6; j++) {
			button = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
			button.frame = CGRectMake(10+j*(sqWidth+spaceWidth), 10.0+i*50, sqWidth, sqWidth);
			button.backgroundColor = [colors objectAtIndex:col];
			[button setImage:[Misc bgImageWithColor:[colors objectAtIndex:col++] andWidth:sqWidth andHeight:sqWidth] forState:UIControlStateNormal];
			[button addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
			[buttons addObject:button];
			[button release];
		}
	}
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO;
	myTableView.autoresizesSubviews = YES;
	myTableView.bounces = NO;
	self.view = myTableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0)
		return 50;
	else if (indexPath.section == 1 && indexPath.row == 0)
		return 100;
	else
		return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0 || section == 1)
		return 1;
	else
		return 3;
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
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10,8,130,30)] autorelease];
		label.numberOfLines = 0;
		//label.backgroundColor = [UIColor blueColor];
		label.text = @"Chosen color:";
		[cell.contentView addSubview:label];
		UIView *bgViewChosen = [[UIView alloc] initWithFrame:CGRectMake(154.0,9.0,137.0,32.0)];
		bgViewChosen.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
		[cell.contentView addSubview:bgViewChosen];
		[bgViewChosen release];
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(155,10,135,30)];
		[view setBackgroundColor:[UIColor colorWithRed:(float)r_level/255 green:(float)g_level/255 blue:(float)b_level/255 alpha:1.0]];
		[cell.contentView addSubview:view];
		//UILabel *test = cell.detailTextLabel;
		[view release];
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		for (int i = 0; i < [buttons count]; i++) {
			/* If white, then draw a black frame around the color. */
			UIButton *button = [buttons objectAtIndex:i];
			CGFloat *arr = (CGFloat *) CGColorGetComponents([button.backgroundColor CGColor]);
			if (arr[0] == 1.0 && arr[1] == 1.0 && arr[2] == 1.0) {
				UIView *blackBg = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x-1,button.frame.origin.y-1,button.frame.size.width+2,button.frame.size.height+2)];
				blackBg.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
				[cell.contentView addSubview:blackBg];
				[blackBg release];
			}
			[cell.contentView addSubview:[buttons objectAtIndex:i]];
			if (i == 11) //add at most 12 colors, there isn't room for more on the page!
				break;
		}
	} else if (indexPath.section == 2 && indexPath.row == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (rLevelSlider == nil) {
			rLevelSlider = [[UISlider alloc] init];
			[rLevelSlider addTarget:self action:@selector(rLevelAction:) forControlEvents:UIControlEventValueChanged];
		}
		rLevelSlider.frame = CGRectMake(10,10,215,29);
		rLevelSlider.minimumValue = 0;
		rLevelSlider.maximumValue = 255;
		rLevelSlider.value = r_level;
		rLevelSlider.continuous = NO;
		[cell.contentView addSubview:rLevelSlider];
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(235,8,63,30)] autorelease];
		label.numberOfLines = 0;
		label.text = [[NSString alloc] initWithFormat:@"R:%d",r_level];
		[cell.contentView addSubview:label];
		//[label release];
	} else if (indexPath.section == 2 && indexPath.row == 1) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (gLevelSlider == nil) {
			gLevelSlider = [[UISlider alloc] init];
			[gLevelSlider addTarget:self action:@selector(gLevelAction:) forControlEvents:UIControlEventValueChanged];
		}
		gLevelSlider.frame = CGRectMake(10,10,215,29);
		gLevelSlider.minimumValue = 0;
		gLevelSlider.maximumValue = 255;
		gLevelSlider.value = g_level;
		gLevelSlider.continuous = NO;
		[cell.contentView addSubview:gLevelSlider];
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(235,8,63,30)] autorelease];
		label.numberOfLines = 0;
		label.text = [[NSString alloc] initWithFormat:@"G:%d",g_level];
		[cell.contentView addSubview:label];
		//[label release];
	} else if (indexPath.section == 2 && indexPath.row == 2) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (bLevelSlider == nil) {
			bLevelSlider = [[UISlider alloc] init];
			[bLevelSlider addTarget:self action:@selector(bLevelAction:) forControlEvents:UIControlEventValueChanged];
		}
		bLevelSlider.frame = CGRectMake(10,10,215,29);
		bLevelSlider.minimumValue = 0;
		bLevelSlider.maximumValue = 255;
		bLevelSlider.value = b_level;
		bLevelSlider.continuous = NO;
		[cell.contentView addSubview:bLevelSlider];
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(235,8,63,30)] autorelease];
		label.numberOfLines = 0;
		label.text = [[NSString alloc] initWithFormat:@"B:%d",b_level];
		[cell.contentView addSubview:label];
		//[label release];
	}
	return cell;
}

- (void)rLevelAction:(UISlider *)sender {
	float val = (float) sender.value;
	r_level = (NSInteger) val;
	[self storeRGBValues];
	[self.view reloadData];
}

- (void)gLevelAction:(UISlider *)sender {
	float val = (float) sender.value;
	g_level = (NSInteger) val;
	[self storeRGBValues];
	[self.view reloadData];
}

- (void)bLevelAction:(UISlider *)sender {
	float val = (float) sender.value;
	b_level = (NSInteger) val;
	[self storeRGBValues];
	[self.view reloadData];
}

- (void)buttonTarget:(UIButton *)sender {
	//NSLog(@"buttonTarget");
	CGFloat *arr = (CGFloat *) CGColorGetComponents([sender.backgroundColor CGColor]);
	r_level = arr[0]*255;
	g_level = arr[1]*255;
	b_level = arr[2]*255;
	[self storeRGBValues];
	[self.view reloadData];
}

/* Store the rgb values to the filesystem. */
- (void) storeRGBValues {
	NSString *key = [NSString stringWithFormat:@"%@RLevel",prefix];
	[[NSUserDefaults standardUserDefaults] setInteger:r_level forKey:key];
	key = [NSString stringWithFormat:@"%@GLevel",prefix];
	[[NSUserDefaults standardUserDefaults] setInteger:g_level forKey:key];
	key = [NSString stringWithFormat:@"%@BLevel",prefix];
	[[NSUserDefaults standardUserDefaults] setInteger:b_level forKey:key];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
