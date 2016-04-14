#import "UmmAlQuraUtilities.h"
#import "PrayTime.h"
#import "AppConstants.h"

@implementation UmmAlQuraUtilities

// Date
NSString *const kDayHijri       = @"DAY_HIJRI";
NSString *const kMonthHijri     = @"MONTH_HIJRI";
NSString *const kDayGregorian   = @"DAY_GREGORIAN";
NSString *const kMonthGregorian = @"MONTH_GREGORIAN";

NSString *const kNextEventId        = @"NEXT_EVENT_ID";
NSString *const kNextEventTime      = @"NEXT_EVENT_TIME";
NSString *const kNextEventHour      = @"NEXT_EVENT_HOUR";
NSString *const kNextEventMinute    = @"NEXT_EVENT_MINUTE";
NSString *const kNextEventIsToday   = @"NEXT_EVENT_IS_TODAY";



- (NSDictionary *)retrieveCurrentDate {
    NSMutableDictionary *date = [[NSMutableDictionary alloc] init];
    
    // we sholud get the locale so the date wll be
    
    // Gregorian
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *gregorianComponents = [gregorianCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger gregorianDay = [gregorianComponents day];
    NSInteger gregorianMonth = [gregorianComponents month];
    [date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianDay] forKey:kDayGregorian];
    [date setObject:[NSString stringWithFormat:@"%ld", (long)gregorianMonth] forKey:kMonthGregorian];
    
    // Hijri
    NSCalendar *hijriCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierIslamicUmmAlQura];
    NSDateComponents *hijriComponents = [hijriCalendar components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger hijriDay = [hijriComponents day];
    NSInteger hijriMonth = [hijriComponents month];
    [date setObject:[NSString stringWithFormat:@"%ld", (long)hijriDay] forKey:kDayHijri];
    [date setObject:[NSString stringWithFormat:@"%ld", (long)hijriMonth] forKey:kMonthHijri];
    
    return date;
}

- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude longitude:(double)longitude date:(NSDate *)date timeZone:(double)timezone andTimeFormat:(NSInteger)timeFormat {
    _prayTime = [[PrayTime alloc] init];
    
    NSDateComponents *dateComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                                                                                        fromDate:date];
    
    [_prayTime setCalcMethod:(int)_prayTime.Makkah];
    [_prayTime setTimeFormat:(int)timeFormat];
    
    NSMutableArray *prayerTimes = [_prayTime getPrayerTimes:dateComponents andLatitude:latitude andLongitude:longitude andtimeZone:timezone];
    [prayerTimes removeObjectAtIndex:5]; // removing sunset
    return prayerTimes;
}

- (NSDictionary *)calculateNextEventForCoordinateLatitude:(double)latitude andLongitude:(double)longitude andTimeZone:(double)timezone{
    NSMutableDictionary *nextEventDictionary = [[NSMutableDictionary alloc] init];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    NSDate *todayDate = [NSDate date];
    NSDate *tomorrowDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    NSArray *todayEvents = [self calculateEventsTimeForCoordinateLatitude:latitude longitude:longitude date:todayDate timeZone:timezone andTimeFormat:_prayTime.Time24];
    NSArray *tomorrowEvents = [self calculateEventsTimeForCoordinateLatitude:latitude longitude:longitude date:tomorrowDate timeZone:timezone andTimeFormat:_prayTime.Time24];
    BOOL isNextEventTomorrow = YES;
    float offset = timezone*3600;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
    
    NSDate *eventTime;
    NSDate *currentTime = [[NSDate alloc] init];
    currentTime = [calendar dateFromComponents:components];
    
    for (int i = 0; i < [todayEvents count]; i++) {
        
        NSInteger hour = [[[todayEvents objectAtIndex:i] componentsSeparatedByString:@":"][0] integerValue];
        NSInteger minute = [[[todayEvents objectAtIndex:i] componentsSeparatedByString:@":"][1] integerValue];
        eventTime = [[NSDate alloc] init];
        eventTime = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:[NSDate date] options:0];

        NSComparisonResult result = [eventTime compare:currentTime];
        switch (result) {
            case NSOrderedDescending:
                [nextEventDictionary setValue:[NSNumber numberWithInt:i] forKey:kNextEventId];
                [nextEventDictionary setValue:eventTime forKey:kNextEventTime];
                [nextEventDictionary setValue:[NSNumber numberWithInteger:hour] forKey:kNextEventHour];
                [nextEventDictionary setValue:[NSNumber numberWithInteger:minute] forKey:kNextEventMinute];
                [nextEventDictionary setObject:kYes forKey:kNextEventIsToday];
                isNextEventTomorrow = NO;
                break;
                
            default: break;
        }
        
        if (!isNextEventTomorrow) {
            break;
        }

    }
    
    if (isNextEventTomorrow) {
        NSInteger hour = [[[tomorrowEvents objectAtIndex:0] componentsSeparatedByString:@":"][0] integerValue];
        NSInteger minute = [[[tomorrowEvents objectAtIndex:0] componentsSeparatedByString:@":"][1] integerValue];
        eventTime = [[NSDate alloc] init];
        eventTime = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:[NSDate date] options:0];
        [nextEventDictionary setValue:0 forKey:kNextEventId];
        [nextEventDictionary setValue:eventTime forKey:kNextEventTime];
        [nextEventDictionary setValue:[NSNumber numberWithInteger:hour] forKey:kNextEventHour];
        [nextEventDictionary setValue:[NSNumber numberWithInteger:minute] forKey:kNextEventMinute];
        [nextEventDictionary setObject:kNo forKey:kNextEventIsToday];
    }
    
    NSLog(@"next event: %@", nextEventDictionary);
    return nextEventDictionary;
}

