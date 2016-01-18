#import "QiblahVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"
#import "AppConstants.h"

@interface QiblahVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
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

}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
