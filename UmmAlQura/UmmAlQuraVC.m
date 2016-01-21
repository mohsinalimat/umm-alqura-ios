#import <QuartzCore/QuartzCore.h>
#import "PrayTime.h"
#import "UmmAlQuraVC.h"
#import "AppConstants.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"

@interface UmmAlQuraVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@property (strong, nonatomic) NSArray               *eventsTimeArray;
@property (strong, nonatomic) NSTimer               *nextEventTimer;
@property NSInteger secondsToNextEvent;
@end

@implementation UmmAlQuraVC



#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _ummAlQuraManager       = [UmmAlQuraManager  sharedManager];
    _ummAlQuraUtilities     = [[UmmAlQuraUtilities alloc] init];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setupLocation];
    [self setupDate];
	[self setupEvents];
    [self setupNotification];
    [self setupNextEvent];
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
    NSInteger dayGregorian      = [[_date objectForKey:kDayGregorian] integerValue];
    NSInteger monthGregorian    = [[_date objectForKey:kMonthGregorian] integerValue];
    _dayGregorian.text      = [_ummAlQuraUtilities localizeDay:dayGregorian];
    _monthGregorian.text    = [_ummAlQuraUtilities localizeGregorianMonth:monthGregorian];

    // Hijri
    NSInteger dayHijri      = [[_date objectForKey:kDayHijri] integerValue];
    NSInteger monthHijri    = [[_date objectForKey:kMonthHijri] integerValue];
    _dayHijri.text      = [_ummAlQuraUtilities localizeDay:dayHijri];
    _monthHijri.text    = [_ummAlQuraUtilities localizeHijriMonth:monthHijri];
}


- (void)setupEvents {
    _eventsTimeArray = [[NSArray alloc] init];

    _eventsTimeArray = [_ummAlQuraUtilities calculateEventsTimeForCoordinateLatitude:_ummAlQuraManager.locationManager.location.coordinate.latitude
                                                                           longitude:_ummAlQuraManager.locationManager.location.coordinate.longitude
                                                                                date:[NSDate date]
                                                                            timeZone:[_ummAlQuraManager.currentLocationTimeZone doubleValue]
                                                                       andTimeFormat:_ummAlQuraUtilities.prayTime.Time12];

    // try catch
    _eventFajrTitle.text    = NSLocalizedString(@"EVENT_FAJR", nil);
    _eventFajrTime.text     = [_eventsTimeArray objectAtIndex:0];
    _eventSunriseTitle.text = NSLocalizedString(@"EVENT_SUNRISE", nil);
    _eventSunriseTime.text  = [_eventsTimeArray objectAtIndex:1];
    _eventDhuhrTitle.text   = NSLocalizedString(@"EVENT_DHUHR", nil);
    _eventDhuhrTime.text    = [_eventsTimeArray objectAtIndex:2];
    _eventAsrTitle.text     = NSLocalizedString(@"EVENT_ASR", nil);
    _eventAsrTime.text      = [_eventsTimeArray objectAtIndex:3];
    _eventMaghribTitle.text = NSLocalizedString(@"EVENT_MAGHRIB", nil);
    _eventMaghribTime.text  = [_eventsTimeArray objectAtIndex:4];
    _eventIshaTitle.text    = NSLocalizedString(@"EVENT_ISHA", nil);
    _eventIshaTime.text     = [_eventsTimeArray objectAtIndex:5];
    
    NSLog(@"date: %@", [NSDate date]);
    NSLog(@"timezone: %f", [_ummAlQuraManager.currentLocationTimeZone doubleValue]);
    NSLog(@"Latitude: %f", _ummAlQuraManager.locationManager.location.coordinate.latitude);
    NSLog(@"longitude: %f", _ummAlQuraManager.locationManager.location.coordinate.longitude);
    NSLog(@"events: %@", _eventsTimeArray);
}


