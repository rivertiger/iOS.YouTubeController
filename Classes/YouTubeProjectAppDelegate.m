//
//  YouTubeProjectAppDelegate.m
//  YouTubeProject
//
//  Created by James Nguyen on 10/10/09.
//

#import "YouTubeProjectAppDelegate.h"
#import "YouTubeProjectViewController.h"
#import "YouTubeTableViewController.h"

@implementation YouTubeProjectAppDelegate
@synthesize nav;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.nav = [[UINavigationController alloc] initWithRootViewController:[[YouTubeTableViewController alloc] init]];
	[window addSubview:self.nav.view];
	[window makeKeyAndVisible];

}


- (void)dealloc {
		[self.nav release];
    [super dealloc];
}


@end
