#import "UmmAlQuraUtilities.h"
#import "PrayTime.h"

@implementation UmmAlQuraUtilities

// Date
NSString *const kDayHijri       = @"DAY_HIJRI";
NSString *const kMonthHijri     = @"MONTH_HIJRI";
NSString *const kDayGregorian   = @"DAY_GREGORIAN";
NSString *const kMonthGregorian = @"MONTH_GREGORIAN";

NSString *const kNextEventId    = @"NEXT_EVENT_ID";
NSString *const kNextEventTime  = @"NEXT_EVENT_TIME";

- (NSDictionary *)retrieveCurrentDate {
    NSMutableDictionary *_date = [[NSMutableDictionary alloc] init];
    
    // we sholud get the locale so the date wll be
    
    // Gregorian
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *gregorianComponents = [gregorianCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger gregorianDay = [gregorianComponents day];
    NSInteger gregorianMonth = [gregorianComponents month];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianDay] forKey:kDayGregorian];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianMonth] forKey:kMonthGregorian];
    
    // Hijri
    NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
    NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger hijriDay = [hijriComponents day];
    NSInteger hijriMonth = [hijriComponents month];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)hijriDay] forKey:kDayHijri];
    [_date setObject:[NSString stringWithFormat:@"%ld", (long)hijriMonth] forKey:kMonthHijri];
    
    return _date;
}

- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude longitude:(double)longitude date:(NSDate *)date timeZone:(double)timezone andTimeFormat:(TimeFormat)timeFormat {
    PrayTime *prayerTime = [[PrayTime alloc] initWithJuristic:JuristicMethodShafii
                                               andCalculation:CalculationMethodMakkah];
    [prayerTime setTimeFormat:timeFormat];
    
    NSArray *prayerTimes = [prayerTime prayerTimesDate:date latitude:latitude longitude:longitude andTimezone:timezone];
    return prayerTimes;
}

- (NSDictionary *)calculateNextEventForCoordinateLatitude:(double)latitude andLongitude:(double)longitude andTimeZone:(double)timezone{
    NSMutableDictionary *_nextEventDictionary = [[NSMutableDictionary alloc] init];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    NSDate *_todayDate = [NSDate date];
    NSDate *_tomorrowDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSArray *_todayEvents = [self calculateEventsTimeForCoordinateLatitude:latitude longitude:longitude date:_todayDate timeZone:timezone andTimeFormat:TimeFormat24Hour];
    NSArray *_tomorrowEvents = [self calculateEventsTimeForCoordinateLatitude:latitude longitude:longitude date:_tomorrowDate timeZone:timezone andTimeFormat:TimeFormat24Hour];
    BOOL isNextEventTomorrow = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:timezone]];
    NSDate *_eventTime;
    NSDate *_currentTime = [[NSDate alloc] init];
    _currentTime = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    for (int i = 0; i < [_todayEvents count]; i++) {
        NSInteger hour = [[[_todayEvents objectAtIndex:i] componentsSeparatedByString:@":"][0] integerValue];
        NSInteger minute = [[[_todayEvents objectAtIndex:i] componentsSeparatedByString:@":"][1] integerValue];
        _eventTime = [[NSDate alloc] init];
        _eventTime = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:[NSDate date] options:0];
        NSComparisonResult result = [_eventTime compare:_currentTime];
        
        switch (result) {
            case NSOrderedDescending:
                [_nextEventDictionary setValue:[NSNumber numberWithInt:i] forKey:kNextEventId];
                [_nextEventDictionary setValue:_eventTime forKey:kNextEventTime];
                isNextEventTomorrow = NO;
                break;
                
            default: break;
        }
        
        if (!isNextEventTomorrow) {
            break;
        }

    }
    
    if (isNextEventTomorrow) {
        [_nextEventDictionary setValue:0 forKey:kNextEventId];
        [_nextEventDictionary setValue:[_tomorrowEvents objectAtIndex:0] forKey:kNextEventTime];
    }
    
    NSLog(@"next event: %@", _nextEventDictionary);
    
    return _nextEventDictionary;
}


- (NSString *)localizeNextEvent:(NSInteger)event {
    
    switch (event) {
        case 0:
            return NSLocalizedString(@"EVENT_FAJR", nil);
            break;
            
        case 1:
            return NSLocalizedString(@"EVENT_SUNRISE", nil);
            break;
            
        case 2:
            return NSLocalizedString(@"EVENT_DHUHR", nil);
            break;
            
        case 3:
            return NSLocalizedString(@"EVENT_ASR", nil);
            break;
            
        case 4:
            return NSLocalizedString(@"EVENT_MAGHRIB", nil);
            break;
            
        case 6:
            return NSLocalizedString(@"EVENT_ISHA", nil);
            break;
            
        default:
            return @"";
            break;
    }
    
}


