#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface UmmAlQuraVC : UIViewController <CLLocationManagerDelegate>

// Date Hijri
@property (weak, nonatomic) IBOutlet UILabel	*dayHijri;
@property (weak, nonatomic) IBOutlet UILabel	*monthHijri;

// Date Gregorian
@property (weak, nonatomic) IBOutlet UILabel	*dayGregorian;
@property (weak, nonatomic) IBOutlet UILabel	*monthGregorian;

// Location
@property (weak, nonatomic) IBOutlet UILabel	*currentLocation;

// Current Event
@property (weak, nonatomic) IBOutlet UILabel	*currentEventName;
@property (weak, nonatomic) IBOutlet UILabel	*currentEventSubtext;
@property (weak, nonatomic) IBOutlet UILabel	*currentEventTime;

// Fajr
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventFajrNotification;

// Sunrise
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventSunriseNotification;

// Dhuhr
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventDhuhrNotification;

// Asr
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventAsrNotification;

// Maghrib
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventMaghribNotification;

// Isha
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaTime;
@property (weak, nonatomic) IBOutlet UIButton	*eventIshaNotification;

//Quote
@property (weak, nonatomic) IBOutlet UILabel	*quote;

@end

