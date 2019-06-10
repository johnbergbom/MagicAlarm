//
//  SoundThemeView.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
//TODO: Make sure that the theme is chosen by default when the picker view
//is created.

#import "SoundThemeView.h"
#import "AdvancedSettingsTableViewCtrl.h"
#import "ClockView.h"
#import "XMLParser.h"
#import "Node.h"
#import "SettingsTableViewCtrl.h"


@implementation SoundThemeView

//extern int fontColor;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (id)initWithParent:(id)obj andTheme:(NSString *)theme {
    self = [super init];
    if (self) {
		parentObj = obj;
		temp = theme;
	}
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	self.navigationItem.title = @"Sound theme";
	
	/*NSFileManager *theManager = [[NSFileManager alloc] init];
	
	NSLog(@"tomi: testing file handling");
	
	NSDirectoryEnumerator *direnum = [theManager enumeratorAtPath:NSHomeDirectory()];	
	//NSDictionary *attributes;
	if([theManager createDirectoryAtPath:@"MagicAlarm.app/new" attributes:nil])
		NSLog(@"tomi: directory created");
	
	NSString *pname;
	NSString *modpname;
	
	while (pname = [direnum nextObject])
	{
		if ([[pname pathExtension] isEqualToString:@"rtfd"])
		{
			NSLog(@"tomi: something else found: %@",pname);
			/* don't enumerate this directory /
			[direnum skipDescendents];
		}
		else if([[pname pathExtension] isEqualToString:@"xml"])
		{
			NSLog(@"tomi: xml file found: %@",pname);
			
			NSData* testData = [theManager contentsAtPath:pname];
			char *testBuffer;
			unsigned int testLength;
			
			testLength = [testData length];
			
			printf("\nFILE LENGTH: %d\n",testLength);
			
			testBuffer = malloc(sizeof(char)*testLength);
			
			printf("\nFILE CONTENT %s\n", testBuffer);
			
			NSFileHandle *readFile;
			NSData* fileData;
			
			char *buffer;
			unsigned int length;

			readFile = [NSFileHandle fileHandleForReadingAtPath:pname];
			
			fileData = [readFile readDataToEndOfFile];
			
			length = [fileData length];
			buffer = malloc(sizeof(char)*length);
			[fileData getBytes: buffer];
			
			NSLog(@"tomi: file length %d",length);
			
			free(buffer);
		}
	}*/
	
	/* Creaqte the themes' menu. */
	[self initializeThemeList];
	
	pickerView = [[UIPickerView alloc] init];
	pickerView.delegate = self;
	pickerView.dataSource = self;
	pickerView.showsSelectionIndicator = YES;
	//[pickerView selectRow:3 inComponent:0 animated:NO];
	/* Make sure that the right theme is chosen upon startup. */
	for (int i = 0; i < [pickerItems count]; i++)
		if ([[[pickerItems objectAtIndex:i] objectForKey:@"title"] isEqualToString:temp]) {
			[pickerView selectRow:i inComponent:0 animated:NO];
			break;
		}
	
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[view setBackgroundColor:[UIColor blackColor]];
	self.view = view;
	[view release];
	
	[self.view addSubview:pickerView];

	CGRect frame = pickerView.frame;
	frame.size.height = [UIScreen mainScreen].applicationFrame.origin.y + [UIScreen mainScreen].applicationFrame.size.height - (frame.origin.y + frame.size.height);
	frame.origin.y = pickerView.frame.origin.y + pickerView.frame.size.height;
	myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO;
	myTableView.bounces = NO;
	[self.view addSubview:myTableView];
}

