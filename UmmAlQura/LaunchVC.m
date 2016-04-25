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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator startAnimating];
        });
        
        _ummAlQuraManager = [UmmAlQuraManager sharedManager];
        [_ummAlQuraManager setupApp];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_activityIndicator stopAnimating];
            [self performSegueWithIdentifier:@"toUmmAlQura" sender:nil];
        });
        
        
    });
    
}
@end
