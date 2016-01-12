#import "UmmAlQuraManager.h"
#import "AppConstants.h"
#import "PrayTime.h"

@implementation UmmAlQuraManager

// Location
NSString *const kIsUsingCurrentLocation         = @"IS_USING_CURRENT_LOCATION";	// Yes or No
NSString *const kCurrentLocationName            = @"CURRENT_LOCATION_NAME";
NSString *const kCurrentLocationLatitude        = @"CURRENT_LOCATION_LATITUDE";
NSString *const kCurrentLocationLongitude       = @"CURRENT_LOCATION_LONGITUDE";
NSString *const kCurrentLocationTimeZone        = @"CURRENT_LOCATION_TIME_ZONE";
NSString *const kIsDontAllwoLocationNotified    = @"IS_DONT_ALLWO_LOCATION_NOTIFIED";

// Notification settings
NSString *const kNotificationFajr		= @"NOTIFICATION_FAJR";
NSString *const kNotificationSunrise	= @"NOTIFICATION_SUNRISE";
NSString *const kNotificationDhuhr		= @"NOTIFICATION_DHUHR";
NSString *const kNotificationAsr		= @"NOTIFICATION_ASR";
NSString *const kNotificationMaghrib	= @"NOTIFICATION_MAGHRIB";
NSString *const kNotificationIsha		= @"NOTIFICATION_ISHA";

NSString *const kOff            = @"OFF";
NSString *const kImageOff       = @"notification_off";
NSString *const kVibration      = @"VIBRATION";
NSString *const kImageVibration = @"notification_vibration";
NSString *const kActive         = @"ACTIVE";
NSString *const kImageActive    = @"notification_active";


+ (UmmAlQuraManager*)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)setupApp {
    // if the object for the "kVersionCurrent" not setup that mean this is the first time
    // the application launches, so setup the init settings.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kVersionCurrent]) {
        [self initSettings];
    } else {
        _currentLocationName = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocationName];
        _currentLocationTimeZone = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocationTimeZone];
    }
    
}

- (void)makkahMode {
    // setup the app to makkah
}

- (void)initSettings {
    [[NSUserDefaults standardUserDefaults] setObject:kVersionApp forKey:kVersionCurrent];
    [[NSUserDefaults standardUserDefaults] setObject:kYes forKey:kIsUsingCurrentLocation];
    [[NSUserDefaults standardUserDefaults] setObject:kNo forKey:kIsDontAllwoLocationNotified];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:kAppLocale];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-US", @"en-US", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationFajr];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationSunrise];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationDhuhr];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationAsr];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationMaghrib];
    [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationIsha];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self makkahMode];
}

@end
