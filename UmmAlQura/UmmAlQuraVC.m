#import <QuartzCore/QuartzCore.h>
#import "PrayTime.h"
#import "UmmAlQuraVC.h"
#import "AppConstants.h"
#import "UmmAlQuraManager.h"

@interface UmmAlQuraVC ()
@property (strong, nonatomic) UmmAlQuraManager *ummAlQuraManager;
@end

@implementation UmmAlQuraVC



#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _ummAlQuraManager = [UmmAlQuraManager  sharedManager];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
        _ummAlQuraManager.locationManager.delegate = self;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setupLocation];
    [self setupDate];
	[self setupEvents];
}

- (void)setupLocation {
    //[_ummAlQuraManager setupLocation];
}


- (void)setupDate {
	NSDictionary *_date = [_ummAlQuraManager retrieveCurrentDate];

    // Gregorian
	_dayGregorian.text      = [_date objectForKey:kDayGregorian];
	_monthGregorian.text    = [_date objectForKey:kMonthGregorian];
	
	// Hijri
	_dayHijri.text      = [_date objectForKey:kDayHijri];
	_monthHijri.text    = [_date objectForKey:kMonthHijri];
}




- (void)setupEvents {
    //[_ummAlQuraManager setupEvents];
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
