#import "AppDelegate.h"
#import "AppConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Print all NSUserDefaults for the app
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    _ummAlQuraManager = [UmmAlQuraManager sharedManager];
    [_ummAlQuraManager setupApp];
	return YES;
}

@end
