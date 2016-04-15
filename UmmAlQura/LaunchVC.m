#import "LaunchVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"

@interface LaunchVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@end

@implementation LaunchVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    _ummAlQuraManager = [UmmAlQuraManager sharedManager];
    [_ummAlQuraManager setupApp];
    [self performSegueWithIdentifier:@"toUmmAlQura" sender:nil];
}
@end
