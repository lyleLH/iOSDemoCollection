//
//  ViewController.m
//  IMDemo
//
//  Created by lyleKP on 16/1/14.
//  Copyright © 2016年 lyleKP. All rights reserved.
//

#import "ViewController.h"
#import <XMPPFramework/XMPPFramework.h>
#import <XMPPRoster.h>
@interface ViewController ()
@property (nonatomic,strong)XMPPStream * xmppStream;
@property (nonatomic,strong)XMPPRoster *xmppRoster;

@end

@implementation ViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];


    
    
}


- (IBAction)login:(id)sender {
    
    [self connect];
    
}


- (IBAction)signUp:(id)sender {
}


- (IBAction)sendMsg:(id)sender {
    
    [self sendMessage:@"呵呵 SuperBoy" toUser:@"liufei"];
}

//发送消息
- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    
    [body setStringValue:message];
    
    NSXMLElement *messa = [NSXMLElement elementWithName:@"message"];
    
    [messa addAttributeWithName:@"type" stringValue:@"chat"];
    
    NSString *to = [NSString stringWithFormat:@"%@@%@", user,@"winappserver01"];
    [messa addAttributeWithName:@"to" stringValue:to];
    [messa addAttributeWithName:@"from" stringValue:@"100"];
    
    [messa addChild:body];
    [self.xmppStream sendElement:messa];
    NSLog(@"%@",messa);

}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSLog(@"receive%@",message);
    
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{

    
}





- (void)setupXmppStream
{
    // 1. 实例化
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}


- (void)connect
{
    // 1. 实例化XMPPStream
    [self setupXmppStream];
    
//    NSString *hostName = @"winappserver01";
        NSString *hostName = @"10.1.1.4";
    NSString *userName = @"100";
//    NSInteger hostPort= 5222;
    
    
    
    // 设置XMPPStream的hostName&JID
    _xmppStream.hostName = hostName;
//    _xmppStream.hostPort = hostPort;
    _xmppStream.myJID = [XMPPJID jidWithUser:userName domain:hostName resource:@"iOS"];
    // 连接
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        NSLog(@"发送连接请求成功");
    }
}

#pragma mark 断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"断开连接");
}



#pragma mark - XMPPStream协议代理方法
#pragma mark 完成连接
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"success userName = %@, myJID = %@",sender.myJID.user, sender.myJID);
    
    #pragma mark 身份验证
    NSString *password = @"Y!@9oKF4";
    [_xmppStream authenticateWithPassword:password error:nil];
}




#pragma mark 身份验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"身份验证成功!");
    [_xmppRoster activate:_xmppStream];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    XMPPPresence *presence = [XMPPPresence presence];
    //可以加上上线状态，比如忙碌，在线等
    [_xmppStream sendElement:presence];//发送上线通知
}

#pragma mark 用户名或者密码错误
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"用户名或者密码错误 error = %@",error);
}


@end
