//
//  MCManager.m
//  MCDemo
//
//  Created by Ambas Chobsanti on 3/26/2558 BE.
//  Copyright (c) 2558 AM. All rights reserved.
//

#import "AMMultiPeer.h"
NSString *serviceType = @"chat-file";
@interface AMMultiPeer ()

@property (nonatomic, copy) void (^messageHandler)(NSDictionary *result);

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

@end

@implementation AMMultiPeer

+ (instancetype)sharedManager {
    static AMMultiPeer *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];
        [_sharedManager setupPeerAndSession];
    });
    
    return _sharedManager;
}

- (MCBrowserViewController *)browser {
    if (!_browser) {
       self.browser = [[MCBrowserViewController alloc] initWithServiceType:serviceType session:self.session];
    }
    return _browser;
}

-(NSMutableArray *)connectedDataSource {
    if (!_connectedDataSource) {
        _connectedDataSource = [[NSMutableArray alloc] init];
    }
    return _connectedDataSource;
}
- (void)clear {
    self.peerID = nil;
    self.session = nil;
    self.browser = nil;
    self.advertiser = nil;
}

- (void)showBrowserWithTarget:(UIViewController<MCBrowserViewControllerDelegate>*)targer {
    [targer presentViewController:self.browser animated:YES completion:nil];
    self.browser.delegate = self;
}

- (void)setupPeerAndSession {
    NSString *deviceName = [UIDevice currentDevice].name;
    self.peerID = [[MCPeerID alloc] initWithDisplayName:deviceName];
    
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

-(void)advertiseSelf:(BOOL)shouldAdvertise messageHandler:(void (^)(NSDictionary *result))messageHandler {
    if (shouldAdvertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:serviceType
                                                           discoveryInfo:nil
                                                                 session:self.session];
        [self.advertiser start];
    }
    else{
        [self.advertiser stop];
        self.advertiser = nil;
    }
    self.messageHandler = messageHandler;
}
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{

    if (state == MCSessionStateNotConnected) {
        if (![self.connectedDataSource containsObject:peerID]) {
            [self.connectedDataSource addObject:peerID];
        }
    } else if (state == MCSessionStateNotConnected) {
        [self.connectedDataSource removeObject:peerID];
    }
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{

    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.messageHandler(dict);
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void(^)(BOOL accept))certificateHandler {
    if (self.didAcceptConnectionHandler) {
        self.didAcceptConnectionHandler();
        certificateHandler(YES);
    }
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self.browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendDictionaryToAllPeer:(NSDictionary *)dict {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    NSArray *allPeers = [AMMultiPeer sharedManager].session.connectedPeers;
    NSError *error;
    [self.session sendData:jsonData toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
    if (error) {
        NSLog(@"have some error");
    }
}

@end
