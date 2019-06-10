//
//  FontViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 7/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FontViewCtrl.h"


@implementation FontViewCtrl

@synthesize font;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithHeadline:(NSString *)headline {
    if (self = [super init]) {
		self.navigationItem.title = headline;

		/* Create the fonts menu. */
		[self initFontsMenu];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fontNumber"] != nil)
			font = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontNumber"];
		else
			font = 0; //default font = thick digital
	}
    return self;
}

- (void)initFontsMenu {
	fontList = [[NSMutableArray alloc] init];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Arial",@"title",@"4",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Digital 1",@"title",@"0",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Digital 2",@"title",@"1",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"MarkerFelt",@"title",@"2",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Trebuchet",@"title",@"6",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Verdana-Italic",@"title",@"3",@"fontNumber",nil]];
	[fontList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Zapfino",@"title",@"5",@"fontNumber",nil]];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.view = view;
    [view release];
	
	picker = [[UIPickerView alloc] init];
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	/* Make sure that the right font is chosen upon startup. */
	for (int i = 0; i < [fontList count]; i++)
		if ([[[fontList objectAtIndex:i] objectForKey:@"fontNumber"] intValue] == font) {
			[picker selectRow:i inComponent:0 animated:NO];
			break;
		}
	[self.view addSubview:picker];
	
	CGRect frame = picker.frame;
	frame.size.height = [UIScreen mainScreen].applicationFrame.origin.y + [UIScreen mainScreen].applicationFrame.size.height - (frame.origin.y + frame.size.height);
	frame.origin.y = picker.frame.origin.y + picker.frame.size.height;
	myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];	
	//myTableView.delegate = self;
	myTableView.dataSource = self;
	//myTableView.scrollEnabled = YES;
	myTableView.autoresizesSubviews = YES;
	myTableView.bounces = NO;
	[self.view addSubview:myTableView];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[fontList objectAtIndex:row] objectForKey:@"title"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [fontList count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	font = [[[fontList objectAtIndex:row] objectForKey:@"fontNumber"] intValue];
	//NSLog(@"Chosen font = %d",font);
	[[NSUserDefaults standardUserDefaults] setInteger:font forKey:@"fontNumber"];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 200.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
