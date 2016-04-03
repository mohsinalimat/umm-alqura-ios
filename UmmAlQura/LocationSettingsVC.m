#import "LocationSettingsVC.h"
#import "UmmAlQuraManager.h"
#import "UmmAlQuraUtilities.h"
#import "AppConstants.h"
#import "SwitchCell.h"

@interface LocationSettingsVC ()
@property (strong, nonatomic) UmmAlQuraManager      *ummAlQuraManager;
@property (strong, nonatomic) UmmAlQuraUtilities    *ummAlQuraUtilities;
@end

@implementation LocationSettingsVC

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:kSwitchCell bundle:nil] forCellReuseIdentifier:kSwitchCell];

}


#pragma -mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return 1;}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {return @"Location Settings";}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SwitchCell *switchCell;
    
    @try {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            switchCell = [tableView dequeueReusableCellWithIdentifier:kSwitchCell forIndexPath:indexPath];
            switchCell.cLabel.text = NSLocalizedString(@"AUTO_DETECT_LOCATION", nil);
            [switchCell.cSwitch addTarget:self action:@selector(statusChangedForAutoLocation:) forControlEvents:UIControlEventValueChanged];
            return switchCell;
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR: %@", exception);
    }
    
}


#pragma mark - Methods
- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)statusChangedForAutoLocation:(UISwitch *)cSwitch {
    
    if ([cSwitch isOn]) {
        NSLog(@"On");
    } else {
        NSLog(@"Off");
    }
    
}
@end
