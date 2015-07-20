//
//  FXBankVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXBankVC.h"
#import "UIViewController+JDSideMenu.h"

@interface FXBankVC ()
{
    IBOutlet UILabel * myBankAccountLabel;
    
    IBOutlet UIView *purchaseView;
    IBOutlet UIView * purchaseSubView;
    
    IBOutlet UIButton * redeemButton1;
    IBOutlet UIButton * redeemButton2;
    IBOutlet UIButton * redeemButton3;
}
@end

@implementation FXBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBankView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initBankView
{
    purchaseView.hidden = YES;
    purchaseSubView.layer.borderWidth = 1.5;
    purchaseSubView.layer.borderColor = FIXED_GREEN_COLOR.CGColor;
    purchaseSubView.layer.cornerRadius = 10;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(closePurchaseView:)];
    [purchaseView addGestureRecognizer:gesture];
    
    redeemButton1.layer.cornerRadius = 5;
    redeemButton2.layer.cornerRadius = 5;
    redeemButton3.layer.cornerRadius = 5;
    
    myBankAccountLabel.text = [NSString stringWithFormat:@"$%.2f", self.fixedBank];
    
}


-(IBAction)onMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
//    if([self.sideMenuController isMenuVisible])
//    {
//        [self.sideMenuController hideMenuAnimated:YES];
//    }else{
//        [self.sideMenuController showMenuAnimated:YES];
//    }
}


-(void)closePurchaseView:(UITapGestureRecognizer *)gesture
{
    CGPoint  point = [gesture locationInView:purchaseView];
    
    if (!CGRectContainsPoint(purchaseSubView.frame, point)) {
        purchaseView.hidden = YES;
    }
}

-(IBAction)onRedeem:(id)sender
{
    UIButton * button = (UIButton *)sender;
    
    double redeemAmount = 0;
    NSInteger coinCount = 0;
    if (button == redeemButton1) {
        coinCount = 1;
        redeemAmount = COIN_1;
    }else if(button == redeemButton2)
    {
        coinCount =5;
        redeemAmount = COIN_5;
    }else if(button == redeemButton3){
        coinCount = 10;
        redeemAmount = COIN_10;
    }
    
    if (self.fixedBank < redeemAmount) {
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"You can not redeem %i coins. Please check your FixedBank and  try again !", coinCount] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show ];
        
    }else{
    
        [self redeemCoins:coinCount];
    }
}

-(void)redeemCoins:(NSInteger )coinCount
{
    
    
    NSString * keyStr = [NSString stringWithFormat:@"%@_withdrawcoin", [FXUser sharedUser].fb_id];
    [[NSUserDefaults standardUserDefaults] setInteger:coinCount  forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BOOL result =   [[FXUser sharedUser] withdrawCoin:self.view];
    
    if (result) {
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"You redeemed %i coins", coinCount] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
    }
}

-(IBAction)onRedeemForCoin:(id)sender
{
    [purchaseView setHidden:NO];
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
