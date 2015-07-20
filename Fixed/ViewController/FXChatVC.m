//
//  FXChatVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXChatVC.h"
#import "ChatMessageTableViewCell.h"

@interface FXChatVC ()<UITableViewDelegate, UITableViewDataSource, ChatServiceDelegate>
{
    IBOutlet UIImageView * userImageView;
    NSString * userId;
}

@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;


- (IBAction)sendMessage:(id)sender;

@end

@implementation FXChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messagesTableView.delegate =self;
    self.messagesTableView.dataSource = self;
    
    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [ChatMessageTableViewCell initialize];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [ChatService shared].delegate = self;
    
    // Set title
    if(self.dialog.type == QBChatDialogTypePrivate){
        QBUUser *recipient = [ChatService shared].usersAsDictionary[@(self.dialog.recipientID)];
        self.title = recipient.login == nil ? recipient.email : recipient.login;
    }else{
        self.title = self.dialog.name;
    }
    
    // Join room
    //
    if(self.dialog.type != QBChatDialogTypePrivate){
        [self joinDialog];
    }
    
    // sync messages history
    //
    [self syncMessages];
    
    [self initChatView];
}


-(void)initChatView
{
    userImageView.layer.cornerRadius = userImageView.frame.size.width/2;
 
    if ([self.match.user1_id isEqualToString:[FXUser sharedUser].fb_id]) {
        userId = self.match.user2_id;
    }else{
        userId = self.match.user1_id;
    }
    
    [userImageView setImageWithURL:[FXUser photoPathFromId:userId]];
    
}

-(IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [ChatService shared].delegate = nil;
    
    [self leaveDialog];
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)joinDialog{
    if(![[self.dialog chatRoom] isJoined]){
        [SVProgressHUD showWithStatus:@"Joining..."];
        
        [[ChatService shared] joinRoom:[self.dialog chatRoom] completionBlock:^(QBChatRoom *joinedChatRoom) {
            [SVProgressHUD dismiss];
        }];
    }
}

- (void)leaveDialog{
    [[self.dialog chatRoom] leaveRoom];
}

- (void)syncMessages{
    NSArray *messages = [[ChatService shared] messagsForDialogId:self.dialog.ID];
    NSDate *lastMessageDateSent = nil;
    if(messages.count > 0){
        QBChatAbstractMessage *lastMsg = [messages lastObject];
        lastMessageDateSent = lastMsg.datetime;
    }
    
    __weak __typeof(self)weakSelf = self;
    
    [QBRequest messagesWithDialogID:self.dialog.ID
                    extendedRequest:lastMessageDateSent == nil ? nil : @{@"date_sent[gt]": @([lastMessageDateSent timeIntervalSince1970])}
                            forPage:nil
                       successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *page) {
                           if(messages.count > 0){
                               [[ChatService shared] addMessages:messages forDialogId:self.dialog.ID];
                           }
                           
                           [weakSelf.messagesTableView reloadData];
                           NSInteger count = [[ChatService shared] messagsForDialogId:self.dialog.ID].count;
                           if(count > 0){
                               [weakSelf.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count-1 inSection:0]
                                                                 atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                           }
                       } errorBlock:^(QBResponse *response) {
                           
                       }];
}

#pragma mark
#pragma mark Actions

- (IBAction)sendMessage:(id)sender{
    if(self.messageTextField.text.length == 0){
        return;
    }
    
    // create a message
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.text = self.messageTextField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    // 1-1 Chat
    if(self.dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [self.dialog recipientID];
        message.senderID = [ChatService shared].currentUser.ID;
        
        [[ChatService shared] sendMessage:message];
        
        // save message
        [[ChatService shared] addMessage:message forDialogId:self.dialog.ID];
        
        // Group Chat
    }else {
        [[ChatService shared] sendMessage:message toRoom:[self.dialog chatRoom]];
    }
    
    // Reload table
    [self.messagesTableView reloadData];
    if([[ChatService shared] messagsForDialogId:self.dialog.ID].count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:self.dialog.ID] count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // Clean text field
    [self.messageTextField setText:nil];
}


#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ChatService shared] messagsForDialogId:self.dialog.ID] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    if(cell == nil){
        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
    }
    
    QBChatAbstractMessage *message = [[ChatService shared] messagsForDialogId:self.dialog.ID][indexPath.row];
    //
    [cell configureCellWithMessage:message];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QBChatAbstractMessage *chatMessage = [[[ChatService shared] messagsForDialogId:self.dialog.ID] objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        self.messageTextField.transform = CGAffineTransformMakeTranslation(0, -250);
        self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -250);
        self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.frame.size.width,
                                                  self.messagesTableView.frame.size.height-252);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
        self.messageTextField.transform = CGAffineTransformIdentity;
        self.sendMessageButton.transform = CGAffineTransformIdentity;
        self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.frame.size.width,
                                                  self.messagesTableView.frame.size.height+252);
    }];
}


#pragma mark
#pragma mark ChatServiceDelegate

- (void)chatDidLogin{
    [self joinDialog];
    
    // sync messages history
    //
    [self syncMessages];
}

- (BOOL)chatDidReceiveMessage:(QBChatMessage *)message{
    
    if(message.senderID != self.dialog.recipientID){
        return NO;
    }
    
    // save message
    [[ChatService shared] addMessage:message forDialogId:self.dialog.ID];
    
    // Reload table
    [self.messagesTableView reloadData];
    if([[ChatService shared] messagsForDialogId:self.dialog.ID].count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:self.dialog.ID] count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return YES;
}

- (BOOL)chatRoomDidReceiveMessage:(QBChatMessage *)message fromRoomJID:(NSString *)roomJID{
    if(![[self.dialog chatRoom].JID isEqualToString:roomJID]){
        return NO;
    }
    
    // save message
    [[ChatService shared] addMessage:message forDialogId:self.dialog.ID];
    
    // Reload table
    [self.messagesTableView reloadData];
    if([[ChatService shared] messagsForDialogId:self.dialog.ID].count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[[ChatService shared] messagsForDialogId:self.dialog.ID] count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return YES;
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
