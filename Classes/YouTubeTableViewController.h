//
//  YouTubeTableViewController.h
//
//  Created by James Nguyen on 10/10/09.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface YouTubeTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate> {
	//YouTube IVARs
	NSString				*username;
	
	NSMutableArray			*_YTArrayVideoTitle;
	NSMutableArray			*_YTArrayVideoURL;
	NSMutableArray			*_YTArrayVideoDescription;
	NSMutableArray			*_YTArrayVideoViewCount;
	NSMutableArray			*_YTArrayVideoFlashURL;
	NSMutableArray			*_YTArrayVideoThumbnailImageURL;
	NSMutableArray			*_YTArrayVideoDuration;
	NSMutableArray			*_YTArrayVideoRating;
	
	MPMoviePlayerController *mMoviePlayer;
	NSURL					*mMovieURL;
	
}




-(void) queryYouTube;
-(NSURL*)movieURL:(NSString*)fileName;
-(void)initMoviePlayer:(NSURL*)movieURL;

@end