- (void)setupNotification {
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationFajr]       forEvent:_eventFajrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationSunrise]    forEvent:_eventSunriseNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationDhuhr]      forEvent:_eventDhuhrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationAsr]        forEvent:_eventAsrNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationMaghrib]    forEvent:_eventMaghribNotification];
    [self setNotefcationStatus:[[NSUserDefaults standardUserDefaults] objectForKey:kNotificationIsha]       forEvent:_eventIshaNotification];
}


- (void)setupNextEvent {
    _currentEventSubtext.text = NSLocalizedString(@"NEXT_EVENT_SUB_TEXT", nil);
    [self retrieveNextEvent];
    _nextEventTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownNextEvent) userInfo:nil repeats:YES];
}

- (void)retrieveNextEvent {
    NSDictionary *nextEvent = [_ummAlQuraUtilities calculateNextEventForCoordinateLatitude:_ummAlQuraManager.locationManager.location.coordinate.latitude
                                                                              andLongitude:_ummAlQuraManager.locationManager.location.coordinate.longitude
                                                                               andTimeZone:[_ummAlQuraManager.currentLocationTimeZone doubleValue]];
    NSInteger nextEventId = [[nextEvent objectForKey:kNextEventId] integerValue];
    _currentEventName.text = [_ummAlQuraUtilities localizeNextEvent:nextEventId];
    _secondsToNextEvent = 0;
    
    if ([[nextEvent objectForKey:kNextEventIsToday] isEqualToString:kYes]) {
        _secondsToNextEvent = [_ummAlQuraUtilities calculateSecondsLeftToNextEventOnHour:[[nextEvent objectForKey:kNextEventHour] integerValue]
                                                                                  minute:[[nextEvent objectForKey:kNextEventMinute] integerValue]
                                                                                timeZone:[_ummAlQuraManager.currentLocationTimeZone doubleValue]
                                                                  andWithEventBeingToday:YES];
    } else {
        _secondsToNextEvent = [_ummAlQuraUtilities calculateSecondsLeftToNextEventOnHour:[[nextEvent objectForKey:kNextEventHour] integerValue]
                                                                                  minute:[[nextEvent objectForKey:kNextEventMinute] integerValue]
                                                                                timeZone:[_ummAlQuraManager.currentLocationTimeZone doubleValue]
                                                                  andWithEventBeingToday:NO];
    }
    
}

- (void)countDownNextEvent {
    _secondsToNextEvent--;
    
    if (_secondsToNextEvent == 0) {
        [self retrieveNextEvent];
    } else {
        [self updateNextEventTimerForRemainingSeconds];
    }

    //NSLog(@"counting down: %ld", (long)_secondsToNextEvent);
}

- (void)updateNextEventTimerForRemainingSeconds {
    NSArray *remainingTime = [_ummAlQuraUtilities retriveveNextEventRemainingTimeForSeconds:_secondsToNextEvent];
    _currentEventTime.text = [NSString stringWithFormat:@"%@:%@:%@", [remainingTime objectAtIndex:0], [remainingTime objectAtIndex:1], [remainingTime objectAtIndex:2]];
    //NSLog(@"Remaining time dict: %@", remainingTime);
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
        
        // we should check the location here if there is no text show the coordinat
        _currentLocation.text = [NSString stringWithFormat:@"%@, %@, %@", placemark.name, placemark.locality, placemark.country];
        _ummAlQuraManager.currentLocationTimeZone = [NSNumber numberWithDouble:placemark.timeZone.secondsFromGMT/3600.0f];
        [[NSUserDefaults standardUserDefaults] setObject:_currentLocation.text forKey:kCurrentLocationName];
        [[NSUserDefaults standardUserDefaults] setObject:_ummAlQuraManager.currentLocationTimeZone forKey:kCurrentLocationTimeZone];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Setup the event after getting the new location
        [self setupEvents];
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


#pragma mark- Buttons
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
