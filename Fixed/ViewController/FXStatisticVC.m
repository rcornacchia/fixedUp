//
//  FXStatisticVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXStatisticVC.h"
#import "UIViewController+JDSideMenu.h"
#import "FXBankVC.h"

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
    
    NSDictionary * statisticsData;
    
    double totalBank;
    
    double  match_revenue;
    double  referral_revenue;
    
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

    suggestMatchLabel.text = @"";
    pendingMatchLabel.text = @"";
    successMatchLabel.text = @"";
    efficiencyLabel.text  = @"";
    
    matchRevenueLabel.text = @"";
    referralRevenueLabel.text = @"";
    totalRevenueLabel.text = @"";
    
   }

-(void)loadingData{
    
    statisticsData = [[FXUser sharedUser] getStatisticsData:self.view];
    
    if (statisticsData != nil ) {
        int   suggested_matches = [[statisticsData objectForKey:@"suggested_matches"] intValue];
        int   successful_matches = [[statisticsData objectForKey:@"successful_matches"] intValue];
        int   pending_matches = [[statisticsData objectForKey:@"pending_matches"] intValue];
        
        match_revenue = [[statisticsData objectForKey:@"match_revenue"] doubleValue];
        referral_revenue = [[statisticsData objectForKey:@"referral_revenue"] doubleValue];
        
        if (suggested_matches != 0) {
            suggestMatchLabel.text = [NSString stringWithFormat:@"%i", suggested_matches];
            pendingMatchLabel.text = [NSString stringWithFormat:@"%i", pending_matches];
            successMatchLabel.text = [NSString stringWithFormat:@"%i", successful_matches];
            efficiencyLabel.text  = [NSString stringWithFormat:@"%.2f%%", (successful_matches/(float)suggested_matches) * 100];
        }
        
        
        matchRevenueLabel.text = [NSString stringWithFormat:@"$%.2f", match_revenue];
        referralRevenueLabel.text = [NSString stringWithFormat:@"$%.2f", referral_revenue];
        
        totalBank = match_revenue + referral_revenue;
        
        totalRevenueLabel.text = [NSString stringWithFormat:@"$%.2f", totalBank];
        
    }

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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotoBank"]) {
        FXBankVC * vc = (FXBankVC *)segue.destinationViewController;
        vc.fixedBank = match_revenue;
    }
}


@end
