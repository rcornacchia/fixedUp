//
//  FXEditProfileVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXEditProfileVC.h"

@interface FXEditProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
{
    IBOutlet UIScrollView * editScrollView;
    IBOutlet UIView * editView;
    
    IBOutlet UIImageView * profileImageView1;
    IBOutlet UIImageView * profileImageView2;
    IBOutlet UIImageView * profileImageView3;
    IBOutlet UIImageView * profileImageView4;
    IBOutlet UIImageView * profileImageView5;
    
    IBOutlet UIButton *addButton1;
    IBOutlet UIButton *addButton2;
    IBOutlet UIButton *addButton3;
    IBOutlet UIButton *addButton4;
    IBOutlet UIButton *addButton5;
    
    IBOutlet UITextField * taglineTextField;
    IBOutlet UISlider * heightSlider;
    IBOutlet UILabel * heightLabel;
    
    NSArray * imageViews;
    NSArray * addButtons;
    NSInteger  activeProfileImageIndex;
    
    IBOutlet UIButton * religionButton1;
    IBOutlet UIButton * religionButton2;
    IBOutlet UIButton * religionButton3;
    IBOutlet UIButton * religionButton4;
    IBOutlet UIButton * religionButton5;
    IBOutlet UIButton * religionButton6;
    IBOutlet UIButton * religionButton7;
    IBOutlet UIButton * religionButton8;
    IBOutlet UIButton * religionButton9;
    IBOutlet UIButton * religionButton10;

    NSArray *religions;
}

@end

@implementation FXEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initEditView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initEditView
{
    [editScrollView setContentSize:editView.frame.size];
    [editScrollView setContentOffset:CGPointZero];

    imageViews  = [[NSArray alloc] initWithObjects:profileImageView1, profileImageView2, profileImageView3, profileImageView4, profileImageView5, nil];
    
    addButtons = @[addButton1, addButton2, addButton3, addButton4, addButton5];
    
    religions = @[religionButton1, religionButton2, religionButton3, religionButton4,religionButton5,religionButton6,religionButton7,religionButton8,religionButton9,religionButton10];
    
    for (UIImageView * tempView in imageViews) {
        tempView.layer.cornerRadius = 3;
        tempView.layer.borderColor = FIXED_LIGHT_GRAY_COLOR.CGColor;
        tempView.layer.borderWidth = 1.5;
        
    }
    
    taglineTextField.delegate = self;
    
    heightSlider.minimumValue = 45;
    heightSlider.maximumValue = 71;
    
    heightSlider.value = 58;
    heightLabel.text = @"5'8\"";
    
    for (UIButton * button in religions) {
        button.layer.cornerRadius = button.frame.size.height /2;
        
    }
    
    [self onReligion:religionButton1];
    
}


-(IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onSave:(id)sender
{
    [self onCancel:nil];
}

-(IBAction)onAddPhoto:(id)sender
{
    UIButton * button = (UIButton *)sender;
    activeProfileImageIndex = [addButtons indexOfObject:button];
   
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"Photo Library" ,nil];
    [actionSheet showInView:self.view];
    
}

// Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self onAddImageFromCamera];
    }else if (buttonIndex == 1)
    {
        [self onAddImageFromLibrary];
    }
}


- (void)onAddImageFromCamera
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (void)onAddImageFromLibrary
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

//// Image Picker Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!resultImage) {
            resultImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        UIImageView * tempView = (UIImageView *) [imageViews objectAtIndex:activeProfileImageIndex];
        [tempView setImage:resultImage];
        
     }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


// TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [editScrollView setContentOffset:CGPointMake(0, 140)];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [editScrollView setContentOffset:CGPointMake(0, 0)];
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)onChangeHeight:(id)sender
{
    int value = (int)heightSlider.value;
    NSString * heightStr ;
    int  digit = value/10;
    int f =  value%10;
    
    if (f == 0) {
        heightStr = [NSString stringWithFormat:@"%i'", digit];
    }else{
        heightStr = [NSString stringWithFormat:@"%i'%i\"", digit, f];
    }
    heightLabel.text = heightStr;
    
}

-(IBAction)onReligion:(id)sender
{
    UIButton * tempButton = (UIButton *)sender;
    
    for (UIButton * button in religions) {
        if (button == tempButton) {
            button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

@end


