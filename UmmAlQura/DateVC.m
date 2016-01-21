#import "DateVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"
#import "AppConstants.h"

@interface DateVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@property (strong, nonatomic) NSCalendar            *calendarHijri;
@property (strong, nonatomic) NSCalendar            *calendarGregorian;
@property (strong, nonatomic) NSArray               *eventsTimeArray;
@end

@implementation DateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _ummAlQuraManager       = [UmmAlQuraManager  sharedManager];
    _ummAlQuraUtilities     = [[UmmAlQuraUtilities alloc] init];
    _calendarHijri = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
    _calendarGregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _datePicker.calendar = _calendarHijri;
    [self calculate];

}

- (IBAction)segmentedControlChanged:(id)sender {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _datePicker.calendar = _calendarHijri;
        [self calculate];
    }
    
    if (_segmentedControl.selectedSegmentIndex == 1) {
        _datePicker.calendar = _calendarGregorian;
        [self calculate];
    }
    
}

- (IBAction)datePickerChanged:(id)sender {
    [self calculate];
}

- (void)calculate {
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        NSDateComponents *components = [_calendarGregorian components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_datePicker.date];
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        _dateConvertedLabel.text = [NSString stringWithFormat:@"%ld / %@ / %ld %@", (long)day, [_ummAlQuraUtilities localizeGregorianMonth:month], (long)year, NSLocalizedString(@"GREGORIAN_SUFFIX", nil)];
    }else if (_segmentedControl.selectedSegmentIndex == 1) {
        NSDateComponents *components = [_calendarHijri components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_datePicker.date];
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        _dateConvertedLabel.text = [NSString stringWithFormat:@"%ld / %@ / %ld %@", (long)day, [_ummAlQuraUtilities localizeHijriMonth:month], (long)year, NSLocalizedString(@"HIJRI_SUFFIX", nil)];
    }
    
    _eventsTimeArray = [[NSArray alloc] init];
    
    _eventsTimeArray = [_ummAlQuraUtilities calculateEventsTimeForCoordinateLatitude:_ummAlQuraManager.locationManager.location.coordinate.latitude
                                                                           longitude:_ummAlQuraManager.locationManager.location.coordinate.longitude
                                                                                date:_datePicker.date
                                                                            timeZone:[_ummAlQuraManager.currentLocationTimeZone doubleValue]
                                                                       andTimeFormat:_ummAlQuraUtilities.prayTime.Time12];
    
    // try catch
    _eventFajrTitle.text    = NSLocalizedString(@"EVENT_FAJR", nil);
    _eventFajrTime.text     = [_eventsTimeArray objectAtIndex:0];
    _eventSunriseTitle.text = NSLocalizedString(@"EVENT_SUNRISE", nil);
    _eventSunriseTime.text  = [_eventsTimeArray objectAtIndex:1];
    _eventDhuhrTitle.text   = NSLocalizedString(@"EVENT_DHUHR", nil);
    _eventDhuhrTime.text    = [_eventsTimeArray objectAtIndex:2];
    _eventAsrTitle.text     = NSLocalizedString(@"EVENT_ASR", nil);
    _eventAsrTime.text      = [_eventsTimeArray objectAtIndex:3];
    _eventMaghribTitle.text = NSLocalizedString(@"EVENT_MAGHRIB", nil);
    _eventMaghribTime.text  = [_eventsTimeArray objectAtIndex:4];
    _eventIshaTitle.text    = NSLocalizedString(@"EVENT_ISHA", nil);
    _eventIshaTime.text     = [_eventsTimeArray objectAtIndex:5];
    
    NSLog(@"converted date events: %@", _eventsTimeArray);

}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