- (NSInteger)calculateSecondsLeftToNextEventOnHour:(NSInteger)hour minute:(NSInteger)minute timeZone:(double)timezone andWithEventBeingToday:(BOOL)isEventToday {
    float offset = timezone*3600;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:offset]];
    NSDate *currentTime = [[NSDate alloc] init];
    NSDate * eventTime = [[NSDate alloc] init];
    currentTime = [calendar dateFromComponents:components];
    
    if (isEventToday) {
        eventTime = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:[NSDate date] options:0];
    } else {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:1];
        NSDate *tomorrowDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
        eventTime = [calendar dateBySettingHour:hour minute:minute second:0 ofDate:tomorrowDate options:0];
    }
    
    NSTimeInterval secondsLeftToNextEvent = [eventTime timeIntervalSinceDate:currentTime];
    
    NSLog(@"next event time: %@", eventTime);
    NSLog(@"current time: %@", currentTime);
    NSLog(@"second left: %f", secondsLeftToNextEvent);
    
    return secondsLeftToNextEvent;
}

- (NSArray *)retriveveNextEventRemainingTimeForSeconds:(NSInteger)totalSeconds {
    NSMutableArray *remainingTime = [[NSMutableArray alloc] init];
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    
    [remainingTime addObject:[self localizeTwoDigitsNumber:hours]];
    [remainingTime addObject:[self localizeTwoDigitsNumber:minutes]];
    [remainingTime addObject:[self localizeTwoDigitsNumber:seconds]];
    
    //NSLog(@"time left --> %ld:%ld:%ld", (long)hours, (long)minutes, (long)seconds);
    return remainingTime;
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

- (NSString *)localizeTwoDigitsNumber:(NSInteger)number {

    switch (number) {
        case 0:
            return NSLocalizedString(@"TWO_DIGITS_00", nil);
            break;
            
        case 1:
            return NSLocalizedString(@"TWO_DIGITS_01", nil);
            break;
            
        case 2:
            return NSLocalizedString(@"TWO_DIGITS_02", nil);
            break;
            
        case 3:
            return NSLocalizedString(@"TWO_DIGITS_03", nil);
            break;
            
        case 4:
            return NSLocalizedString(@"TWO_DIGITS_04", nil);
            break;
            
        case 5:
            return NSLocalizedString(@"TWO_DIGITS_05", nil);
            break;
            
        case 6:
            return NSLocalizedString(@"TWO_DIGITS_06", nil);
            break;
            
        case 7:
            return NSLocalizedString(@"TWO_DIGITS_07", nil);
            break;
            
        case 8:
            return NSLocalizedString(@"TWO_DIGITS_08", nil);
            break;
            
        case 9:
            return NSLocalizedString(@"TWO_DIGITS_09", nil);
            break;
            
        case 10:
            return NSLocalizedString(@"TWO_DIGITS_10", nil);
            break;
            
        case 11:
            return NSLocalizedString(@"TWO_DIGITS_11", nil);
            break;
            
        case 12:
            return NSLocalizedString(@"TWO_DIGITS_12", nil);
            break;
            
        case 13:
            return NSLocalizedString(@"TWO_DIGITS_13", nil);
            break;
            
        case 14:
            return NSLocalizedString(@"TWO_DIGITS_14", nil);
            break;
            
        case 15:
            return NSLocalizedString(@"TWO_DIGITS_15", nil);
            break;
            
        case 16:
            return NSLocalizedString(@"TWO_DIGITS_16", nil);
            break;
            
        case 17:
            return NSLocalizedString(@"TWO_DIGITS_17", nil);
            break;
            
        case 18:
            return NSLocalizedString(@"TWO_DIGITS_18", nil);
            break;
            
        case 19:
            return NSLocalizedString(@"TWO_DIGITS_19", nil);
            break;
            
        case 20:
            return NSLocalizedString(@"TWO_DIGITS_20", nil);
            break;
            
        case 21:
            return NSLocalizedString(@"TWO_DIGITS_21", nil);
            break;
            
        case 22:
            return NSLocalizedString(@"TWO_DIGITS_22", nil);
            break;
            
        case 23:
            return NSLocalizedString(@"TWO_DIGITS_23", nil);
            break;
            
        case 24:
            return NSLocalizedString(@"TWO_DIGITS_24", nil);
            break;
            
        case 25:
            return NSLocalizedString(@"TWO_DIGITS_25", nil);
            break;
            
        case 26:
            return NSLocalizedString(@"TWO_DIGITS_26", nil);
            break;
            
        case 27:
            return NSLocalizedString(@"TWO_DIGITS_27", nil);
            break;
            
        case 28:
            return NSLocalizedString(@"TWO_DIGITS_28", nil);
            break;
            
        case 29:
            return NSLocalizedString(@"TWO_DIGITS_29", nil);
            break;
            
        case 30:
            return NSLocalizedString(@"TWO_DIGITS_30", nil);
            break;
            
        case 31:
            return NSLocalizedString(@"TWO_DIGITS_31", nil);
            break;
            
        case 32:
            return NSLocalizedString(@"TWO_DIGITS_32", nil);
            break;
            
        case 33:
            return NSLocalizedString(@"TWO_DIGITS_33", nil);
            break;
            
        case 34:
            return NSLocalizedString(@"TWO_DIGITS_34", nil);
            break;
            
        case 35:
            return NSLocalizedString(@"TWO_DIGITS_35", nil);
            break;
            
        case 36:
            return NSLocalizedString(@"TWO_DIGITS_36", nil);
            break;
            
        case 37:
            return NSLocalizedString(@"TWO_DIGITS_37", nil);
            break;
            
        case 38:
            return NSLocalizedString(@"TWO_DIGITS_38", nil);
            break;
            
        case 39:
            return NSLocalizedString(@"TWO_DIGITS_39", nil);
            break;
            
        case 40:
            return NSLocalizedString(@"TWO_DIGITS_40", nil);
            break;
            
        case 41:
            return NSLocalizedString(@"TWO_DIGITS_41", nil);
            break;
            
        case 42:
            return NSLocalizedString(@"TWO_DIGITS_42", nil);
            break;
            
        case 43:
            return NSLocalizedString(@"TWO_DIGITS_43", nil);
            break;
            
        case 44:
            return NSLocalizedString(@"TWO_DIGITS_44", nil);
            break;
            
        case 45:
            return NSLocalizedString(@"TWO_DIGITS_45", nil);
            break;
            
        case 46:
            return NSLocalizedString(@"TWO_DIGITS_46", nil);
            break;
            
        case 47:
            return NSLocalizedString(@"TWO_DIGITS_47", nil);
            break;
            
        case 48:
            return NSLocalizedString(@"TWO_DIGITS_48", nil);
            break;
            
        case 49:
            return NSLocalizedString(@"TWO_DIGITS_49", nil);
            break;
            
        case 50:
            return NSLocalizedString(@"TWO_DIGITS_50", nil);
            break;
            
        case 51:
            return NSLocalizedString(@"TWO_DIGITS_51", nil);
            break;
            
        case 52:
            return NSLocalizedString(@"TWO_DIGITS_52", nil);
            break;
            
        case 53:
            return NSLocalizedString(@"TWO_DIGITS_53", nil);
            break;
            
        case 54:
            return NSLocalizedString(@"TWO_DIGITS_54", nil);
            break;
            
        case 55:
            return NSLocalizedString(@"TWO_DIGITS_55", nil);
            break;
            
        case 56:
            return NSLocalizedString(@"TWO_DIGITS_56", nil);
            break;
            
        case 57:
            return NSLocalizedString(@"TWO_DIGITS_57", nil);
            break;
            
        case 58:
            return NSLocalizedString(@"TWO_DIGITS_58", nil);
            break;
            
        case 59:
            return NSLocalizedString(@"TWO_DIGITS_59", nil);
            break;
            
        default:
            return @"";
            break;
    }
    
}
@end
