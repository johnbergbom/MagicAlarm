//
//  RelaxViewCtrl.m
//  REMAlarmClock
//
//  Created by John Bergbom on 2/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RelaxViewCtrl.h"

@implementation RelaxViewCtrl

@synthesize chosen_relax_sound;
@synthesize clockView;

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
		self.title = @"Relax";
        self.tabBarItem.image = [UIImage imageNamed:@"relax.png"];
		
		/* Create the table view. */
		//myTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] 
		//											  style:UITableViewStyleGrouped];
		//myTableView.scrollEnabled = NO;
		
		/* There will be no stored settings the first time the user starts the program,
		 or if he has never changed any settings. Therefore use some hard coded
		 reasonable defaults in that case. */
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"relaxSound"] == nil)
			chosen_relax_sound = @"White noise";
		else
			chosen_relax_sound = [[NSUserDefaults standardUserDefaults] stringForKey:@"relaxSound"];
		//chosen_relax_sound = 0;
		/*if ([[NSUserDefaults standardUserDefaults] objectForKey:@"fadingForRelax"] == nil)
			fading = YES;
		else
			fading = [[NSUserDefaults standardUserDefaults] boolForKey:@"fadingForRelax"];*/
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"relaxStartingVolume"] == nil)
			starting_volume = 5;
		else
			starting_volume = [[NSUserDefaults standardUserDefaults] integerForKey:@"relaxStartingVolume"];
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"relaxPlayingTimeLength"] == nil)
			playing_time = 30; //unit: minutes
		else
			playing_time = [[NSUserDefaults standardUserDefaults] integerForKey:@"relaxPlayingTimeLength"];
		playing_started = NO;

		/* Create the settings menu. */
		settingsList = [[NSMutableArray alloc] init];
		[settingsList addObject:[self initializeSettingsItems]];

		/* Create the relaxing sounds menu. */
		//relaxList = [[NSMutableArray alloc] init];
		//[relaxList addObject:[self initializeRelaxingSoundItems]];
		[self initializeRelaxingSoundItems];

		/* Load the images for the start and stop buttons. */
		start_button_image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"startrelax" ofType:@"png"]];
		//UIImage *img = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"startrelax" ofType:@"png"]];
		//start_button_image = [img stretchableImageWithLeftCapWidth:5 topCapHeight:5];
		stop_button_image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stoprelax" ofType:@"png"]];

	}
    return self;
}


