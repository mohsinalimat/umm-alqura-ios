#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "UmmAlQuraManager.h"
#import "Constants.h"

@implementation UmmAlQuraManager

CLLocationManager *locationManager;

+ (UmmAlQuraManager*)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;

    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

- (void)setupLocation {
    
    // TODO: we need to handle the user selction if atuorize or not
    locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
        //get current location
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        CLLocation *location = [[CLLocation alloc]initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"placemark %@",placemark);
            //String to hold address
            //NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            //NSLog(@"addressDictionary %@", placemark.addressDictionary);
            
            //NSLog(@"placemark %@",placemark.region);
            //NSLog(@"placemark %@",placemark.country);  // Give Country Name
            NSLog(@"placemark %@",placemark.locality); // Extract the city name
            NSLog(@"location %@",placemark.administrativeArea);
            //NSLog(@"location %@",placemark.ocean);
            //NSLog(@"location %@",placemark.postalCode);
            //NSLog(@"location %@",placemark.subLocality);
            
            //NSLog(@"location %@",placemark.location);
            //Print the location to console
            //NSLog(@"I am currently at %@",locatedAt);
            
        }
         ];
        
    }
}

- (void)setupDate {
    // Gregorian
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *gregorianComponents = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger gregorianDay = [gregorianComponents day];
    NSInteger gregorianMonth = [gregorianComponents month];
    _dayGregorian   = [NSString stringWithFormat:@"%ld", (long)gregorianDay];
    _monthGregorian = [NSString stringWithFormat:@"%ld", (long)gregorianMonth];
    
    // Hijri
    NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
    NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger hijriDay = [hijriComponents day];
    NSInteger hijriMonth = [hijriComponents month];
    _dayHijri   = [NSString stringWithFormat:@"%ld", (long)hijriDay];
    _monthHijri = [NSString stringWithFormat:@"%ld", (long)hijriMonth];
}

- (void)setupEvents {
}

@end
