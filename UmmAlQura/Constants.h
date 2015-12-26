#import <Foundation/Foundation.h>

@interface Constants : NSObject
extern NSString *const kYes;
extern NSString *const kNo;

// Location
extern NSString *const kIsUsingCurrentLocation;	// Yes or No
extern NSString *const kCurrentLocationName;
extern NSString *const kCurrentLocationLatitude;
extern NSString *const kCurrentLocationLongitude;

// Notification settings
// 1 = off
// 2 = vibration
// 3 = active
extern NSString *const kNotificationFajr;
extern NSString *const kNotificationSunrise;
extern NSString *const kNotificationDhuhr;
extern NSString *const kNotificationAsr;
extern NSString *const kNotificationMaghrib;
extern NSString *const kNotificationIsha;

@end
