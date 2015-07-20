//
//  FXMatchPreferenceVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMatchPreferenceVC.h"
#import "UIViewController+JDSideMenu.h"
#import "MARKRangeSlider.h"

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
    
    IBOutlet MARKRangeSlider * ageSlider;
    IBOutlet UILabel * ageUpperLabel;
    IBOutlet UILabel * ageLowerLabel;
    
    IBOutlet MARKRangeSlider * heightSlider;
    IBOutlet UILabel * heightUpperLabel;
    IBOutlet UILabel * heightLowerLabel;
    
    // Value
    
 //   BOOL editFlag;
    
    BOOL sexFlag;
    BOOL interestFlag;
    BOOL singleFlag;
    int  religionFlag;
    
    NSString *zipCode;
    int distanceRange;
    int leftAge;
    int rightAge;
    int leftHeight;
    int rightHeight;
    
    float distanceSliderScale;
    
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
    
    
    [helpView setHidden:YES];
    
    helpView.layer.cornerRadius = 3;
    helpView.layer.borderColor = FIXED_LIGHT_GRAY_COLOR.CGColor;
    helpView.layer.borderWidth = 1.5;
    
    zipCodeTextField.delegate = self;
    
//    editFlag = YES;
    
     FXUser * user = [FXUser sharedUser];
    
    
    sexFlag = user.is_man;
    interestFlag = user.is_interested_man;
    singleFlag = user.is_single;
    religionFlag = user.religion_priority;
    
    zipCode = user.zipcode;
    distanceRange = user.distance_range;
    
    leftAge = user.min_age <18  ?24 :user.min_age;
    rightAge = user.max_age <18 ? 31:user.max_age;
    leftHeight = user.min_height  <450 ?510:user.min_height ;
    rightHeight = user.max_height <450 ? 650:user.max_height;
    
    [self configSex];
    [self configInterest];
    [self configSingle];
    [self configReligion];
    
    zipCodeTextField.text = zipCode;
    
    distanceSlider.minimumValue = 0;
    distanceSlider.maximumValue = 500;
    
    distanceSliderScale = (distanceSlider.frame.size.width) /500;
    
    distanceSlider.value =  distanceRange;
    
    [self updateDistanceLabel];
    
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
  //  editFlag = !editFlag;
 //   if (editFlag) {
  //      [editButton setTitle:@"Done" forState:UIControlStateNormal];
 //           [doneView setHidden:YES];
//    }else{
 //       [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [zipCodeTextField resignFirstResponder];
