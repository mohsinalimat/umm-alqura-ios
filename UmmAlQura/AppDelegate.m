#import "AppDelegate.h"
#import "AppConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Print all NSUserDefaults for the app
    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"Headline" size:16.0], nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor clearColor]];
    
//    _ummAlQuraManager = [UmmAlQuraManager sharedManager];
//    [_ummAlQuraManager setupApp];
	return YES;
}

@end
