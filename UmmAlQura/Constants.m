#import "Constants.h"

@implementation Constants
NSString *const kYes	= @"YES";
NSString *const kNo		= @"NO";

// Location
NSString *const kIsUsingCurrentLocation		= @"IS_USING_CURRENT_LOCATION";	// Yes or No
NSString *const kCurrentLocationName		= @"CURRENT_LOCATION_NAME";
NSString *const kCurrentLocationLatitude	= @"CURRENT_LOCATION_LATITUDE";
NSString *const kCurrentLocationLongitude	= @"CURRENT_LOCATION_LONGITUDE";

// Notification settings
// 1 = off
// 2 = vibration
// 3 = active
NSString* const kNotificationFajr		= @"NOTIFICATION_FAJR";
NSString* const kNotificationSunrise	= @"NOTIFICATION_SUNRISE";
NSString* const kNotificationDhuhr		= @"NOTIFICATION_DHUHR";
NSString* const kNotificationAsr		= @"NOTIFICATION_ASR";
NSString* const kNotificationMaghrib	= @"NOTIFICATION_MAGHRIB";
NSString* const kNotificationIsha		= @"NOTIFICATION_ISHA";

@end
