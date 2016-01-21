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
extern NSString *const kNextEventHour;
extern NSString *const kNextEventMinute;
extern NSString *const kNextEventIsToday;

@property (strong, nonatomic) PrayTime *prayTime;

- (NSDictionary *)retrieveCurrentDate;
- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude longitude:(double)longitude date:(NSDate *)date timeZone:(double)timezone andTimeFormat:(NSInteger)timeFormat;
- (NSDictionary *)calculateNextEventForCoordinateLatitude:(double)latitude andLongitude:(double)longitude andTimeZone:(double)timezone;
- (NSInteger)calculateSecondsLeftToNextEventOnHour:(NSInteger)hour minute:(NSInteger)minute timeZone:(double)timezone andWithEventBeingToday:(BOOL)isEventToday;
- (NSArray *)retriveveNextEventRemainingTimeForSeconds:(NSInteger)totalSeconds;

- (NSString *)localizeNextEvent:(NSInteger)event;
- (NSString *)localizeDay:(NSInteger)day;
- (NSString *)localizeGregorianMonth:(NSInteger)month;
- (NSString *)localizeHijriMonth:(NSInteger)month;
- (NSString *)localizeTwoDigitsNumber:(NSInteger)number;
@end
