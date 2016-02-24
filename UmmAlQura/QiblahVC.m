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
    }
    
    _geoPointCompass = [[GeoPointCompass alloc] init];
    [_geoPointCompass setArrowImageView:_needle];
    _geoPointCompass.latitudeOfTargetedPoint = 0.373965869;
    _geoPointCompass.longitudeOfTargetedPoint = 0.6951937182;

}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
