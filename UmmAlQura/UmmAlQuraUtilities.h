#import <Foundation/Foundation.h>

@interface UmmAlQuraUtilities : NSObject

// Date
extern NSString *const kDayHijri;
extern NSString *const kMonthHijri;
extern NSString *const kDayGregorian;
extern NSString *const kMonthGregorian;

- (NSDictionary *)retrieveCurrentDate;
- (NSArray *)calculateEventsTimeForCoordinateLatitude:(double)latitude andLongitude:(double)longitude;
@end
