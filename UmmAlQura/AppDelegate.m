#import "AppDelegate.h"
#import "Constants.h"
#import "LocalizationSystem.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// if the object for the "kIsUsingCurrentLocation" not setup that mean this is the first time
	// the application launches, so setup the init settings.
	if (![[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation]) {
		[self initSettings];
	}
    
    _ummAlQuraManager = [UmmAlQuraManager sharedManager];
    [_ummAlQuraManager setupLocation];
    [_ummAlQuraManager setupDate];
	return YES;
}

- (void)initSettings {
	[[NSUserDefaults standardUserDefaults] setObject:kYes forKey:kIsUsingCurrentLocation];
    
    // setup languge based on the device languge
    //LocalizationSetLanguage(@"ar");
    
    
    
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
