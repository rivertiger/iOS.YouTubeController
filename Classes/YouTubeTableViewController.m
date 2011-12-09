//
//  YouTubeTableViewController.m
//
//  Created by James Nguyen on 10/10/09.
//

#import "YouTubeTableViewController.h"
#import "WebViewController.h"
#import "JSON.h"

//CUSTOMIZABLE CONSTANTS
#define kNavigationBarTitle		@"YouTube Table"
#define kYouTubeUsername		@"ENTER_YOUTUBE_USERNAME_HERE"
#define kItemTitleFont			@"TrebuchetMS-Bold"
#define kItemTitleColor			[UIColor blackColor]
#define kItemTitleFontSize		14.0f
#define kItemSubtextFont		@"Helvetica-Bold"
#define kItemSubtextFontSize	12.0f
#define kItemDescriptionColor		[UIColor lightGrayColor]
#define kItemSubtextColor		[UIColor blackColor]
#define kItemUsernameColor		[UIColor redColor]
#define imageEmptyStarRating	@"icn_star_empty_11x11.gif"
#define imageFullStarRating		@"icn_star_full_11x11.gif"




@implementation YouTubeTableViewController



- (void)dealloc {
    [super dealloc];


}

- (id)init
{
	
	//Set the Title for the View
	if (!(self = [super init])) return self;
	self.title = kNavigationBarTitle;
	
	
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

// loadWebView is a custom Method - called from modCell/UITableViewCell customizer
- (UIWebView *)loadWebView:(NSString *)passedURL {
	
	CGRect webFrame = CGRectMake(0.0f, 0.0f, 120.0f, 75.0f);
	UIWebView *myWebView = [[UIWebView alloc] initWithFrame:webFrame];
	NSString *testImage = @"http://www.google.com.br/intl/pt-BR_br/images/logo.gif";
	testImage = [testImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	myWebView.backgroundColor = [UIColor grayColor];
	myWebView.scalesPageToFit = YES;
	//myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	myWebView.delegate = self;

	//Custom UIWebView HTML
	NSMutableString *htmlString = [[NSMutableString alloc] initWithCapacity:200]; 
	[htmlString appendString:
	 @"<html><head>"
	 "<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head>"
	 "<body style=\"background:#F00;margin-top:0px;margin-left:0px\">"
	 "<div><object width=\"120\" height=\"90\">"
	 "<param name=\"movie\" value=\""];
	[htmlString appendString:passedURL];
	//[htmlString appendString:@"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\""];
	[htmlString appendString:@"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\""];
	[htmlString appendString:passedURL];
	//[htmlString appendString:@"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\""];
	[htmlString appendString:@" \"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"120\" height=\"90\"></embed>"
	 "</object></div></body></html>"];
	[myWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.your-url.com"]];
	return myWebView;
}




-(NSURL*)movieURL:(NSString*)fileName
{
    if (mMovieURL == nil)
    {
        NSBundle *bundle = [NSBundle mainBundle];
        if (bundle) 
        {
            NSString *moviePath = [bundle pathForResource:fileName ofType:@"mp4"];
            if (moviePath)
            {
                mMovieURL = [NSURL fileURLWithPath:moviePath];
                [mMovieURL retain];
            }
        }
    }
    
    return mMovieURL;
}


-(void)initMoviePlayer:(NSURL*)movieURL
{	
	if (movieURL != nil) {		
		mMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
		
		mMoviePlayer.scalingMode = MPMovieScalingModeAspectFill; 
		//mMoviePlayer.movieControlMode = MPMovieControlModeDefault;  // movieControlMode is deprecated
		
		
		// Register to receive a notification when the movie has finished playing. 	
		//[[NSNotificationCenter defaultCenter] addObserver:self 
		//										 selector:@selector(moviePreloadDidFinish:) 
		//											 name:MPMoviePlayerContentPreloadDidFinishNotification 
		//										   object:mMoviePlayer];
		
		// Register for the playback finished notification. 
		//[[NSNotificationCenter defaultCenter] addObserver:self 
		//										 selector:@selector(moviePlayBackDidFinish:) 
		//											 name:MPMoviePlayerPlaybackDidFinishNotification 
		//										   object:mMoviePlayer]; 
		
		//[[NSNotificationCenter defaultCenter] addObserver:self 
		//										 selector:@selector(movieScalingModeDidChange:) 
		//											 name:MPMoviePlayerScalingModeDidChangeNotification 
		//										   object:mMoviePlayer];
		
		[mMoviePlayer play];
		
	}			
}
- (NSString *) convertTimeFormat:(NSString *)aNumberString {
	int num_seconds = [aNumberString intValue];
	//NSLog(@"num_seconds passed is: %i", num_seconds);
	//float days = aFloatValue / (60 * 60 * 24);
	//float num_seconds -= days * (60 * 60 * 24);
	int hours = num_seconds / (60 * 60);
	//NSLog(@"Hour is: %i", hours);
	num_seconds -= hours * (60 * 60);
	int minutes = num_seconds / 60;
	//NSLog(@"Minutes is: %i", minutes);
	num_seconds -= minutes * (60);
	//NSLog(@"Seconds remaining is: %i", num_seconds);

	//convert time value passed into format
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setHour:hours];
	[comps setMinute:minutes];
	[comps setSecond:num_seconds];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
	[gregorian release];
	//NSLog(@"NSDate comps is. date is: %@", date);
	
	NSString *timeToReturn = date.description;
	timeToReturn = [timeToReturn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];		
	NSArray *timeArray = [timeToReturn componentsSeparatedByString:@" "];
	//NSLog(@"timeArray is: %@", timeArray);
	timeToReturn = [timeArray objectAtIndex:1];
	//separate the colons into array and parse and return the min:sec only
	timeArray = [timeToReturn componentsSeparatedByString:@":"];
	timeToReturn = [timeArray objectAtIndex:1];
	timeToReturn = [timeToReturn stringByAppendingString:@":"];
	timeToReturn = [timeToReturn stringByAppendingString:[timeArray objectAtIndex:2]];
	//NSLog(@"TimeToReturn is: %@", timeToReturn);
	return timeToReturn;
}

- (void)queryYouTube {
	username = kYouTubeUsername;
	NSLog(@"query YouTube is called.");
	// Create new SBJSON parser object
	SBJSON *jparser = [[SBJSON alloc] init];
	jparser.humanReadable = YES;
	
	//OPTION X: googleAJAXURL string for Web Search results
	//NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/web?v=1.0&&mrt=localonly&q=";
	
	//OPTION X: googleAJAXURL string for local Search results -- (4) complete datasets are returned each query
	//NSString *googleAJAXURL = @"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&q=";
	NSString *googleAJAXURL = @"http://gdata.youtube.com/feeds/users/";
	
	//call to clean up the passed query
	googleAJAXURL = [googleAJAXURL stringByAppendingString:username];
	googleAJAXURL = [googleAJAXURL stringByAppendingString:@"/uploads?alt=json&format=5"];
	//NSLog(@"googleAJAXURL = %@", googleAJAXURL);
	
	// Perform NSURL request and get back as a NSData object
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:googleAJAXURL]];	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil ];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
	//NSLog(@"returnstring = %@", returnString);	
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON response objects
	NSDictionary *JSONresponse = [jparser objectWithString:returnString error:nil];
	//NSLog(@"JSONresponse = %@", JSONresponse);
	
	// You can retrieve individual values using objectForKey on the status NSDictionary
	// This gives you the entire Youtube "feed"
	NSDictionary *JSONresponseSection = [JSONresponse objectForKey:@"feed"];
	//NSLog(@"JSPNresponsesection = %@", JSONresponseSection);
	
	// This entry returns all the list of Videos into an Array
	NSArray *JSONAllVideos = [JSONresponseSection objectForKey:@"entry"];
	   //NSLog(@"JSONAllVideos = %@", JSONAllVideos);
	
	int i;
	for(i=0; i<[JSONAllVideos count]; i++) {
		//This entry creates a dictionary to contain all metadata for one video
		NSDictionary *JSONOneVideo = [JSONAllVideos objectAtIndex:i];
		//NSLog(@"JSONOneVideo = %@", JSONOneVideo);
		
		//This entry creates a dictionary to seek out the title and add it to global IVAR _videoArrayTitle
		NSDictionary *JSONtitleSet = [JSONOneVideo objectForKey:@"title"];
		//NSString *JSONVideoTitle = [JSONtitleSet objectForKey:@"$t"];
		[_YTArrayVideoTitle addObject:[JSONtitleSet objectForKey:@"$t"]];
		//NSLog(@"JSONVideoTitle = %@", _YTArrayVideoTitle);

		
		//This entry creates a dictionary to seek out the viewcount and add it to global IVAR _
		NSArray *JSONviewCountSet = [JSONOneVideo objectForKey:@"yt$statistics"];
		//NSLog(@"JSONviewCountSet = %@", JSONviewCountSet);
		NSString *viewCount= [JSONviewCountSet valueForKey:@"viewCount"];
		if (viewCount == nil) {
			viewCount = @"0";
			[_YTArrayVideoViewCount addObject:viewCount];
		} else {
		[_YTArrayVideoViewCount addObject:viewCount];
		}
		//NSLog(@"_YTArrayVideoViewCount = %@", _YTArrayVideoViewCount);
		
		
		//This entry creates a dictionary to seek out the youtube feedback avg rating value and add it to global IVAR _
		NSArray *JSONratingsSet = [JSONOneVideo objectForKey:@"gd$rating"];
		//NSLog(@"JSONviewCountSet = %@", JSONviewCountSet);
		NSNumber *number = [JSONratingsSet valueForKey:@"average"];
		if (JSONratingsSet == nil) {
			NSString *numberString = @"0";
			[_YTArrayVideoRating addObject:numberString];
		} else {	
			[_YTArrayVideoRating addObject:[number stringValue]];
			//NSLog(@"ratingsExist was not null: %@", _YTArrayVideoRating);	
			
		}	
		//NSLog(@"ratingsExist = %@", JSONratingsSet);	
		
		//This entry creates a dictionary to seek out the media set which includes description, player, URL
		NSDictionary *JSONmediaSet= [JSONOneVideo objectForKey:@"media$group"];
		//NSLog(@"JSONmediaSet = %@", JSONmediaSet);	
		
			//This entry creates a dictionary to seek out the title and add it to global IVAR _
			NSDictionary *JSONdescriptionSet= [JSONmediaSet objectForKey:@"media$description"];
			[_YTArrayVideoDescription addObject:[JSONdescriptionSet objectForKey:@"$t"]];
			//NSLog(@"GlobalVideoDescription = %@", _YTArrayVideoDescription);	

			//This entry creates a dictionary to seek out the mediaplayerURL and add it to global IVAR _
			NSArray *JSONmediaPlayerSet= [JSONmediaSet objectForKey:@"media$player"];
			NSArray *tempArray = [JSONmediaPlayerSet objectAtIndex:0];
			NSString *tempURL = [tempArray valueForKey:@"url"];
			[_YTArrayVideoURL addObject:tempURL];
			//NSLog(@"JSONmedialPlayerSet array = %@", JSONmediaPlayerSet);
			//[_YTArrayVideoURL addObject:[JSONmediaPlayerSet objectAtIndex:0]];
			//NSLog(@"_YTArrayURL array = %@", _YTArrayVideoURL);

		
			//This entry creates a dictionary to seek out the mediaFlashPlayerURL and add it to global IVAR _
			JSONmediaPlayerSet= [JSONmediaSet objectForKey:@"media$content"];
			//[_YTArrayVideoFlashURL addObject:[JSONmediaPlayerSet objectAtIndex:0]];
			//NSLog(@"_YTArrayVideoFlashURL array = %@", _YTArrayVideoFlashURL);
			NSArray *contentArray = [JSONmediaPlayerSet objectAtIndex:0];
			[_YTArrayVideoFlashURL addObject:[contentArray valueForKey:@"url"]];
			//NSLog(@"tempContent = %@", _YTArrayVideoFlashURL);	
		
			//This entry creates an array for duration variable and add it to global IVAR _
			NSArray *JSONdurationSet= [JSONmediaSet objectForKey:@"yt$duration"];
			//NSLog(@"JSONdurationSet = %@", JSONdurationSet);
			NSString *numberString = [self convertTimeFormat:[JSONdurationSet valueForKey:@"seconds"]];
			[_YTArrayVideoDuration addObject:numberString];
			//NSLog(@"videoDuration = %@", _YTArrayVideoDescription);
		
			//This entry creates an array for thumbnail images and add it to global IVAR _
			NSArray *JSONthumbnailImageURLSet = [JSONmediaSet objectForKey:@"media$thumbnail"];
			NSArray *thumbnailImageURLArray = [JSONthumbnailImageURLSet objectAtIndex:0];
			//NSLog(@"thumbnailURLArray = %@", thumbnailImageURLArray);
			[_YTArrayVideoThumbnailImageURL addObject:[thumbnailImageURLArray valueForKey:@"url"]];
			//NSLog(@"thumbnailUImageURL = %@", _YTArrayVideoThumbnailImageURL);
	}
	/*
	 //HERES THE LOOP OF THE DATASET - count, collect fields, get coordinates and plot
	 int i;
	 for(i=0; i<[resultsSet count]; i++) {
	 NSDictionary *JSONresponseSectionSet = [resultsSet objectAtIndex:i];
	 NSString *link = [JSONresponseSectionSet objectForKey:@"link"];
	 //NSLog(@"link is = %@", link);
	 }	
	 */
	
	
}

