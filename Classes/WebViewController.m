/*
 //  YouTubeProject
 //
 //  Created by James Nguyen on 10/10/09.
 //
*/

#import "WebViewController.h"

// padding for margins
#define kLeftMargin				20.0
#define kTopMargin				15.0
#define kRightMargin			20.0
#define kBottomMargin			15.0
#define kTweenMargin			5.0
#define kTextFieldHeight		25.0

@implementation WebViewController
@synthesize passedURL;
@synthesize activityView;
@synthesize progressAlert;
@synthesize player;

- (id)init
{
	self = [super init];
	if (self)
	{
		// this title will appear in the navigation bar
		self.title = NSLocalizedString(@"Web Results", @"");
	}
	return self;
}

- (void)dealloc
{
	[player release];
	[myWebView release];
	[activityView release];
	[progressAlert release];
	[urlField release];
	[passedURL release];
	[super dealloc];
}


-(void)PlayCorrectSound 
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ding" ofType:@"mp3"];
	// Initialize the player
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
	
	if (!self.player)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
	}
	// Prepare the player and set the loops to, basically, unlimited
	[self.player prepareToPlay];
	NSFileHandle *bodyf = [NSFileHandle fileHandleForReadingAtPath:path];
	NSData *body = [bodyf availableData];
	NSLog( @"length of play.caf %d",[body length] );
	NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
	NSLog(@"%@", url);
	//NSLog( @"%d", AudioServicesCreateSystemSoundID((CFURLRef)url, &soundID) );
	// Start playing at no-volume
	self.player.volume = 0.5f;
	[self.player play];		
}

- (void) createProgressionAlertWithMessage:(NSString *)message withActivity:(BOOL)activity
{
	/*
	 progressAlert = [[UIAlertView alloc] initWithTitle: message
	 message: @"Please wait..."
	 delegate: self
	 cancelButtonTitle: nil
	 otherButtonTitles: nil];
	 */
	
	
	// Create the progress bar and add it to the alert
	if (activity) {
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake(140.0f, 100.0f, 37.0f, 37.0f);
		//[self.view addSubview:activityView];
		//[activityView startAnimating];
	} else {
		UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
		[self.view addSubview:progressView];
		[progressView setProgressViewStyle: UIProgressViewStyleBar];
	}
	//[progressAlert show];
	//[progressAlert release];
}


- (void)loadView
{
	
	}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self PlayCorrectSound];
	// the base view for this view controller
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor grayColor];
	
	
	// important for view orientation rotation
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);	
	
	self.view = contentView;
	
	[contentView release];
	
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	//webFrame.origin.y += kTopMargin + 5.0;	// leave from the URL input field and its label
	//webFrame.size.height -= 35.0;
	myWebView = [[UIWebView alloc] initWithFrame:webFrame];
	myWebView.backgroundColor = [UIColor grayColor];
	myWebView.scalesPageToFit = YES;
	myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	myWebView.delegate = self;
	[self.view addSubview: myWebView];
	
	//Custom UIWebView
	NSMutableString *htmlString = [[NSMutableString alloc] initWithCapacity:200]; 
	[htmlString appendString:
	 @"<html><head>"
	 "<meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = 212\"/></head>"
	 "<body style=\"background:#F00;margin-top:0px;margin-left:0px\">"
	 "<div><object width=\"90\" height=\"120\">"
	 "<param name=\"movie\" value=\""];
	[htmlString appendString:passedURL];
	//[htmlString appendString:@"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\""];
	[htmlString appendString:@"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\""];
	[htmlString appendString:passedURL];
	//[htmlString appendString:@"http://www.youtube.com/v/oHg5SJYRHA0&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\""];
	[htmlString appendString:@" \"type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"212\" height=\"172\"></embed>"
	 "</object></div></body></html>"];
	//[htmlContents appendString: telnumber];
		
	[myWebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:@"http://www.your-url.com"]];
	
	
	
	
	/* UNCOMMENT TO DISPLAY URLFIELD
	CGRect textFieldFrame = CGRectMake(kLeftMargin, kTweenMargin, self.view.bounds.size.width - (kLeftMargin * 2.0), kTextFieldHeight);
	urlField = [[UITextField alloc] initWithFrame:textFieldFrame];
    urlField.borderStyle = UITextBorderStyleBezel;
    urlField.textColor = [UIColor blackColor];
    urlField.delegate = self;
    urlField.placeholder = @"<enter a URL>";
	NSString *headerString = @"";
	passedURL = [headerString stringByAppendingString:passedURL];
	[headerString release];
	passedURL = [passedURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSLog(@"passedURL was called %@", passedURL);
	urlField.text = passedURL;
    urlField.text = @"http://www.apple.com";*/
	/*
	urlField.backgroundColor = [UIColor whiteColor];
	urlField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	urlField.returnKeyType = UIReturnKeyGo;
	urlField.keyboardType = UIKeyboardTypeURL;	// this makes the keyboard more friendly for typing URLs
	urlField.autocorrectionType = UITextAutocorrectionTypeNo;	// we don't like autocompletion while typing
	urlField.clearButtonMode = UITextFieldViewModeAlways;
	
	[self.view addSubview:urlField];
	*/
	//[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:passedURL]]];
	//[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://iphonewebtown.com:1935/live/radio/playlist.m3u8"]]];
	
	[self createProgressionAlertWithMessage:@"Website Loading" withActivity:TRUE];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// we support rotation in this view controller
	return YES;
}

// this helps dismiss the keyboard when the "Done" button is clicked
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[textField text]]]];
	
	return YES;
}


#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)wv {
    //NSLog (@"webViewDidStartLoad");
   [activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
    //NSLog (@"webViewDidFinishLoad");
	
    [activityView stopAnimating];
	activityView.hidesWhenStopped = YES;

}

- (void)webView:(UIWebView *)wv didFailLoadWithError:(NSError *)error {
    //NSLog (@"webView:didFailLoadWithError");
    //[activityIndicator stopAnimating];
    if (error != NULL) {
        UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle: [error localizedDescription]
								   message: [error localizedFailureReason]
								   delegate:nil
								   cancelButtonTitle:@"OK" 
								   otherButtonTitles:nil];
        [errorAlert show];
        [errorAlert release];
		
		/*
		// report the error inside the webview
		NSString* errorString = [NSString stringWithFormat:
								 @"<html><center><font size=+5 color='red'>An error occurred. Please make sure that you are connected to the internet. Error code:<br>%@</font></center></html>",
								 error.localizedDescription];
		[myWebView loadHTMLString:errorString baseURL:nil];
		 */
    }
}

@end