- (NSMutableArray *)initializeSettingsItems {
	NSMutableArray *sect = [[NSMutableArray alloc] init];
	//[sect addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Fading volume",@"title",nil]];
	[sect addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Starting volume",@"title",nil]];
	[sect addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Playing time",@"title",nil]];
	return sect;
}

- (void)initializeRelaxingSoundItems {
	//NSMutableArray *sect = [[NSMutableArray alloc] init];
	relaxList = [[NSMutableArray alloc] init];
	//[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"White noise",@"title",nil]];
	//[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Humming",@"title",nil]];
	//[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Bonfire",@"title",@"relax2",@"resource",@"mp3",@"type",nil]];
	//[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"BUGGTEST",@"title",@"BeepBeep",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Birds",@"title",@"Birds",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Fire",@"title",@"Fire",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Lullaby",@"title",@"ChildrensBox2",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Musical box",@"title",@"ChildrensBox",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mystic",@"title",@"Mystic",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Old clock",@"title",@"OldClock",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Park",@"title",@"Park",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Snoring",@"title",@"Snoring",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Steps on beach",@"title",@"StepsOnBeach",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Thunder",@"title",@"Thunder",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Waves",@"title",@"Waves",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"White noise",@"title",@"WhiteNoise",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wind at shore",@"title",@"WindAtShore",@"resource",@"mp3",@"type",nil]];
	[relaxList addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Wind chimes",@"title",@"WindChimes",@"resource",@"mp3",@"type",nil]];
	//return sect;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.view = view;
	//self.view.alpha = 0.2;
    [view release];
	
	picker = [[UIPickerView alloc] init];
	picker.delegate = self;
	picker.dataSource = self;
	picker.showsSelectionIndicator = YES;
	/* Make sure that the right theme is chosen upon startup. */
	//[picker selectRow:chosen_relax_sound inComponent:0 animated:NO];
	for (int i = 0; i < [relaxList count]; i++)
		if ([[[relaxList objectAtIndex:i] objectForKey:@"title"] isEqualToString:chosen_relax_sound]) {
			[picker selectRow:i inComponent:0 animated:NO];
			break;
		}
	[self.view addSubview:picker];

	CGRect frame = picker.frame;
	frame.size.height = [UIScreen mainScreen].applicationFrame.origin.y + [UIScreen mainScreen].applicationFrame.size.height - (frame.origin.y + frame.size.height);
	frame.origin.y = picker.frame.origin.y + picker.frame.size.height;
	myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = YES;
	myTableView.autoresizesSubviews = YES;
	myTableView.bounces = NO;
	//myTableView.dataSource = self;
	//myTableView.delegate = self;
	//TODO: It seems like UITableView disregards the values of separatorStyle/separatorColor.
	//This is probably a bug in the SDK. When this is fixed we can experiment with removing
	//the lines between cells, which might make the stop/start buttons and the progress bar
	//integration look prettier.
	//myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	//myTableView.separatorColor = [UIColor whiteColor];
	[self.view addSubview:myTableView];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [[relaxList objectAtIndex:row] objectForKey:@"title"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [relaxList count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	//NSLog(@"component = %d",component);
	chosen_relax_sound = [[relaxList objectAtIndex:row] objectForKey:@"title"];
	[[NSUserDefaults standardUserDefaults] setObject:chosen_relax_sound forKey:@"relaxSound"];
	/* If we are already playing something and we are in idle phase, then restart the playing
	   with the new sound. */
	if (playing_started) {
		/*startStopSegmentedControl.selectedSegmentIndex = 0; //calls startStopAction!
		if (clockView.phase == PHASE_IDLE)
			startStopSegmentedControl.selectedSegmentIndex = 1; //calls startStopAction!
		 */
		[self.clockView updateScheduledSoundFileName:[[relaxList objectAtIndex:row] objectForKey:@"resource"]
		 ofType:[[relaxList objectAtIndex:row] objectForKey:@"type"]];
	}
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 200.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0;
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
	return [settingsList count] + 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return [[settingsList objectAtIndex:section] count];
	else
		return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0 && indexPath.row == 0)
		return 45;
	else if (indexPath.section == 0 && indexPath.row == 1)
		return 45;
	else if (indexPath.section == 1 && indexPath.row == 0)
		return 55;
	else
		return 15;
}

CGContextRef MyCreateBitmapContext (int pixelsWide,
                                    int pixelsHigh)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    CGColorSpaceRelease( colorSpace );
	
    return context;
}

// Build a thumb image based on the grayscale percentage
id createImage(float percentage)
{
	CGRect aRect = CGRectMake(0.0f, 0.0f, 48.0f, 48.0f);
    CGContextRef context = MyCreateBitmapContext(48, 48);
    //CGRect aRect = CGRectMake(0.0f, 0.0f, 28.0f, 28.0f);
    //CGContextRef context = MyCreateBitmapContext(28, 28);
    CGContextClearRect(context, aRect);
	
    // Outer gray circle
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextFillEllipseInRect(context, aRect);
	
    // Inner circle with feedback levels
    //CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:percentage green:0.0f blue:0.0f alpha:1.0f] CGColor]);
    //CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:percentage green:0.0f blue:0.0f alpha:0.5f] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectInset(aRect, 4.0f, 4.0f));
	
    // Inner gray circle
    CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectInset(aRect, 16.0f, 16.0f));
	
    CGImageRef myRef = CGBitmapContextCreateImage (context);
    free(CGBitmapContextGetData(context));
    CGContextRelease(context);
	
    return [UIImage imageWithCGImage:myRef];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

	// Set up the cell...
	if (indexPath.section == 0 && indexPath.row == 0) {
		/*cell.text = [[[settingsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
		NSArray *segmentTextContent;
		segmentTextContent = [NSArray arrayWithObjects: @"OFF", @"ON", nil];
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
		[segmentedControl addTarget:self action:@selector(fadingAction:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.selectedSegmentIndex = (fading ? 1 : 0);
		CGRect frame = CGRectMake(165,
								  8,
								  self.view.bounds.size.width - (97 * 2.0),
								  29);
		segmentedControl.frame = frame;
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:segmentedControl];
		[segmentedControl release];*/

		cell.text = [[NSString alloc] initWithFormat:@"%@: %d",
					 [[[settingsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 starting_volume];
		if (startingVolumeSlider == nil) {
			startingVolumeSlider = [[UISlider alloc] init];
			//UIImage *stetchLeftTrack = [[UIImage imageNamed:@"leftslide2.png"]
			//							stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			//UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide2.png"]
			//							 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			//[startingVolumeSlider setThumbImage: [UIImage imageNamed:@"slider_ball2.png"] forState:UIControlStateNormal];
			//[startingVolumeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
			//[startingVolumeSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
			[startingVolumeSlider addTarget:self action:@selector(startingVolumeAction:) forControlEvents:UIControlEventValueChanged];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		startingVolumeSlider.frame = CGRectMake(195,4,self.view.bounds.size.width - (120 * 2.0)+10,44);
		startingVolumeSlider.backgroundColor = [UIColor clearColor];
		startingVolumeSlider.minimumValue = 1;
		startingVolumeSlider.maximumValue = 10;
		startingVolumeSlider.value = starting_volume;
		startingVolumeSlider.continuous = NO;
		[cell.contentView addSubview:startingVolumeSlider];
		
	} else if (indexPath.section == 0 && indexPath.row == 1) {
		cell.text = [[NSString alloc] initWithFormat:@"%@: %d min",
					 [[[settingsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"],
					 playing_time];
		if (playingTimeSlider == nil) {
			playingTimeSlider = [[UISlider alloc] init];
			//UIImage *minIm = [playingTimeSlider minimumValueImage];
			//UIImage *knob = createImage(0.5);
			//UIImage *knob = [UIImage imageNamed:@"slider_ball.png"];
			////[playingTimeSlider setThumbImage:knob forState:UIControlStateNormal];
			////[playingTimeSlider setThumbImage:knob forState:UIControlStateHighlighted];

			//UIImage *minIm = createImage(0.2);
			//UIImage *stetchLeftTrack = [minIm
			//							stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			//[playingTimeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
			//[playingTimeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateHighlighted];

			//UIImage *maxIm = createImage(0.8);
			//[playingTimeSlider setMaximumTrackImage:maxIm forState:UIControlStateNormal];
			//[playingTimeSlider setMaximumTrackImage:maxIm forState:UIControlStateHighlighted];

			////UIImage *stetchLeftTrack = [[UIImage imageNamed:@"leftslide2.png"]
				////						stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			//UIImage *laff = [UIImage imageWithCGImage:[minIm CGImage]];
			//UIImage *stetchLeftTrack = [laff
			//							stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			////UIImage *stetchRightTrack = [[UIImage imageNamed:@"rightslide2.png"]
				////						 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
			////[playingTimeSlider setThumbImage: [UIImage imageNamed:@"slider_ball3.png"] forState:UIControlStateNormal];
			////[playingTimeSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
			////[playingTimeSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
			
			//[playingTimeSlider setShowValue:YES];
			[playingTimeSlider addTarget:self action:@selector(playingTimeAction:) forControlEvents:UIControlEventValueChanged];
			//[cell.contentView addSubview:playingTimeSlider];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//playingTimeSlider.frame = CGRectMake(210,8,self.view.bounds.size.width - (120 * 2.0),29);
		playingTimeSlider.frame = CGRectMake(195,4,self.view.bounds.size.width - (120 * 2.0)+10,44);
		playingTimeSlider.backgroundColor = [UIColor clearColor];
		playingTimeSlider.minimumValue = 1;
		playingTimeSlider.maximumValue = 60;
		playingTimeSlider.value = playing_time;
		playingTimeSlider.continuous = NO;
		[cell.contentView addSubview:playingTimeSlider];
	} else if (indexPath.section == 1 && indexPath.row == 0) {
		//cell.text = [[NSString alloc] initWithFormat:@"%@: %d min",
		//			 [[[settingsList objectAtIndex:0] objectAtIndex:0] objectForKey:@"title"],
		//			 playing_time];
		if (startStopSegmentedControl == nil) {
			startStopSegmentedControl = [[UISegmentedControl alloc] initWithItems:
										 [NSArray arrayWithObjects:
										  stop_button_image,
										  start_button_image,
										  nil]];
		}
		//startStopSegmentedControl.momentary = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[startStopSegmentedControl addTarget:self action:@selector(startStopAction:) forControlEvents:UIControlEventValueChanged];
		startStopSegmentedControl.selectedSegmentIndex = (playing_started ? 1 : 0);
		startStopSegmentedControl.frame = CGRectMake(10,5,self.view.bounds.size.width - (20 * 2.0),45);
		//startStopSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		//startStopSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBordered;
		//startStopSegmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
		//startStopSegmentedControl.tintColor = [UIColor whiteColor];
		[cell.contentView addSubview:startStopSegmentedControl];
	} else { //if (indexPath.section == 0 && indexPath.row == 1) {
		if (progressView == nil) {
			progressView = [[UIProgressView alloc] init];
		}
		progressView.frame = CGRectMake(10,3,self.view.bounds.size.width - (20 * 2.0),10);
		//progressView.progress = 0.3;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:progressView];
	}
	
    return cell;
}

/*- (void)fadingAction:(UISegmentedControl *)sender {
	fading = [sender selectedSegmentIndex] == 1;
	[[NSUserDefaults standardUserDefaults] setBool:fading forKey:@"fadingForRelax"];
	//startStopSegmentedControl.selectedSegmentIndex = (fading ? 1 : 0);
}*/

/* This function makes sure that the stop button gets chosen when the
   relax sound playing timer stops. */
- (void)scheduledStoppingOfRelaxSound:(NSTimer*)theTimer {
	startStopSegmentedControl.selectedSegmentIndex = 0; //calls startStopAction!
	//don't stop the progressUpdater timer here, because startStopAction was
	//already called (automatically) when setting selectedSegmentIndex = 0 above
}

/* This function updates the progress bar when relax sounds are playing. */
- (void)updateProgress:(NSTimer*)theTimer {
	if (playing_started) {
		NSTimeInterval secondsPlayed = [[NSDate date] timeIntervalSinceDate:relaxSoundStartingTime];
		double progress = secondsPlayed/(playing_time*60);
		//NSLog(@"progress = %f",progress);
		progressView.progress = progress;
	}
	if (clockView.phase != PHASE_IDLE)
		startStopSegmentedControl.selectedSegmentIndex = 0; //calls startStopAction!
}

- (void)startStopAction:(UISegmentedControl *)sender {
	playing_started = [sender selectedSegmentIndex] == 1;
	if (playing_started) {
		//NSLog(@"Pressed start button");
		progressView.progress = 0.0;
		if (clockView.phase != PHASE_IDLE) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry, relax sounds cannot be played after the alarm has started."
														   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
			startStopSegmentedControl.selectedSegmentIndex = 0;
		} else {
			int pIndex = [picker selectedRowInComponent:0];
			/* Multiply the starting_volume by 10 because the scheduleBgSoundWithResource function
			 expects the values to be between 0-100 whereas in the user interface it goes between 0-10. */
			[self.clockView scheduleBgSoundWithResource:[[relaxList objectAtIndex:pIndex] objectForKey:@"resource"]
			 ofType:[[relaxList objectAtIndex:pIndex] objectForKey:@"type"]
			 fadingVolume:YES startVolume:starting_volume*10 playingTime:playing_time];
			//TODO: This is probably a memory leak when creating a new object
			//every time the start button is pressed
			automaticSoundStopper = [NSTimer scheduledTimerWithTimeInterval:playing_time*60
																	 target:self
																   selector:@selector(scheduledStoppingOfRelaxSound:)
																   userInfo:nil
																	repeats:NO];
			relaxSoundStartingTime = [[NSDate alloc] init]; //memory leak
			progressUpdater = [NSTimer scheduledTimerWithTimeInterval:2.0
															   target:self selector:@selector(updateProgress:)
															 userInfo:nil repeats:YES];
		}
	} else {
		//NSLog(@"Pressed stop button");
		progressView.progress = 0.0;
		if (automaticSoundStopper != nil && [automaticSoundStopper isValid]) {
			[automaticSoundStopper invalidate];
			automaticSoundStopper = nil;
		}
		if (progressUpdater != nil && [progressUpdater isValid]) {
			[progressUpdater invalidate];
			progressUpdater = nil;
		}
		//[automaticSoundStopper release];
		[self.clockView stopScheduledBgSound];
	}
}

- (void)startingVolumeAction:(UISlider *)slider {
	float val = (float) slider.value;
	starting_volume = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:starting_volume forKey:@"relaxStartingVolume"];
	[self.clockView updateScheduledSoundStartingVolume:starting_volume*10];
	[myTableView reloadData];
}

- (void)playingTimeAction:(UISlider *)slider {
	float val = (float) slider.value;
	playing_time = (NSInteger) val;
	[[NSUserDefaults standardUserDefaults] setInteger:playing_time forKey:@"relaxPlayingTimeLength"];
    //CGImageRef oldknobref = [knob CGImage];
    //UIImage *knob = createImage([slider value] / 100.0f);
    //[slider setThumbImage:knob forState:UIControlStateNormal];
    //[slider setThumbImage:knob forState:UIControlStateHighlighted];
    //CFRelease(oldknobref);

	/* If a relax sound is already turned on, then we need to take some more action here.
	   For example if the old length was 10 minutes and we have already played 5 minutes, and
	   the new length is just 2 minutes, then we should stop the playing. In all other cases
	   we should just update the progress bar and the automatic sound stopping timer. */
	if (playing_started) {
		NSTimeInterval secondsPlayed = [[NSDate date] timeIntervalSinceDate:relaxSoundStartingTime];
		[self.clockView updateScheduledSoundPlayingTime:playing_time*60-secondsPlayed];
		if (secondsPlayed > playing_time*60) {
			startStopSegmentedControl.selectedSegmentIndex = 0; //calls startStopAction!
		} else {
			double progress = secondsPlayed/(playing_time*60);
			progressView.progress = progress;
			if (automaticSoundStopper != nil && [automaticSoundStopper isValid]) {
				[automaticSoundStopper invalidate];
				automaticSoundStopper = nil;
			}
			automaticSoundStopper = [NSTimer scheduledTimerWithTimeInterval:(playing_time*60-secondsPlayed)
																	 target:self
																   selector:@selector(scheduledStoppingOfRelaxSound:)
																   userInfo:nil
																	repeats:NO];
		}
	}
	
	[myTableView reloadData];
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row == 0) {
		if(fontAndColorViewCtrl == nil) {
			fontAndColorViewCtrl = [[FontAndColorViewCtrl alloc] initWithParent:self];
			//[fontAndColorViewCtrl.view addTarget:self action:@selector(fontAndColorChanged:) forControlEvents:UIControlEventValueChanged];
			//[fontAndColorViewCtrl setFontColorObject:&fontColor];
			//[fontAndColorViewCtrl setParentObject:self];
		}
		//((UIDatePicker *)timeViewCtrl.view).date = alarm_time;
		//Push the view controller to the top of the stack.
		[self.navigationController pushViewController:fontAndColorViewCtrl animated:YES];
	}
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
	[chosen_relax_sound release];
	[startStopSegmentedControl release];
	[start_button_image release];
	[stop_button_image release];
	if (automaticSoundStopper != nil && [automaticSoundStopper isValid]) {
		[automaticSoundStopper invalidate];
		automaticSoundStopper = nil;
	}
	if (progressUpdater != nil && [progressUpdater isValid]) {
		[progressUpdater invalidate];
		progressUpdater = nil;
	}
	//[automaticSoundStopper release];
	[settingsList release];
	[relaxList release];
	[startingVolumeSlider release];
	[playingTimeSlider release];
	[picker release];
    [super dealloc];
}


@end
