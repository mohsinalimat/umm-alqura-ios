#import "UmmAlQuraUtilities.h"
#import "PrayTime.h"

@implementation UmmAlQuraUtilities

// Date
NSString *const kDayHijri       = @"DAY_HIJRI";
NSString *const kMonthHijri     = @"MONTH_HIJRI";
NSString *const kDayGregorian   = @"DAY_GREGORIAN";
NSString *const kMonthGregorian = @"MONTH_GREGORIAN";

- (NSDictionary *)retrieveCurrentDate {
    NSMutableDictionary *_date = [[NSMutableDictionary alloc] init];
    
    // Gregorian
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *gregorianComponents = [gregorianCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger gregorianDay = [gregorianComponents day];
    NSInteger gregorianMonth = [gregorianComponents month];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianDay] forKey:kDayGregorian];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianMonth] forKey:kMonthGregorian];
    
    // Hijri
    NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
    NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger hijriDay = [hijriComponents day];
    NSInteger hijriMonth = [hijriComponents month];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)hijriDay] forKey:kDayHijri];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)hijriMonth] forKey:kMonthHijri];
    
    return _date;
}

- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude andLongitude:(double)longitude {
    PrayTime *prayerTime = [[PrayTime alloc] initWithJuristic:JuristicMethodShafii
                                               andCalculation:CalculationMethodMakkah];
    
    NSMutableArray *prayerTimes = [prayerTime prayerTimesDate:[NSDate date]
                                                     latitude:latitude
                                                    longitude:longitude
                                                  andTimezone:[prayerTime getTimeZone]];
    return prayerTimes;
}

@end
