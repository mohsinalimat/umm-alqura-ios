#import "UmmAlQuraManager.h"
#import "AppConstants.h"
#import "PrayTime.h"

@implementation UmmAlQuraManager

// Location
NSString *const kIsUsingCurrentLocation		= @"IS_USING_CURRENT_LOCATION";	// Yes or No
NSString *const kCurrentLocationName		= @"CURRENT_LOCATION_NAME";
NSString *const kCurrentLocationLatitude	= @"CURRENT_LOCATION_LATITUDE";
NSString *const kCurrentLocationLongitude	= @"CURRENT_LOCATION_LONGITUDE";

// Notification settings
// 1 = off
// 2 = vibration
// 3 = active
NSString* const kNotificationFajr		= @"NOTIFICATION_FAJR";
NSString* const kNotificationSunrise	= @"NOTIFICATION_SUNRISE";
NSString* const kNotificationDhuhr		= @"NOTIFICATION_DHUHR";
NSString* const kNotificationAsr		= @"NOTIFICATION_ASR";
NSString* const kNotificationMaghrib	= @"NOTIFICATION_MAGHRIB";
NSString* const kNotificationIsha		= @"NOTIFICATION_ISHA";



+ (UmmAlQuraManager*)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)setupApp {
    // if the object for the "kVersionCurrent" not setup that mean this is the first time
    // the application launches, so setup the init settings.
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kVersionCurrent]) {
        [self initSettings];
    }
    
}


// should be moved to controller
- (NSDictionary *)retrieveLocationCoordinate {
    NSMutableDictionary *_coordinate = [[NSMutableDictionary alloc] init];
    
//    // TODO: we need to handle the user selction if atuorize or not
//    _locationManager = [[CLLocationManager alloc] init];
//    [_locationManager requestAlwaysAuthorization]; // we didn't select requestWhenInUseAuthorization bucuse if the user change location while the app close we still could notifie him
//    
//    
//    // to know it the user enable the locatin service
//    if ([_locationManager locationServicesEnabled]) {
//        NSLog(@"app locatin auth status: true");
//    } else {
//        NSLog(@"app locatin auth status: no");
//    }
//    
//    
//    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    [_locationManager startUpdatingLocation];
//    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
//        //get current location
//        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//        CLLocation *location = [[CLLocation alloc]initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
//        
//        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            
//            for (CLPlacemark *placemark in placemarks) {
//                NSLog(@"city: %@", [placemark locality]);
//            }
//            
////            CLPlacemark *placemark = [placemarks objectAtIndex:0];
////            //NSLog(@"placemark %@",placemark);
////            //String to hold address
////            //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
////            //NSLog(@"addressDictionary %@", placemark.addressDictionary);
////            
////            //NSLog(@"placemark %@",placemark.region);
////            NSLog(@"placemark %@",placemark.country);  // Give Country Name
////            NSLog(@"placemark %@",placemark.locality); // Extract the city name
////            //NSLog(@"location %@",placemark.administrativeArea);
////            //NSLog(@"location %@",placemark.ocean);
////            //NSLog(@"location %@",placemark.postalCode);
////            //NSLog(@"location %@",placemark.subLocality);
////            
////            //NSLog(@"location %@",placemark.location);
////            //Print the location to console
////            //NSLog(@"I am currently at %@",locatedAt);
//            
//        }
//         ];
//        
//    }
    
    return _coordinate;
}

- (void)makkahMode {
    // setup the app to makkah
}

- (void)initSettings {
    [[NSUserDefaults standardUserDefaults] setObject:kVersionApp forKey:kVersionCurrent];
    [[NSUserDefaults standardUserDefaults] setObject:kYes forKey:kIsUsingCurrentLocation];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:kAppLocale];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en-US", @"en-US", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self makkahMode];
}

@end
