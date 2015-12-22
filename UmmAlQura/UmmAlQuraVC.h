#import <UIKit/UIKit.h>

@interface UmmAlQuraVC : UIViewController

// Date Hijri
@property (weak, nonatomic) IBOutlet UILabel *dayHijri;
@property (weak, nonatomic) IBOutlet UILabel *monthHijri;

// Date Gregorian
@property (weak, nonatomic) IBOutlet UILabel *dayGregorian;
@property (weak, nonatomic) IBOutlet UILabel *monthGregorian;

@property (weak, nonatomic) IBOutlet UILabel *currentLocation;

// Event
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventSubtext;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;

// Fajr


@end

