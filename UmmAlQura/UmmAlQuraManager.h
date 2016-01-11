#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface UmmAlQuraManager : NSObject

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

// Date
extern NSString *const kDayHijri;
extern NSString *const kMonthHijri;
extern NSString *const kDayGregorian;
extern NSString *const kMonthGregorian;

@property (strong, nonatomic) CLLocationManager *locationManager;

// Date Hijri
@property (strong, nonatomic) NSString	*dayHijri;
@property (strong, nonatomic) NSString	*monthHijri;

// Date Gregorian
@property (strong, nonatomic) NSString	*dayGregorian;
@property (strong, nonatomic) NSString	*monthGregorian;

+ (UmmAlQuraManager*)sharedManager;
- (void)setupApp;
- (NSDictionary *)retrieveLocationCoordinate;
- (NSDictionary *)retrieveCurrentDate;
- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude andLongitude:(double)longitude;
@end
