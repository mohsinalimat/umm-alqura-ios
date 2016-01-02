#import <QuartzCore/QuartzCore.h>
#import "PrayTime.h"
#import "UmmAlQuraVC.h"
#import "Constants.h"
#import "LocalizationSystem.h"
#import "UmmAlQuraManager.h"

@interface UmmAlQuraVC ()
@property (strong, nonatomic) UmmAlQuraManager *ummAlQuraManager;
@end

@implementation UmmAlQuraVC



#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _ummAlQuraManager = [UmmAlQuraManager  sharedManager];
    LocalizationSetLanguage(@"en");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	[self setupDate];
	[self setupLocation];
	[self setupEvents];
}



- (void)setupDate {
	// Gregorian
	_dayGregorian.text      = [_ummAlQuraManager dayGregorian];
	_monthGregorian.text    = [_ummAlQuraManager monthGregorian];
	
	// Hijri
	_dayHijri.text      = [_ummAlQuraManager dayHijri];
	_monthHijri.text    = [_ummAlQuraManager monthHijri];
}

- (void)setupLocation {
	
	
}


- (void)setupEvents {
//    PrayTime *prayerTime = [[PrayTime alloc] initWithJuristic:JuristicMethodShafii
//                                               andCalculation:CalculationMethodMakkah];
//    NSMutableArray *prayerTimes = [prayerTime prayerTimesDate:[NSDate date]
//                                                     latitude:locationManager.location.coordinate.latitude
//                                                    longitude:locationManager.location.coordinate.longitude
//                                                  andTimezone:[prayerTime getTimeZone]];
//    
//    
//    _eventFajrTitle.text    = NSLocalizedString(@"Event_Fajr", nil);
//    _eventFajrTime.text     = [prayerTimes objectAtIndex:0];
//    _eventSunriseTitle.text = NSLocalizedString(@"Event_Sunrise", nil);
//    _eventSunriseTime.text  = [prayerTimes objectAtIndex:1];
//    _eventDhuhrTitle.text   = NSLocalizedString(@"Event_Dhuhr", nil);
//    _eventDhuhrTime.text    = [prayerTimes objectAtIndex:2];
//    _eventAsrTitle.text     = NSLocalizedString(@"Event_Asr", nil);
//    _eventAsrTime.text      = [prayerTimes objectAtIndex:3];
//    _eventMaghribTitle.text = NSLocalizedString(@"Event_Maghrib", nil);
//    _eventMaghribTime.text  = [prayerTimes objectAtIndex:4];
//    _eventIshaTitle.text    = NSLocalizedString(@"Event_Isha", nil);
//    _eventIshaTime.text     = [prayerTimes objectAtIndex:6];
}



- (IBAction)switchNotefcation:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    NSLog(@"%@", resultButton.currentImage);
	NSLog(@"sender %@", sender);
    
    if (resultButton.tag == 3) {
        [resultButton setImage:[UIImage imageNamed:@"vibration"] forState:UIControlStateNormal];
        [resultButton setTag:2];
    } else if (resultButton.tag == 2) {
        [resultButton setImage:[UIImage imageNamed:@"notifications_off"] forState:UIControlStateNormal];
        [resultButton setTag:1];
    } else if (resultButton.tag == 1) {
        [resultButton setImage:[UIImage imageNamed:@"notifications_active"] forState:UIControlStateNormal];
        [resultButton setTag:3];
    } else {
        [resultButton setImage:[UIImage imageNamed:@"notifications_off"] forState:UIControlStateNormal];
        [resultButton setTag:1];
    }

}

- (IBAction)changeFajrNotification {
    exit(0);
}

- (IBAction)changeSunriseNotification {
}

- (IBAction)changeDhuhrNotification {
}

- (IBAction)changeAsrNotification {
}

- (IBAction)changeMaghribNotification {
}

- (IBAction)changeIshaNotification {
}
@end
