//
//  ViewController.m
//  UmmAlQura
//
//  Created by Khalid Alnuaim on 11/15/15.
//  Copyright © 2015 KACST. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

//    self.viewHijri.layer.borderWidth = 0.5f;
//    self.viewHijri.layer.borderColor = [UIColor blackColor].CGColor;
//    self.viewGregorian.layer.borderWidth = 0.5f;
//    self.viewGregorian.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchNotefcation:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    NSLog(@"%@", resultButton.currentImage);
    
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
@end
