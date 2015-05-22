//
//  FXMatchPreferenceVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMatchPreferenceVC.h"
#import "UIViewController+JDSideMenu.h"
#import "NMRangeSlider.h"


@interface FXMatchPreferenceVC ()<UITextFieldDelegate>
{
    
    IBOutlet UIButton * editButton;
    
    IBOutlet UIView * doneView;
    IBOutlet UIView * helpView;
    
    
    IBOutlet UIButton *sex_man_button;
    IBOutlet UIButton *sex_woman_button;
    
    IBOutlet UIButton *interest_men_button;
    IBOutlet UIButton *interest_women_button;
    
    IBOutlet UIButton *single_yes_button;
    IBOutlet UIButton *single_no_button;
    
    IBOutlet UIButton *religion_not_button;
    IBOutlet UIButton *religion_kind_button;
    IBOutlet UIButton *religion_very_button;
    
    IBOutlet UITextField * zipCodeTextField;
    
    IBOutlet  UISlider * distanceSlider;
    IBOutlet UILabel * distanceLabel;
    
    IBOutlet NMRangeSlider * ageSlider;
    IBOutlet UILabel * ageUpperLabel;
    IBOutlet UILabel * ageLowerLabel;
    
    IBOutlet NMRangeSlider * heightSlider;
    IBOutlet UILabel * heightUpperLabel;
    IBOutlet UILabel * heightLowerLabel;
    
    // Value
    
    BOOL editFlag;
    BOOL sexFlag;
    BOOL interestFlag;
    BOOL singleFlag;
    int  religionFlag;
    
    
}
@end

