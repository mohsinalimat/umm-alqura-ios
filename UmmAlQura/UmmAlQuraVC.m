#import <QuartzCore/QuartzCore.h>
#import "PrayTime.h"
#import "UmmAlQuraVC.h"
#import "AppConstants.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"

@interface UmmAlQuraVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@end

@implementation UmmAlQuraVC



#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _ummAlQuraManager   = [UmmAlQuraManager  sharedManager];
    _ummAlQuraUtilities = [[UmmAlQuraUtilities alloc] init];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setupLocation];
    [self setupDate];
	[self setupEvents];
    [self setupNotification];
}


#pragma mark- Methods
- (void)setupLocation {
    _currentLocation.text = _ummAlQuraManager.currentLocationName;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
        // locationServicesEnabled we sholud check before asking
        _ummAlQuraManager.locationManager = [[CLLocationManager alloc] init];
        _ummAlQuraManager.locationManager.delegate = self;
        [_ummAlQuraManager.locationManager requestWhenInUseAuthorization];
        
    } // else check if there is a selected city with it's coordnates
    
}


- (void)setupDate {
	NSDictionary *_date = [_ummAlQuraUtilities retrieveCurrentDate];

    // Gregorian
	_dayGregorian.text      = [_date objectForKey:kDayGregorian];
	_monthGregorian.text    = [_date objectForKey:kMonthGregorian];
	
	// Hijri
	_dayHijri.text      = [_date objectForKey:kDayHijri];
	_monthHijri.text    = [_date objectForKey:kMonthHijri];
}


- (void)setupEvents {
    PrayTime *prayerTime = [[PrayTime alloc] initWithJuristic:JuristicMethodShafii
                                               andCalculation:CalculationMethodMakkah];
    NSMutableArray *prayerTimes = [prayerTime prayerTimesDate:[NSDate date]
                                                     latitude:_ummAlQuraManager.locationManager.location.coordinate.latitude
                                                    longitude:_ummAlQuraManager.locationManager.location.coordinate.longitude
                                                  andTimezone:[prayerTime getTimeZone]];
    
    
    _eventFajrTitle.text    = NSLocalizedString(@"Event_Fajr", nil);
    _eventFajrTime.text     = [prayerTimes objectAtIndex:0];
    _eventSunriseTitle.text = NSLocalizedString(@"Event_Sunrise", nil);
    _eventSunriseTime.text  = [prayerTimes objectAtIndex:1];
    _eventDhuhrTitle.text   = NSLocalizedString(@"Event_Dhuhr", nil);
    _eventDhuhrTime.text    = [prayerTimes objectAtIndex:2];
    _eventAsrTitle.text     = NSLocalizedString(@"Event_Asr", nil);
    _eventAsrTime.text      = [prayerTimes objectAtIndex:3];
    _eventMaghribTitle.text = NSLocalizedString(@"Event_Maghrib", nil);
    _eventMaghribTime.text  = [prayerTimes objectAtIndex:4];
    _eventIshaTitle.text    = NSLocalizedString(@"Event_Isha", nil);
    _eventIshaTime.text     = [prayerTimes objectAtIndex:6];
}


- (void)setupNotification {
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationFajr]       forEvent:_eventFajrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationSunrise]    forEvent:_eventSunriseNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationDhuhr]      forEvent:_eventDhuhrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationAsr]        forEvent:_eventAsrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationMaghrib]    forEvent:_eventMaghribNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationIsha]       forEvent:_eventIshaNotification];
}

- (void)retrieveDeviceLocation {
    _ummAlQuraManager.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _ummAlQuraManager.locationManager.distanceFilter = kCLDistanceFilterNone;
    [_ummAlQuraManager.locationManager startUpdatingLocation];
    
    
    //get current location
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:_ummAlQuraManager.locationManager.location.coordinate.latitude longitude:_ummAlQuraManager.locationManager.location.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setDouble:_ummAlQuraManager.locationManager.location.coordinate.latitude forKey:kCurrentLocationLatitude];
    [[NSUserDefaults standardUserDefaults] setDouble:_ummAlQuraManager.locationManager.location.coordinate.longitude forKey:kCurrentLocationLongitude];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        _currentLocation.text = placemark.locality;
        [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:kCurrentLocationName];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];

}


