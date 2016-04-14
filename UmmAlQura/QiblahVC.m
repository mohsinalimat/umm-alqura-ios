#import "QiblahVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"
#import "AppConstants.h"
#import "GeoPointCompass.h"

@interface QiblahVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@property (strong, nonatomic) GeoPointCompass       *geoPointCompass;
@end

@implementation QiblahVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:kIsUsingCurrentLocation] isEqualToString:kYes]) {
        // locationServicesEnabled we sholud check before asking
        _ummAlQuraManager.locationManager = [[CLLocationManager alloc] init];
        _ummAlQuraManager.locationManager.delegate = self;
        [_ummAlQuraManager.locationManager requestWhenInUseAuthorization];
    } else {
        // we should notiy the user to enable location
    }
    
    _geoPointCompass = [[GeoPointCompass alloc] init];
    [_geoPointCompass setArrowImageView:_needle];
    _geoPointCompass.latitudeOfTargetedPoint = 0.373965869;
    _geoPointCompass.longitudeOfTargetedPoint = 0.6951937182;

}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}


// TODO: implement the calibration method
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    if(!manager.heading) return YES; // Got nothing, We can assume we got to calibrate.
    else if(manager.heading.headingAccuracy < 0 ) return YES; // 0 means invalid heading, need to calibrate
    else if(manager.heading.headingAccuracy > 5 ) return YES; // 5 degrees is a small value correct for my needs, too.
    else return NO; // All is good. Compass is precise enough.
}

@end
