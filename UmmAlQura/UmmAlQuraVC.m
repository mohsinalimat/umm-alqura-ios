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
}


#pragma mark- Methods
- (void)setupLocation {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
        NSLog(@"geeting the location");
        _ummAlQuraManager.locationManager = [[CLLocationManager alloc] init];
        _ummAlQuraManager.locationManager.delegate = self;
        [self requestLocationAuthorization];
        
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

- (void)requestLocationAuthorization {
    
    // getting current location if it not allwed show msg and get pryiers for makeh.
    [_ummAlQuraManager.locationManager requestWhenInUseAuthorization]; // we didn't select requestWhenInUseAuthorization bucuse if the user change location while the app close we still could notifie him
    [_ummAlQuraManager.locationManager startUpdatingLocation];
    
//    // to know it the user enable the locatin service
//    if ([_ummAlQuraManager.locationManager locationServicesEnabled]) {
//        NSLog(@"app locatin auth status: true");
//    } else {
//        NSLog(@"app locatin auth status: no");
//    }
//    
//    
//    _ummAlQuraManager.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//    _ummAlQuraManager.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    [_ummAlQuraManager.locationManager startUpdatingLocation];
//    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
//        //get current location
//        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//        CLLocation *location = [[CLLocation alloc]initWithLatitude:_ummAlQuraManager.locationManager.location.coordinate.latitude longitude:_ummAlQuraManager.locationManager.location.coordinate.longitude];
//        
//        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            
//            for (CLPlacemark *placemark in placemarks) {
//                NSLog(@"city: %@", [placemark locality]);
//            }
//            
//            //            CLPlacemark *placemark = [placemarks objectAtIndex:0];
//            //            //NSLog(@"placemark %@",placemark);
//            //            //String to hold address
//            //            //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
//            //            //NSLog(@"addressDictionary %@", placemark.addressDictionary);
//            //
//            //            //NSLog(@"placemark %@",placemark.region);
//            //            NSLog(@"placemark %@",placemark.country);  // Give Country Name
//            //            NSLog(@"placemark %@",placemark.locality); // Extract the city name
//            //            //NSLog(@"location %@",placemark.administrativeArea);
//            //            //NSLog(@"location %@",placemark.ocean);
//            //            //NSLog(@"location %@",placemark.postalCode);
//            //            //NSLog(@"location %@",placemark.subLocality);
//            //
//            //            //NSLog(@"location %@",placemark.location);
//            //            //Print the location to console
//            //            //NSLog(@"I am currently at %@",locatedAt);
//            
//        }
//         ];
//        
//    }
    
}


#pragma mark- Location Manager (delegate)
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // Status 0 = not status, 2 = Don't Allow, 4 = Allow
    NSLog(@"the status: %d", status);
}


#pragma mark- Buttons
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