#pragma mark- Location Manager (delegate)
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // Status 0 = not status, 2 = Don't Allow, 4 = Allow
    NSLog(@"the status: %d", status);
    
    if (status == 4) {
        NSLog(@"we have access to locatin");
        [self retrieveDeviceLocation];
    } else if (status == 2){
        NSLog(@"we dont have access to locatin");
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:kIsDontAllwoLocationNotified] isEqualToString:kYes]) {
            // show msg
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                           message:@"This is an alert."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"go to settings" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"select location" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            UIAlertAction* defaultAction3 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel
                                                                   handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [alert addAction:defaultAction2];
            [alert addAction:defaultAction3];
            [self presentViewController:alert animated:YES completion:nil];
            [[NSUserDefaults standardUserDefaults] setObject:kYes forKey:kIsDontAllwoLocationNotified];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        // ether 0 or somthing wroing happend
        // setup the location to makkah if not alreday
        NSLog(@"we 0");
    }
}


#pragma mark- Buttons
- (void)setNotefcationStatus:(NSString *)status forEvent:(UIButton *)event {
    
    if ([status isEqualToString:kVibration]) {
        [event setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [event setTag:2];
    } else if ([status isEqualToString:kOff]) {
        [event setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [event setTag:1];
    } else if ([status isEqualToString:kActive]) {
        [event setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [event setTag:3];
    } else {
        [event setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [event setTag:1];
    }

}

- (IBAction)changeFajrNotification {
    //exit(0);
    if (_eventFajrNotification.tag == 3) {
        [_eventFajrNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventFajrNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationFajr];
    } else if (_eventFajrNotification.tag == 2) {
        [_eventFajrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventFajrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationFajr];
    } else if (_eventFajrNotification.tag == 1) {
        [_eventFajrNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventFajrNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationFajr];
    } else {
        [_eventFajrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventFajrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationFajr];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeSunriseNotification {
    
    if (_eventSunriseNotification.tag == 3) {
        [_eventSunriseNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventSunriseNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationSunrise];
    } else if (_eventSunriseNotification.tag == 2) {
        [_eventSunriseNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventSunriseNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationSunrise];
    } else if (_eventSunriseNotification.tag == 1) {
        [_eventSunriseNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventSunriseNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationSunrise];
    } else {
        [_eventSunriseNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventSunriseNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationSunrise];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeDhuhrNotification {
    
    if (_eventDhuhrNotification.tag == 3) {
        [_eventDhuhrNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventDhuhrNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationDhuhr];
    } else if (_eventDhuhrNotification.tag == 2) {
        [_eventDhuhrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventDhuhrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationDhuhr];
    } else if (_eventDhuhrNotification.tag == 1) {
        [_eventDhuhrNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventDhuhrNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationDhuhr];
    } else {
        [_eventDhuhrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventDhuhrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationDhuhr];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeAsrNotification {
    
    if (_eventAsrNotification.tag == 3) {
        [_eventAsrNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventAsrNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationAsr];
    } else if (_eventAsrNotification.tag == 2) {
        [_eventAsrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventAsrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationAsr];
    } else if (_eventAsrNotification.tag == 1) {
        [_eventAsrNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventAsrNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationAsr];
    } else {
        [_eventAsrNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventAsrNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationAsr];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeMaghribNotification {
    
    if (_eventMaghribNotification.tag == 3) {
        [_eventMaghribNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventMaghribNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationMaghrib];
    } else if (_eventMaghribNotification.tag == 2) {
        [_eventMaghribNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventMaghribNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationMaghrib];
    } else if (_eventMaghribNotification.tag == 1) {
        [_eventMaghribNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventMaghribNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationMaghrib];
    } else {
        [_eventMaghribNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventMaghribNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationMaghrib];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)changeIshaNotification {
    
    if (_eventIshaNotification.tag == 3) {
        [_eventIshaNotification setImage:[UIImage imageNamed:kImageVibration] forState:UIControlStateNormal];
        [_eventIshaNotification setTag:2];
        [[NSUserDefaults standardUserDefaults] setObject:kVibration forKey:kNotificationIsha];
    } else if (_eventIshaNotification.tag == 2) {
        [_eventIshaNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventIshaNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationIsha];
    } else if (_eventIshaNotification.tag == 1) {
        [_eventIshaNotification setImage:[UIImage imageNamed:kImageActive] forState:UIControlStateNormal];
        [_eventIshaNotification setTag:3];
        [[NSUserDefaults standardUserDefaults] setObject:kActive forKey:kNotificationIsha];
    } else {
        [_eventIshaNotification setImage:[UIImage imageNamed:kImageOff] forState:UIControlStateNormal];
        [_eventIshaNotification setTag:1];
        [[NSUserDefaults standardUserDefaults] setObject:kOff forKey:kNotificationIsha];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
