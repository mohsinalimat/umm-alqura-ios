#import <UIKit/UIKit.h>

@interface DateVC : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateConvertedLabel;

// Fajr
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventFajrTime;

// Sunrise
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventSunriseTime;

// Dhuhr
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventDhuhrTime;

// Asr
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventAsrTime;

// Maghrib
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventMaghribTime;

// Isha
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaTitle;
@property (weak, nonatomic) IBOutlet UILabel	*eventIshaTime;

@end