- (NSString *)localizeDay:(NSInteger)day {
    
    switch (day) {
        case 1:
            return NSLocalizedString(@"DAY_01", nil);
            break;
            
        case 2:
            return NSLocalizedString(@"DAY_02", nil);
            break;
            
        case 3:
            return NSLocalizedString(@"DAY_03", nil);
            break;
            
        case 4:
            return NSLocalizedString(@"DAY_04", nil);
            break;
            
        case 5:
            return NSLocalizedString(@"DAY_05", nil);
            break;
            
        case 6:
            return NSLocalizedString(@"DAY_06", nil);
            break;
            
        case 7:
            return NSLocalizedString(@"DAY_07", nil);
            break;
            
        case 8:
            return NSLocalizedString(@"DAY_08", nil);
            break;
            
        case 9:
            return NSLocalizedString(@"DAY_09", nil);
            break;
            
        case 10:
            return NSLocalizedString(@"DAY_10", nil);
            break;
            
        case 11:
            return NSLocalizedString(@"DAY_11", nil);
            break;
            
        case 12:
            return NSLocalizedString(@"DAY_12", nil);
            break;
            
        case 13:
            return NSLocalizedString(@"DAY_13", nil);
            break;
            
        case 14:
            return NSLocalizedString(@"DAY_14", nil);
            break;
            
        case 15:
            return NSLocalizedString(@"DAY_15", nil);
            break;
            
        case 16:
            return NSLocalizedString(@"DAY_16", nil);
            break;
            
        case 17:
            return NSLocalizedString(@"DAY_17", nil);
            break;
            
        case 18:
            return NSLocalizedString(@"DAY_18", nil);
            break;
            
        case 19:
            return NSLocalizedString(@"DAY_19", nil);
            break;
            
        case 20:
            return NSLocalizedString(@"DAY_20", nil);
            break;
            
        case 21:
            return NSLocalizedString(@"DAY_21", nil);
            break;
            
        case 22:
            return NSLocalizedString(@"DAY_22", nil);
            break;
            
        case 23:
            return NSLocalizedString(@"DAY_23", nil);
            break;
            
        case 24:
            return NSLocalizedString(@"DAY_24", nil);
            break;
            
        case 25:
            return NSLocalizedString(@"DAY_25", nil);
            break;
            
        case 26:
            return NSLocalizedString(@"DAY_26", nil);
            break;
            
        case 27:
            return NSLocalizedString(@"DAY_27", nil);
            break;
            
        case 28:
            return NSLocalizedString(@"DAY_28", nil);
            break;
            
        case 29:
            return NSLocalizedString(@"DAY_29", nil);
            break;
            
        case 30:
            return NSLocalizedString(@"DAY_30", nil);
            break;
            
        case 31:
            return NSLocalizedString(@"DAY_31", nil);
            break;
            
        default:
            return @"";
            break;
    }

}


- (NSString *)localizeGregorianMonth:(NSInteger)month {
    
    switch (month) {
        case 1:
            return NSLocalizedString(@"MONTH_GREGORIAN_JANUARY", nil);
            break;
            
        case 2:
            return NSLocalizedString(@"MONTH_GREGORIAN_FEBRUARY", nil);
            break;
            
        case 3:
            return NSLocalizedString(@"MONTH_GREGORIAN_MARCH", nil);
            break;
            
        case 4:
            return NSLocalizedString(@"MONTH_GREGORIAN_APRIL", nil);
            break;
            
        case 5:
            return NSLocalizedString(@"MONTH_GREGORIAN_MAY", nil);
            break;
            
        case 6:
            return NSLocalizedString(@"MONTH_GREGORIAN_JUNE", nil);
            break;
            
        case 7:
            return NSLocalizedString(@"MONTH_GREGORIAN_JULY", nil);
            break;
            
        case 8:
            return NSLocalizedString(@"MONTH_GREGORIAN_AUGUST", nil);
            break;
            
        case 9:
            return NSLocalizedString(@"MONTH_GREGORIAN_SEPTEMBER", nil);
            break;
            
        case 10:
            return NSLocalizedString(@"MONTH_GREGORIAN_OCTOBER", nil);
            break;
            
        case 11:
            return NSLocalizedString(@"MONTH_GREGORIAN_NOVEMBER", nil);
            break;
            
        case 12:
            return NSLocalizedString(@"MONTH_GREGORIAN_DECEMBER", nil);
            break;
            
        default:
            return @"";
            break;
    }
    
}


- (NSString *)localizeHijriMonth:(NSInteger)month {
    
    switch (month) {
        case 1:
            return NSLocalizedString(@"MONTH_HIJRI_MUHARRAM", nil);
            break;
            
        case 2:
            return NSLocalizedString(@"MONTH_HIJRI_SAFAR", nil);
            break;
            
        case 3:
            return NSLocalizedString(@"MONTH_HIJRI_RABI_ALAWWAL", nil);
            break;
            
        case 4:
            return NSLocalizedString(@"MONTH_HIJRI_RABI_ALTHANI", nil);
            break;
            
        case 5:
            return NSLocalizedString(@"MONTH_HIJRI_JUMADA_ALAWWAL", nil);
            break;
            
        case 6:
            return NSLocalizedString(@"MONTH_HIJRI_JUMAADA_ALAKHIR", nil);
            break;
            
        case 7:
            return NSLocalizedString(@"MONTH_HIJRI_RAJAB", nil);
            break;
            
        case 8:
            return NSLocalizedString(@"MONTH_HIJRI_SHABAN", nil);
            break;
            
        case 9:
            return NSLocalizedString(@"MONTH_HIJRI_RAMADAN", nil);
            break;
            
        case 10:
            return NSLocalizedString(@"MONTH_HIJRI_SHAWWAL", nil);
            break;
            
        case 11:
            return NSLocalizedString(@"MONTH_HIJRI_DHU_ALQIDAH", nil);
            break;
            
        case 12:
            return NSLocalizedString(@"MONTH_HIJRI_DHU_ALHIJJAH", nil);
            break;
            
        default:
            return @"";
            break;
    }
    
}
@end
