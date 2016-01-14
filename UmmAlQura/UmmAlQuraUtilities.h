#import <Foundation/Foundation.h>
#import "PrayTime.h"
@interface UmmAlQuraUtilities : NSObject

// Date
extern NSString *const kDayHijri;
extern NSString *const kMonthHijri;
extern NSString *const kDayGregorian;
extern NSString *const kMonthGregorian;

extern NSString *const kNextEventId;
extern NSString *const kNextEventTime;

- (NSDictionary *)retrieveCurrentDate;
- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude longitude:(double)longitude date:(NSDate *)date timeZone:(double)timezone andTimeFormat:(TimeFormat)timeFormat;
- (NSDictionary *)calculateNextEventForCoordinateLatitude:(double)latitude andLongitude:(double)longitude andTimeZone:(double)timezone;

- (NSString *)localizeNextEvent:(NSInteger)event;
- (NSString *)localizeDay:(NSInteger)day;
- (NSString *)localizeGregorianMonth:(NSInteger)month;
- (NSString *)localizeHijriMonth:(NSInteger)month;
@end
