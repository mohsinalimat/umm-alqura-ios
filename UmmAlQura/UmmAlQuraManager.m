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

// return if location is on or off


// the next function sould be run eveytime user update notofication for any priyres
// or update sound type or in backround opining or when user clic on notivation
- (void)scheduleNotifications {
    _ummAlQuraUtilities = [[UmmAlQuraUtilities alloc] init];
    // setup next pryerses notification
    // get priyers for next week based on what user are enabled
    NSMutableArray *upcomingPrayers = [[NSMutableArray alloc] init];
    
    for (int day = 0; day < 7; day++) {
        //get prayers for today + day and add it to upcomingPrayers
        NSMutableDictionary *oneDayPrayersDictionary = [[NSMutableDictionary alloc] init];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:day];
        NSDate *date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        NSArray *oneDayPrayersArray = [_ummAlQuraUtilities calculateEventsTimeForCoordinateLatitude:_locationManager.location.coordinate.latitude
                                                                                     longitude:_locationManager.location.coordinate.longitude
                                                                                          date:date
                                                                                      timeZone:[_currentLocationTimeZone doubleValue]
                                                                                 andTimeFormat:_ummAlQuraUtilities.prayTime.Time24];
        // adding info to dict then adding it to array
        [oneDayPrayersDictionary setObject:date forKey:@"Date"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:0] forKey:@"Fajr"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:1] forKey:@"Sunrise"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:2] forKey:@"Dhuhr"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:3] forKey:@"Asr"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:4] forKey:@"Maghrib"];
        [oneDayPrayersDictionary setObject:[oneDayPrayersArray objectAtIndex:5] forKey:@"Isha"];
        [upcomingPrayers addObject:oneDayPrayersDictionary];
        
    }
    
    NSLog(@"this is the upcommitng pryers: %@", upcomingPrayers);
    
    
    // remove all notification
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    // loop and add new notification based on sound
    // send info to adding funcation in utilities class
    for (int i = 0; i < [upcomingPrayers count]; i++) {
        
    }
    
}
@end