//        [doneView setHidden:NO];
        
        NSString  * postStr  = [NSString stringWithFormat:@"is_man=%i&is_interested_man=%i&is_single=%i&religion_priority=%i&match_zipcode=%@&distance_range=%i&min_age=%i&max_age=%i&min_height=%i&max_height=%i",sexFlag, interestFlag, singleFlag, religionFlag, zipCodeTextField.text, (int)distanceSlider.value,leftAge,rightAge, leftHeight, rightHeight];
        
       if([[FXUser sharedUser] saveMatchReference:postStr withView:self.view])
          {
              FXUser * user = [FXUser sharedUser];
              user.is_man = sexFlag;
              user.is_interested_man = interestFlag;
              user.is_single = singleFlag;
              user.religion_priority = religionFlag;
              user.match_zipcode = zipCodeTextField.text;
              user.distance_range = (int)distanceSlider.value;
              user.min_age = leftAge;
              user.max_age = rightAge;
              user.min_height = leftHeight;
              user.max_height = rightHeight;
          }else{
              [[[UIAlertView alloc] initWithTitle:@"" message:@"Failed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show ];
          }
 //   }

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
    sexFlag = YES;
    [self configSex];
}

-(IBAction)onSexWoman:(id)sender
{
    sexFlag = NO;
    [self configSex];
}

-(void)configSex{
    
    if (sexFlag) {
        sex_man_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        sex_woman_button.backgroundColor = [UIColor clearColor];
    }else{
        sex_man_button.backgroundColor = [UIColor clearColor];
        sex_woman_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
    }
}
    
-(IBAction)onInterestMen:(id)sender
{
    interestFlag = YES;
    [self configInterest];
}

-(IBAction)onInterestWomen:(id)sender
{
     interestFlag = NO;
    [self configInterest];
}

-(void)configInterest{
    
    if (interestFlag) {
        interest_men_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        interest_women_button.backgroundColor = [UIColor clearColor];
    }else{
        interest_men_button.backgroundColor = [UIColor clearColor];
        interest_women_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
    }
}


-(IBAction)onSingleYes:(id)sender
{
    singleFlag = YES;
    [self configSingle];
}

-(IBAction)onSingleNo:(id)sender
{
    singleFlag = NO;
    [self configSingle];
}

-(void)configSingle{
    
    if (singleFlag) {
        single_yes_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        single_no_button.backgroundColor = [UIColor clearColor];
    }else{
        single_yes_button.backgroundColor = [UIColor clearColor];
        single_no_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
    }
}


-(IBAction)onReligionNot:(id)sender
{
    religionFlag = 0;
    [self configReligion];
}


-(IBAction)onReligionKind:(id)sender
{
    religionFlag = 1;
    [self configReligion];
}


-(IBAction)onReligionVery:(id)sender
{
    religionFlag = 2;
    [self configReligion];
}

-(void)configReligion{
    
    if (religionFlag == 0) {
        religion_not_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        religion_kind_button.backgroundColor = [UIColor clearColor];
        religion_very_button.backgroundColor = [UIColor clearColor];
    }else if(religionFlag == 1){
        religion_not_button.backgroundColor =  [UIColor clearColor];
        religion_kind_button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        religion_very_button.backgroundColor = [UIColor clearColor];
    }else if(religionFlag == 2){
        religion_not_button.backgroundColor = [UIColor clearColor];
        
        religion_kind_button.backgroundColor = [UIColor clearColor];
        religion_very_button.backgroundColor =FIXED_LIGHT_GRAY_COLOR;
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



-(IBAction)onChangeDistance:(id)sender{
   
    [self updateDistanceLabel];
}

- (void) configureAgeSlider
{
    [ageSlider addTarget:self
                         action:@selector(updateAgeSliderLabels)
               forControlEvents:UIControlEventValueChanged];
    
    ageSlider.minimumValue = 0;
    ageSlider.maximumValue = 37;
    
    ageSlider.leftValue = leftAge - 18;
    ageSlider.rightValue = rightAge - 18;
    
    ageSlider.minimumDistance = 2;
    [ageSlider layoutSubviews];
    [self updateAgeSliderLabels];
}

- (void) updateAgeSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter = ageLowerLabel.center;
    lowerCenter.x = (ageSlider.leftThumbImageView.center.x + ageSlider.frame.origin.x);
    ageLowerLabel.center = lowerCenter;
    ageLowerLabel.text = [NSString stringWithFormat:@"%d", 18 + (int)ageSlider.leftValue];
    leftAge = 18 + (int)ageSlider.leftValue;
    
    CGPoint upperCenter = ageUpperLabel.center;
    upperCenter.x = (ageSlider.rightThumbImageView.center.x +ageSlider.frame.origin.x);

    ageUpperLabel.center = upperCenter;
    ageUpperLabel.text = [NSString stringWithFormat:@"%d", 18 + (int)ageSlider.rightValue];
    
    rightAge = 18 + (int)ageSlider.rightValue;
}


- (void) configureHeightSlider
{
    
    [heightSlider addTarget:self
                  action:@selector(updateHeightSliderLabels)
        forControlEvents:UIControlEventValueChanged];
    
    heightSlider.minimumValue = 0;
    heightSlider.maximumValue = 260;
    
    heightSlider.leftValue = leftHeight - 450;
    heightSlider.rightValue = rightHeight - 450;
    
    heightSlider.minimumDistance = 1;
    
    [heightSlider layoutSubviews];
    [self updateHeightSliderLabels];
}

- (void) updateHeightSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter = heightLowerLabel.center;
    lowerCenter.x = (heightSlider.leftThumbImageView.center.x + heightSlider.frame.origin.x);
    
    heightLowerLabel.center = lowerCenter;
    int lowValue = 450 + (int)heightSlider.leftValue;
    heightLowerLabel.text = [NSString stringWithFormat:@"%i'%i\"", lowValue/100, lowValue%100];
    leftHeight = lowValue;
    
    CGPoint upperCenter = heightUpperLabel.center;
    upperCenter.x = (heightSlider.rightThumbImageView.center.x +heightSlider.frame.origin.x);
   heightUpperLabel.center = upperCenter;
    
    int upperValue =  450 + (int)heightSlider.rightValue;
    heightUpperLabel.text = [NSString stringWithFormat:@"%i'%i\"", upperValue/100, upperValue%100];
    rightHeight = upperValue;
}


-(void)updateDistanceLabel{
    
    distanceRange = (int)distanceSlider.value;
    distanceLabel.text = [NSString stringWithFormat:@"%i", distanceRange];
    
    float deltaX = distanceRange * distanceSliderScale;
    
    CGRect rect = distanceLabel.frame;
    rect.origin.x = distanceSlider.frame.origin.x + deltaX - 12;
    
    [distanceLabel setFrame:rect];
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
