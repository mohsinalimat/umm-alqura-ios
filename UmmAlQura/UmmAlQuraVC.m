#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "PrayTime.h"
#import "UmmAlQuraVC.h"
#import "Constants.h"
#import "LocalizationSystem.h"

@interface UmmAlQuraVC ()
@end

@implementation UmmAlQuraVC

CLLocationManager *locationManager;

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	locationManager = [[CLLocationManager alloc] init];
	[locationManager requestAlwaysAuthorization];
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
	[locationManager startUpdatingLocation];
    
    LocalizationSetLanguage(@"ar");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	[self setupDate];
	[self setupLocation];
	[self setupEvents];
}



- (void)setupDate {
	// Gregorian
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *gregorianComponents = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	NSInteger gregorianDay = [gregorianComponents day];
	NSInteger gregorianMonth = [gregorianComponents month];
	_dayGregorian.text = [NSString stringWithFormat:@"%ld", (long)gregorianDay];
	_monthGregorian.text = [NSString stringWithFormat:@"%ld", (long)gregorianMonth];
	
	// Hijri
	NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
	NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
	NSInteger hijriDay = [hijriComponents day];
	NSInteger hijriMonth = [hijriComponents month];
	_dayHijri.text = [NSString stringWithFormat:@"%ld", (long)hijriDay];
	_monthHijri.text = [NSString stringWithFormat:@"%ld", (long)hijriMonth];
}

- (void)setupLocation {
	
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
		//get current location
		CLGeocoder *geocoder = [[CLGeocoder alloc]init];
		CLLocation *location = [[CLLocation alloc]initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
		
		[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
			CLPlacemark *placemark = [placemarks objectAtIndex:0];
			//NSLog(@"placemark %@",placemark);
			//String to hold address
			NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
			//NSLog(@"addressDictionary %@", placemark.addressDictionary);
		  
            //NSLog(@"placemark %@",placemark.region);
            //NSLog(@"placemark %@",placemark.country);  // Give Country Name
            NSLog(@"placemark %@",placemark.locality); // Extract the city name
            //NSLog(@"location %@",placemark.name);
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


- (void)setupEvents {
    PrayTime *prayerTime = [[PrayTime alloc] initWithJuristic:JuristicMethodShafii
                                               andCalculation:CalculationMethodMakkah];
    NSMutableArray *prayerTimes = [prayerTime prayerTimesDate:[NSDate date]
                                                     latitude:locationManager.location.coordinate.latitude
                                                    longitude:locationManager.location.coordinate.longitude
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
