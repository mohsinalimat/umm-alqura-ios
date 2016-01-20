#import "DateVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"
#import "AppConstants.h"

@interface DateVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@end

@implementation DateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
