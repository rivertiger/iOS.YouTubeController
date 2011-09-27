/*

 //  YouTubeProject
 //
 //  Created by James Nguyen on 10/10/09.
 //

*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WebViewController : UIViewController <UITextFieldDelegate, UIWebViewDelegate,UIAlertViewDelegate>
{
	AVAudioPlayer *player;
	UIWebView	*myWebView;
	UITextField *urlField;
	UIActivityIndicatorView *activityIndicator;
	UIActivityIndicatorView *activityView;
	UIAlertView *progressAlert;
	NSString *passedURL;
}
@property (retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSString *passedURL;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIAlertView *progressAlert;
- (void) createProgressionAlertWithMessage:(NSString *)message withActivity:(BOOL)activity;
@end
