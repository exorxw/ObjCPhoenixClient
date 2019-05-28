//
//  PhxViewController.m
//  ObjCPhoenixClient
//
//  Created by 362922604@qq.com on 11/26/2018.
//  Copyright (c) 2018 362922604@qq.com. All rights reserved.
//

#import "PhxViewController.h"
#import <ObjCPhoenixClient/PhoenixClient.h>
#import <YYModel/YYModel.h>
#import "PhxTextMsgInCell.h"
#import "PhxTextMsgOutCell.h"
#import "PhxUserManager.h"
#import <BlocksKit/BlocksKit.h>

NSString * const PhxUserToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcHBpZCI6ImJBNWw1TEJmZlB3YyIsImF1ZCI6Ikpva2VuIiwiZXhwIjoxNTQ1OTc5NTE5LCJpYXQiOjE1NDMzODc1MTksImlzcyI6InljIGltIiwianRpIjoiMmxsamRoYnYwbmZoazVzMDU0MDAwMTExIiwibmJmIjoxNTQzMzg3NTE5LCJ1aWQiOiJPV05FUl82NiJ9.QstffCa-JeFJlpkjsbXn8bvL2PMoqfR6W_EzaufmW8A";
NSString * const PhxAppID = @"bA5l5LBffPwc";

NSString * const PhxSendToUserId = @"OWNER_1";

// 收发新消息
NSString * const PhxMessageNewEvent = @"msg:new";
// 收离线消息
NSString * const PhxMessageOfflineEvent = @"msg:offline";
// 发ack消息
NSString * const PhxMessageAckEvent = @"msg:ack";

@interface PhxViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PhxSocket *socket;
@property (nonatomic, strong) PhxChannel *channel;

@property (nonatomic, strong) NSMutableArray *msgArray;

@end

@implementation PhxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.msgArray = [NSMutableArray arrayWithCapacity:1];
    self.msgTableView.rowHeight = UITableViewAutomaticDimension;
    self.msgTableView.tableFooterView = [UIView new];
    [self phoenixConnect];
}

#pragma mark - Socket & channel

- (void)phoenixConnect {
    if (self.socket != nil && [self.socket isConnected]) {
        return;
    }
    // @"http://192.168.1.230:4000/socket/websocket"
    NSString *host = @"http://192.168.1.71/socket/websocket";
    self.socket = [[PhxSocket alloc] initWithURL:[NSURL URLWithString:host]
                               heartbeatInterval:20];
    [self.socket connectWithParams:@{@"p":@"iOS", @"token": PhxUserToken}];
    NSString *topic = [NSString stringWithFormat:@"user:%@%@", PhxAppID, [PhxUserManager currentUser].uid];
    self.channel = [[PhxChannel alloc] initWithSocket:self.socket topic:topic params:@{}];
    
    // 收到新消息
    [self.channel onEvent:PhxMessageNewEvent callback:^(id message, id ref) {
        NSLog(@"New Message Received: %@", message);
        PhxMessage *inMsg = [PhxMessage yy_modelWithJSON:message[@"message"]];
        if (inMsg) {
            [self.msgArray addObject:inMsg];
            [self reloadMsgUI];
            [self sendMsgAck:@[inMsg]];
        }
    }];
    
    // 收到离线消息
    [self.channel onEvent:PhxMessageOfflineEvent callback:^(id message, id ref) {
        NSLog(@"Offline Message Received: %@", message);
        NSArray<PhxMessage *> *msgs = [NSArray yy_modelArrayWithClass:PhxMessage.class json:message[@"messages"]];
        if (msgs.count > 0) {
            [self.msgArray addObjectsFromArray:msgs];
            [self reloadMsgUI];
            [self sendMsgAck:msgs];
        }
    }];
    
    [self.channel join];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id msg = self.msgArray[indexPath.row];
    if ([msg isKindOfClass:PhxMessage.class]) {
        PhxMessage *phxMsg = (PhxMessage *)msg;
        if (phxMsg.dispatchType == PhxMessageDispatchTypeIn) {
            PhxTextMsgInCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhxTextMsgInCell" forIndexPath:indexPath];
            [cell configMsgCell:phxMsg];
            return cell;
        } else if (phxMsg.dispatchType == PhxMessageDispatchTypeOut) {
            PhxTextMsgOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhxTextMsgOutCell" forIndexPath:indexPath];
            [cell configMsgCell:phxMsg];
            return cell;
        }
    }
    return [UITableViewCell new];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    PhxMessage *msg = [PhxMessage new];
    msg.msgContent = textField.text;
    msg.msgType = PhxMessageTypeText;
    msg.toUid = PhxSendToUserId;
    [self.channel pushEvent:PhxMessageNewEvent payload:[msg sendMsgPayload]];
    [self.msgArray addObject:msg];
    [self reloadMsgUI];
    textField.text = @"";
    return YES;
}

#pragma mark - Private

- (void)sendMsgAck:(NSArray<PhxMessage *> *)msgs {
    NSDictionary *payload = nil;
    if (msgs.count > 0) {
        if (msgs.count == 1) {
            PhxMessage *msg = msgs.firstObject;
            payload = @{@"id": msg.msgId};
        } else {
            NSArray *ids = [msgs bk_map:^id(PhxMessage *msg) {
                return msg.msgId;
            }];
            payload = @{@"ids": ids};
        }
    }
    if (payload) {
        [self.channel pushEvent:PhxMessageAckEvent payload:payload];
    }
}

- (void)reloadMsgUI {
    [self.msgTableView reloadData];
    if (self.msgArray.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.msgArray.count - 1 inSection:0];
            [self.msgTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }
}

@end