- (void)viewDidLoad {
	_YTArrayVideoTitle = nil;
	_YTArrayVideoTitle = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoURL = nil;
	_YTArrayVideoURL = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoFlashURL = nil;
	_YTArrayVideoFlashURL = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoDescription = nil;
	_YTArrayVideoDescription = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoViewCount = nil;
	_YTArrayVideoViewCount = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoThumbnailImageURL = nil;
	_YTArrayVideoThumbnailImageURL = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoDuration= nil;
	_YTArrayVideoDuration = [[NSMutableArray alloc] initWithObjects:nil];
	_YTArrayVideoRating = nil;
	_YTArrayVideoRating = [[NSMutableArray alloc] initWithObjects:nil];
    [super viewDidLoad];
	[self queryYouTube];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
     return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//Subview for multi-line in UITableViewCell
- (void) modCell:(UITableViewCell *)aCell withTitle:(NSString *)title
	durationTime: (NSString *) durationTime description: (NSString *) description imagePath:(NSString *) imagePath
    rating:(NSString *) rating viewCount:(NSString *) viewCount
{	
	//OPTION2A: UNCOMMENT TO USE LOCAL FRAME
	//CGRect tRect1 = CGRectMake(0.0f, 0.0f, 120.0f, 75.0f);
	//UIWebView *myWebView = [[UIWebView alloc] initWithFrame:tRect1];
	//NSString *testImage = @"http://www.google.com.br/intl/pt-BR_br/images/logo.gif";
	//testImage = [testImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imagePath]]];
	//OPTION2B: UNCOMMENT TO USE CUSTOM METHOD TO CALL LOADVIEW
	UIWebView *myWebView = [self loadWebView:imagePath];
	
	// Title
	CGRect tRect2 = CGRectMake(125.0f, -8.0f, 190.0f, 40.0f);
	UILabel *title2 = [[UILabel alloc] initWithFrame:tRect2];
	[title2 setText:title];
	//[title2 setText:@"title title title title titkItemSubtextFontle title title title"];
	[title2 setTextAlignment:UITextAlignmentLeft];
	[title2 setFont:[UIFont fontWithName:kItemTitleFont size:kItemTitleFontSize]];
	title2.textColor = kItemTitleColor;
	[title2 setBackgroundColor:[UIColor clearColor]];
	
	// Subtext for video duration
	CGRect tRect3 = CGRectMake(125.0f, 54.0f, 150.0f, 20.0f);
	UILabel *title3 = [[UILabel alloc] initWithFrame:tRect3];
	//title2.tag = URLSTRING_TAG;
	//durationTime = [durationTime stringByAppendingString:@" sec"];
	[title3 setText:durationTime];
	[title3 setTextAlignment:UITextAlignmentLeft];
	[title3 setFont: [UIFont fontWithName:kItemSubtextFont size:kItemSubtextFontSize]];
	title3.textColor = kItemSubtextColor;
	[title3 setBackgroundColor:[UIColor clearColor]];	
	
	// Subtext for video description
	CGRect tRect4 = CGRectMake(125.0f, 1.0f, 160.0f, 60.0f);
	UILabel *title4 = [[UILabel alloc] initWithFrame:tRect4];
	title4.lineBreakMode = UILineBreakModeCharacterWrap;
	title4.numberOfLines = 2;
	[title4 setText:description];
	//[title4 setText:@"description description description description description description description description"];
	[title4 setTextAlignment:UITextAlignmentLeft];
	[title4 setFont: [UIFont fontWithName:kItemSubtextFont size:kItemSubtextFontSize]];
	title4.textColor = kItemDescriptionColor;
	[title4 setBackgroundColor:[UIColor clearColor]];	

	// Subtext for video userID
	CGRect tRect5 = CGRectMake(175.0f, 54.0f, 100.0f, 20.0f);
	UILabel *title5 = [[UILabel alloc] initWithFrame:tRect5];
	title5.lineBreakMode = UILineBreakModeClip;
	[title5 setText:kYouTubeUsername];
	[title5 setTextAlignment:UITextAlignmentLeft];
	[title5 setFont: [UIFont fontWithName:kItemSubtextFont size:kItemSubtextFontSize]];
	title5.textColor = kItemUsernameColor;
	[title5 setBackgroundColor:[UIColor clearColor]];	
	
	
	// display the viewCount
	CGRect tRect6= CGRectMake(190.0f, 44.0f, 100.0f, 11.0f);
	UILabel *title6 = [[UILabel alloc] initWithFrame:tRect6];
	title6.lineBreakMode = UILineBreakModeClip;
	viewCount = [viewCount stringByAppendingString:@" views"];
	[title6 setText:viewCount];
	[title6 setTextAlignment:UITextAlignmentLeft];
	[title6 setFont: [UIFont fontWithName:kItemSubtextFont size:kItemSubtextFontSize]];
	title6.textColor = kItemDescriptionColor;
	[title6 setBackgroundColor:[UIColor clearColor]];
	
	
	//star rating image calculation & display
	int i = 0;
	int baseNumberOfStarsRated = 0;
	float x = 0.0f;
	for (i=0; i < 5; i++) {
	CGRect frame = CGRectMake(125.0f + (x * i), 44.0f, 11.0f, 11.0f);
	UIImageView *starImg = [[UIImageView alloc] initWithFrame:frame];
		if (baseNumberOfStarsRated < [rating intValue]) {
			starImg.image = [UIImage imageNamed:imageFullStarRating];
			baseNumberOfStarsRated++;
			[aCell.contentView addSubview:starImg];
		} else {
			starImg.image = [UIImage imageNamed:imageEmptyStarRating];
			[aCell.contentView addSubview:starImg];
		}
	[starImg release];
	x = 11.0f;	
	}

	
	// Add to cell
	[aCell.contentView addSubview:myWebView];
	[aCell.contentView addSubview:title2];
	[aCell.contentView addSubview:title3];
	[aCell.contentView addSubview:title4];
	[aCell.contentView addSubview:title5];
	[aCell.contentView addSubview:title6];
	
	[myWebView release];
	[title2 release];
	[title3 release];
	[title4 release];
	[title5 release];
	[title6 release];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_YTArrayVideoTitle count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {   
return 75;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //int row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		NSString *videoPath = [_YTArrayVideoFlashURL objectAtIndex:indexPath.row];
		[self modCell:cell withTitle:[_YTArrayVideoTitle objectAtIndex:indexPath.row] durationTime:[_YTArrayVideoDuration objectAtIndex:indexPath.row] 
		 //OPTION1A: UNCOMMENT IF YOU WANT TO USE THUMBNAIL IMAGE PATH
		 //description:[_YTArrayVideoDescription objectAtIndex:indexPath.row] imagePath:[_YTArrayVideoThumbnailImageURL objectAtIndex:indexPath.row]];
		 //OPTION1B: UNCOMMENT IF YOU WANT TO USE FLASHVIDEO PLAYER PATH AS THUMBNAIL IMAGE
	description:[_YTArrayVideoDescription objectAtIndex:indexPath.row] imagePath:videoPath rating:[_YTArrayVideoRating objectAtIndex:indexPath.row] viewCount:[_YTArrayVideoViewCount objectAtIndex:indexPath.row]];	
    }
    
	//Cell preloading
	//cell.imageView.image = [UIImage imageNamed:@"video icon.jpg"];
	//cell.textLabel.text = @"Main Text";
	//cell.detailTextLabel.text = @"Subtitle text";
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//Get the row selected

	//NSLog(@"didSelectRowAtIndexPath was tapped = %@", [_YTArrayVideoFlashURL objectAtIndex:indexPath.row]);
	
		WebViewController *wv = [[WebViewController alloc] init];
		wv.passedURL = [_YTArrayVideoFlashURL objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:wv animated:YES];
		/*
		 NSLog(@"didSelectRowAtIndexPath was tapped = %@", _YTArrayVideoTitle);
		 NSURL *fileURL = nil;
		 fileURL = [self movieURL:@"blowUp1"];
		 [self initMoviePlayer:fileURL];
		 */
	

	
	//NSURL *fileURL = [NSURL fileURLWithPath:_GLOBALVideoFlashURLs isDirectory:NO];
	//MPMoviePlayerController *yourMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL: fileURL];
	//[yourMoviePlayer play];
	//NSURL *urlFile = [self movieURL:_GLOBALVideoFlashURLs];
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





@end

