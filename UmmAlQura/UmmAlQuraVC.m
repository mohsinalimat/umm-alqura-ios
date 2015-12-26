#import <QuartzCore/QuartzCore.h>
#import "UmmAlQuraVC.h"
#import "Constants.h"

@interface UmmAlQuraVC ()

@end

@implementation UmmAlQuraVC

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
	[self setupDate];
}



- (void)setupDate {
	_dayGregorian.text = @"";
	_monthGregorian.text = @"";
	_dayHijri.text = @"";
	_monthHijri.text = @"";
}




- (IBAction)switchNotefcation:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    NSLog(@"%@", resultButton.currentImage);
	NSLog(@"sender %@", sender);
    
    if (resultButton.tag == 3) {
        [resultButton setImage:[UIImage imageNamed:@"vibration"] forState:UIControlStateNormal];
        [resultButton setTag:2];
    } else if (resultButton.tag == 2) {
        [resultButton setImage:[UIImage imageNamed:@"notifications_off"] forState:UIControlStateNormal];
        [resultButton setTag:1];
    } else if (resultButton.tag == 1) {
        [resultButton setImage:[UIImage imageNamed:@"notifications_active"] forState:UIControlStateNormal];
        [resultButton setTag:3];
    } else {
        [resultButton setImage:[UIImage imageNamed:@"notifications_off"] forState:UIControlStateNormal];
        [resultButton setTag:1];
    }

}

- (IBAction)changeFajrNotification {
}

- (IBAction)changeSunriseNotification {
}

- (IBAction)changeDhuhrNotification {
}

- (IBAction)changeAsrNotification {
}

- (IBAction)changeMaghribNotification {
}

- (IBAction)changeIshaNotification {
}
@end