@implementation FXMatchPreferenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPreferenceView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPreferenceView
{
    sex_man_button.layer.cornerRadius = 10;
    sex_woman_button.layer.cornerRadius = 10;
    
    interest_men_button.layer.cornerRadius = 10;
    interest_women_button.layer.cornerRadius = 10;
    
    single_yes_button.layer.cornerRadius = 10;
    single_no_button.layer.cornerRadius = 10;
    
    religion_not_button.layer.cornerRadius = 10;
    religion_kind_button.layer.cornerRadius = 10;
    religion_very_button.layer.cornerRadius = 10;
    
    editFlag = YES;
    sexFlag = NO;
    interestFlag = NO;
    singleFlag = NO;
    religionFlag = 2;
    
    [self onSexMan:nil];
    [self onInterestMen:nil];
    [self onSingleYes:nil];
    [self onReligionNot:nil];
 
    [self onEdit:nil];
    
    [helpView setHidden:YES];

    helpView.layer.cornerRadius = 3;
    helpView.layer.borderColor = FIXED_LIGHT_GRAY_COLOR.CGColor;
    helpView.layer.borderWidth = 1.5;
    
    zipCodeTextField.delegate = self;
    
    [self configureAgeSlider];
    [self configureHeightSlider];
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

-(IBAction)onEdit:(id)sender
{
    editFlag = !editFlag;
    if (editFlag) {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
            [doneView setHidden:YES];
    }else{
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [zipCodeTextField resignFirstResponder];
        [doneView setHidden:NO];
    }

}

-(IBAction)showHelpView:(id)sender
{
    [helpView setHidden:NO];
}

-(IBAction)onCloseHelpView:(id)sender
{
    [helpView setHidden:YES];
}

// Edit Method
-(IBAction)onSexMan:(id)sender
{
    if (!sexFlag) {
            sex_man_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        sex_woman_button.backgroundColor = [UIColor clearColor];
        sexFlag = YES;
    }
}

-(IBAction)onSexWoman:(id)sender
{
    if (sexFlag)
   {
        sex_man_button.backgroundColor = [UIColor clearColor];
        sex_woman_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
       sexFlag = NO;
    }
    
}

    
-(IBAction)onInterestMen:(id)sender
{
    if (!interestFlag) {
        interest_men_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        interest_women_button.backgroundColor = [UIColor clearColor];
        interestFlag = YES;
    }
}

-(IBAction)onInterestWomen:(id)sender
{
    if (interestFlag)
    {
            interest_men_button.backgroundColor = [UIColor clearColor];
            interest_women_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
            interestFlag = NO;
    }
        
    }


-(IBAction)onSingleYes:(id)sender
{
    if (!singleFlag) {
        single_yes_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        single_no_button.backgroundColor = [UIColor clearColor];
        singleFlag = YES;
    }
}

-(IBAction)onSingleNo:(id)sender
{
    if (singleFlag)
    {
        single_yes_button.backgroundColor = [UIColor clearColor];
        single_no_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        singleFlag = YES;
    }
    
}


-(IBAction)onReligionNot:(id)sender
{
    if (religionFlag != 0) {
        religion_not_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        religion_kind_button.backgroundColor = [UIColor clearColor];
        religion_very_button.backgroundColor = [UIColor clearColor];
        religionFlag = 0;
    }
}


-(IBAction)onReligionKind:(id)sender
{
    if (religionFlag != 1) {
        religion_not_button.backgroundColor =  [UIColor clearColor];
        religion_kind_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        religion_very_button.backgroundColor = [UIColor clearColor];
        religionFlag = 1;
    }
}


-(IBAction)onReligionVery:(id)sender
{
    if (religionFlag != 2) {
        religion_not_button.backgroundColor = [UIColor clearColor];

        religion_kind_button.backgroundColor = [UIColor clearColor];
        religion_very_button.backgroundColor =FIXED_LIGHT_GRAY_COLOR;
        religionFlag = 2;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void) configureAgeSlider
{
    ageSlider.minimumValue = 18;
    ageSlider.maximumValue = 55;
    
    ageSlider.lowerValue = 24;
    ageSlider.upperValue = 31;
    
    ageSlider.minimumRange = 5;
}

- (void) updateAgeSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (ageSlider.lowerCenter.x + ageSlider.frame.origin.x);
    lowerCenter.y = (ageSlider.center.y + 30.0f);
    ageLowerLabel.center = lowerCenter;
    ageLowerLabel.text = [NSString stringWithFormat:@"%d", (int)ageSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (ageSlider.upperCenter.x +ageSlider.frame.origin.x);
    upperCenter.y = (ageSlider.center.y + 30.0f);
    ageUpperLabel.center = upperCenter;
    ageUpperLabel.text = [NSString stringWithFormat:@"%d", (int)ageSlider.upperValue];
}


- (IBAction)ageSliderChanged:(NMRangeSlider*)sender
{
  //  [self updateAgeSliderLabels];
}



- (void) configureHeightSlider
{
    heightSlider.minimumValue = 45;
    heightSlider.maximumValue = 71;
    
    heightSlider.lowerValue = 51;
    heightSlider.upperValue = 61;
    
    heightSlider.minimumRange = 2;
}

- (void) updateHeightSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (heightSlider.lowerCenter.x + heightSlider.frame.origin.x);
    lowerCenter.y = (heightSlider.center.y +30.0f);
    ageLowerLabel.center = lowerCenter;
    int lowValue = (int)heightSlider.lowerValue;
    ageLowerLabel.text = [NSString stringWithFormat:@"%i'%i\"", lowValue/10, lowValue%10];
    
    CGPoint upperCenter;
    upperCenter.x = (heightSlider.upperCenter.x +heightSlider.frame.origin.x);
    upperCenter.y = (heightSlider.center.y + 30.0f);
   ageUpperLabel.center = upperCenter;
    
    int upperValue = (int)heightSlider.upperValue;
    ageUpperLabel.text = [NSString stringWithFormat:@"%i'%i\"", upperValue/10, upperValue%10];
    
}


- (IBAction)heightSliderChanged:(NMRangeSlider*)sender
{
  //  [self updateHeightSliderLabels];
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
