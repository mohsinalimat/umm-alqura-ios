#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface UmmAlQuraManager : NSObject

//// Constants
// Location
extern NSString *const kIsUsingCurrentLocation;	// Yes or No
extern NSString *const kCurrentLocationName;
extern NSString *const kCurrentLocationLatitude;
extern NSString *const kCurrentLocationLongitude;
extern NSString *const kCurrentLocationTimeZone;
extern NSString *const kIsDontAllwoLocationNotified;

// Notification settings
extern NSString *const kNotificationFajr;
extern NSString *const kNotificationSunrise;
extern NSString *const kNotificationDhuhr;
extern NSString *const kNotificationAsr;
extern NSString *const kNotificationMaghrib;
extern NSString *const kNotificationIsha;

extern NSString *const kOff;
extern NSString *const kImageOff;
extern NSString *const kVibration;
extern NSString *const kImageVibration;
extern NSString *const kActive;
extern NSString *const kImageActive;


//// Objs and Vars
@property (strong, nonatomic) CLLocationManager *locationManager;

// Date Hijri
@property (strong, nonatomic) NSString	*dayHijri;
@property (strong, nonatomic) NSString	*monthHijri;

// Date Gregorian
@property (strong, nonatomic) NSString	*dayGregorian;
@property (strong, nonatomic) NSString	*monthGregorian;

// Location
@property (strong, nonatomic) NSString *currentLocationName;
@property (strong, nonatomic) NSNumber *currentLocationTimeZone;

//// Functions
+ (UmmAlQuraManager*)sharedManager;
- (void)setupApp;
@end
