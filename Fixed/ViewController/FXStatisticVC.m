//
//  FXStatisticVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXStatisticVC.h"
#import "UIViewController+JDSideMenu.h"

@interface FXStatisticVC ()
{
    IBOutlet UILabel * suggestMatchLabel;
    IBOutlet UILabel * pendingMatchLabel;
    IBOutlet UILabel * successMatchLabel;
    IBOutlet UILabel * efficiencyLabel;
    
    IBOutlet UILabel * matchRevenueLabel;
    IBOutlet UILabel * referralRevenueLabel;
    IBOutlet UILabel * totalRevenueLabel;
    
    IBOutlet UIButton * bankButton;
}
@end

@implementation FXStatisticVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initStatisticView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initStatisticView
{
    bankButton.layer.cornerRadius = 8;
}


-(IBAction)onMenu:(id)sender
{
    if([self.sideMenuController isMenuVisible])
    {
        [self.sideMenuController hideMenuAnimated:YES];
    }else{
        [self.sideMenuController showMenuAnimated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
