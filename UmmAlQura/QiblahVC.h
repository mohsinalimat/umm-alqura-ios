#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface QiblahVC : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *needle;

@end
