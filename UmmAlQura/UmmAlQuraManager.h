#import <Foundation/Foundation.h>

@interface UmmAlQuraManager : NSObject

// Date Hijri
@property (strong, nonatomic) NSString	*dayHijri;
@property (strong, nonatomic) NSString	*monthHijri;

// Date Gregorian
@property (strong, nonatomic) NSString	*dayGregorian;
@property (strong, nonatomic) NSString	*monthGregorian;

+ (UmmAlQuraManager*)sharedManager;
- (void)setupLocation;
- (void)setupDate;
- (void)setupEvents;
@end
