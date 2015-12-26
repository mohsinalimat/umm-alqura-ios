#import <UIKit/UIKit.h>

@interface UmmAlQuraVC : UIViewController

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
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventFajrNotification;

// Sunrise
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventSunriseNotification;

// Dhuhr
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventDhuhrNotification;

// Asr
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventAsrNotification;

// Maghrib
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventMaghribNotification;

// Isha
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaRight;
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaLeft;
@property (weak, nonatomic) IBOutlet UIButton	*eventIshaNotification;

//Quote
@property (weak, nonatomic) IBOutlet UILabel	*quote;

@end

