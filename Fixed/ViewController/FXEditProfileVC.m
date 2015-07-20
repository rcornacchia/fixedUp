//
//  FXEditProfileVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXEditProfileVC.h"
#import "JCTagListView.h"

@interface FXEditProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate>
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
    
    int selected_religion;
    
    IBOutlet JCTagListView * tagListView;
    
    BOOL isChangePhotos;
    
    float heightSliderScale;
    
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
    
    isChangePhotos = NO;
    
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
    
    heightSlider.minimumValue = 450;
    heightSlider.maximumValue = 710;
    
    heightSliderScale = (heightSlider.frame.size.width) /260;
    
    for (UIButton * button in religions) {
        button.layer.cornerRadius = button.frame.size.height /2;
        
    }
    
    // Set Value
    
    NSString * tempImagePath ;
    UIImageView * tempImageview;
    UIButton * tempButton;
    
    for (int i = 0 ; i < [imageViews count] ; i++) {
         tempImageview = [imageViews objectAtIndex:i];
        tempButton = [addButtons objectAtIndex:i];
        if (i < [self.user.photo_paths count]) {
            tempImagePath = [self.user.photo_paths objectAtIndex:i];
           
            [tempImageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APP_RESOURCE_PATH, tempImagePath]]];
            [tempImageview setUserInteractionEnabled:YES];
            [tempButton setHidden:YES];
        }else{
            [tempImageview setUserInteractionEnabled:NO];
            [tempButton setHidden:NO];
        }
        
    }
    
    taglineTextField.text = self.user.tageline;
    heightSlider.value = self.user.height;
    [self onChangeHeight:nil];
    
    selected_religion = self.user.religion;
    [self onReligion:[religions objectAtIndex:selected_religion]];
    
    // TagList Initinalize
    
    [tagListView setCanSeletedTags:YES];
    [tagListView.tags addObjectsFromArray:TAG_LIST];
    [tagListView.seletedTags addObjectsFromArray:self.user.interest];
    [tagListView setCompletionBlockWithSeleted:^(NSInteger index) {
        
    }];
    
    
}


-(IBAction)onCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onSave:(id)sender
{
    if (tagListView.seletedTags == nil || [tagListView.seletedTags count] < 5 ) {
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Please Choose 5+ Tags!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show ];
        return;
    }
    
    MBProgressHUD * mhud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mhud.labelText = @"Saving...";
    NSMutableArray * photos_paths = self.user.photo_paths;
    if (isChangePhotos) {
        NSMutableArray * tempArray = [[NSMutableArray alloc] init];
        for (UIImageView * tempView in imageViews) {
            if (tempView.image != nil && tempView.image.size.width != 0 && tempView.image.size.height != 0) {
                [tempArray addObject:tempView.image];
            }
        }
        
        if ([tempArray count] != 0 ) {
           photos_paths = [self.user uploadImage:tempArray withFlag:NO] ;
        }
    }
    
    SBJsonWriter * writer = [SBJsonWriter new];
    NSString * photoPathStr =  [writer stringWithObject:photos_paths];
    NSString * selectedTags = [writer stringWithObject:tagListView.seletedTags];
    
    NSString * postStr = [NSString stringWithFormat:@"tagline=%@&height=%i&religion=%i&photo_path=%@&interest=%@",taglineTextField.text, (int)heightSlider.value, selected_religion, photoPathStr, selectedTags];
    
    if (![self.user saveUserProfile:postStr withView:self.view]) {
        
       [[[UIAlertView alloc] initWithTitle:@"" message:@"Can not save data .Connection Failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }else{
        self.user.tageline = taglineTextField.text;
        self.user.height = (int)heightSlider.value;
        self.user.religion = selected_religion;
        self.user.photo_paths = photos_paths;
        self.user.interest = tagListView.seletedTags;
    }
    
    
    [self onCancel:nil];
}

-(IBAction)onAddPhoto:(id)sender
{
    UIButton * button = (UIButton *)sender;
    activeProfileImageIndex = [addButtons indexOfObject:button];
   
    [self showAddPhotoSheet];
}

-(void)showAddPhotoSheet{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"Photo Library" ,nil];
    actionSheet.tag = 1000;
    [actionSheet showInView:self.view];

}

-(IBAction)tapPhotos:(UITapGestureRecognizer *)gesture{
    
    UIView * gestureView = gesture.view;
    
    if ([gestureView isKindOfClass:[UIImageView class]]) {
        
        activeProfileImageIndex = [imageViews indexOfObject:gestureView];
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Delete", @"Change Photo" ,nil];
        actionSheet.tag = 1001;
        [actionSheet showInView:self.view];
    }

}

// Actionsheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0) {
            [self onAddImageFromCamera];
        }else if (buttonIndex == 1)
        {
            [self onAddImageFromLibrary];
        }
    }else if(actionSheet.tag == 1001){
        if (buttonIndex == 0) {
            [self removePhoto];   ///  Remove Photos
        }else if (buttonIndex == 1)
        {
            [self showAddPhotoSheet];
        }
    }
   
}

-(void)removePhoto{
    
    UIImageView * tempImageView = [imageViews objectAtIndex:activeProfileImageIndex];
    [tempImageView setImage:nil];
    
    [tempImageView setUserInteractionEnabled:NO];
    
    UIButton * tempButton = [addButtons objectAtIndex:activeProfileImageIndex];
    [tempButton setHidden:NO];
    
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
        [tempView setUserInteractionEnabled:YES];
        
        UIButton *tempButton = [addButtons objectAtIndex:activeProfileImageIndex];
        [tempButton setHidden:YES];
        
        isChangePhotos = YES;
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
    int  digit = value/100;
    int f =  value%100;
    
    if (f == 0) {
        heightStr = [NSString stringWithFormat:@"%i'", digit];
    }else{
        heightStr = [NSString stringWithFormat:@"%i'%i\"", digit, f];
    }
    heightLabel.text = heightStr;
    
    int tempValue = value - 450;
    float deltaX = tempValue * heightSliderScale;
    
    CGRect temp_rect = heightLabel.frame;
    temp_rect.origin.x = heightSlider.frame.origin.x + deltaX - 16;
    [heightLabel setFrame:temp_rect];
    
}



-(IBAction)onReligion:(id)sender
{
    UIButton * tempButton = (UIButton *)sender;
    
    for (UIButton * button in religions) {
        if (button == tempButton) {
            button.backgroundColor = FIXED_LIGHT_GRAY_COLOR;
            selected_religion = (int)[religions indexOfObject:button];
        }else{
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

@end