- (void)initializeThemeList {
	pickerItems = [[NSMutableArray alloc] init];
	XMLParser *parser = [[XMLParser alloc] init];
	//Node *n1 = [parser parseXMLFile:@"st1"];
	//[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n1 getSoundThemeName],@"title",@"st1",@"filename",[n1 getAuthor],@"author",[n1 getDescription],@"description",nil]];
	//Node *n2 = [parser parseXMLFile:@"st2"];
	//[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n2 getSoundThemeName],@"title",@"st2",@"filename",[n2 getAuthor],@"author",[n2 getDescription],@"description",nil]];
	Node *n1 = [parser parseXMLFile:@"Ambience"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n1 getSoundThemeName],@"title",@"Ambience",@"filename",[n1 getAuthor],@"author",[n1 getDescription],@"description",nil]];
	Node *n2 = [parser parseXMLFile:@"Birds"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n2 getSoundThemeName],@"title",@"Birds",@"filename",[n2 getAuthor],@"author",[n2 getDescription],@"description",nil]];
	Node *n3 = [parser parseXMLFile:@"Fire"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n3 getSoundThemeName],@"title",@"Fire",@"filename",[n3 getAuthor],@"author",[n3 getDescription],@"description",nil]];
	Node *n5 = [parser parseXMLFile:@"Mosquito"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n5 getSoundThemeName],@"title",@"Mosquito",@"filename",[n5 getAuthor],@"author",[n5 getDescription],@"description",nil]];
	Node *n4 = [parser parseXMLFile:@"MusicalBox"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n4 getSoundThemeName],@"title",@"MusicalBox",@"filename",[n4 getAuthor],@"author",[n4 getDescription],@"description",nil]];
	Node *n6 = [parser parseXMLFile:@"Nightmare"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n6 getSoundThemeName],@"title",@"Nightmare",@"filename",[n6 getAuthor],@"author",[n6 getDescription],@"description",nil]];
	Node *n7 = [parser parseXMLFile:@"Park"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n7 getSoundThemeName],@"title",@"Park",@"filename",[n7 getAuthor],@"author",[n7 getDescription],@"description",nil]];
	Node *n8 = [parser parseXMLFile:@"Wind"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n8 getSoundThemeName],@"title",@"Wind",@"filename",[n8 getAuthor],@"author",[n8 getDescription],@"description",nil]];
	Node *n9 = [parser parseXMLFile:@"WindChimes"];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:[n9 getSoundThemeName],@"title",@"WindChimes",@"filename",[n9 getAuthor],@"author",[n9 getDescription],@"description",nil]];
	[parser release];
	/*[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Nature",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Baby",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Household",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Traffic",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"City",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Horror",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Humor",@"title",nil]];*/
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[pickerItems objectAtIndex:row] objectForKey:@"title"];
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
		/*cell.text = [[NSString alloc] initWithFormat:@"Author: %@\
 Description: %@",@"LAUBERLATTE",@"DESCRIPTIONLATTE"];*/
		//if (textLabel != nil)
		//	[textLabel release];
		if (textLabel != nil)
			[textLabel removeFromSuperview];
		CGRect contentRect = [cell.contentView bounds];
		CGRect frame = CGRectMake(contentRect.origin.x + 8.0, contentRect.origin.y + 8.0, contentRect.size.width-28, [self tableView:tableView heightForRowAtIndexPath:indexPath]-16);
		textLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		textLabel.text = [[[NSString alloc] initWithFormat:@"Author: %@\nDescription: %@",
						  [[pickerItems objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"author"],[[pickerItems objectAtIndex:[pickerView selectedRowInComponent:0]] objectForKey:@"description"]] autorelease];
		textLabel.numberOfLines = 0;
		[cell.contentView addSubview:textLabel];
	}
	return cell;
}

/*
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	//TODO: Make sure that new objects aren't created each time!
	if (component == 0) {
		if (view == nil) {
			view = [[pickerItems objectAtIndex:component] objectAtIndex:row];
		}
	} else {
		if (view == nil) {
			CGRect frame = CGRectMake(50,8,self.view.bounds.size.width - (97 * 2.0),29);
			view = [[UIView alloc] initWithFrame:frame];
			view.backgroundColor = [[pickerItems objectAtIndex:component] objectAtIndex:row];
		}
	}
	return view;
}
*/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [pickerItems count];
}

/*
 - (void)setFontColorObject:(int *)obj {
 fontColor = obj;
 }
 */

/*
 - (void)setParentObject:(id)obj {
 parentObj = obj;
 }
 */

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//NSLog(@"reloading");
	[myTableView reloadData];
	XMLParser *parser = [[XMLParser alloc] init];
	Node *node = [parser parseXMLFile:[[pickerItems objectAtIndex:row] objectForKey:@"filename"]];
	//((AdvancedSettingsTableViewCtrl *)parentObj).sound_theme = [[pickerItems objectAtIndex:row] objectForKey:@"title"];
	((AdvancedSettingsTableViewCtrl *)parentObj).sound_theme = node;
	((AdvancedSettingsTableViewCtrl *)parentObj).sound_theme_filename = [[pickerItems objectAtIndex:row] objectForKey:@"filename"];
	[((AdvancedSettingsTableViewCtrl *)parentObj).tableView reloadData];
	[[NSUserDefaults standardUserDefaults] setObject:((AdvancedSettingsTableViewCtrl *)parentObj).sound_theme_filename forKey:@"soundTheme"];
	[parser release];
	/* Make sure that the theme is updated right away if the alarm is already turned on. */
	[((SettingsTableViewCtrl *)((AdvancedSettingsTableViewCtrl *)parentObj).parentObj).clockView.subphases removeAllObjects];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 140.0;
}

//- (void)selectedItem:(NSString *)theme {
	/*[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Nature",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Baby",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Household",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Traffic",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"City",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Horror",@"title",nil]];
	[pickerItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Humor",@"title",nil]];
	 */
	//[pickerView selectRow:3 inComponent:0 animated:NO];
	//[self.view setNeedsDisplay];
	//[pickerView.view reloadData];
//}

/*
 - (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
 return 40.0;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
 - (void)viewDidLoad {
 self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] 
 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
 target:nil action:nil] autorelease];
 }
 */

-(void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[pickerItems release];
	[pickerView release];
    [super dealloc];
}

@end
