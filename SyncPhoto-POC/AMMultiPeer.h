//
//  MCManager.h
//  MCDemo
//
//  Created by Ambas Chobsanti on 3/26/2558 BE.
//  Copyright (c) 2558 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface AMMultiPeer : NSObject <MCSessionDelegate, MCBrowserViewControllerDelegate>
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) NSMutableArray *connectedDataSource;

-(void)advertiseSelf:(BOOL)shouldAdvertise messageHandler:(void (^)(NSDictionary *result))messageHandler ;
- (void)clear;
- (void)showBrowserWithTarget:(UIViewController*)targer;

+ (instancetype)sharedManager;
- (void)sendDictionaryToAllPeer:(NSDictionary *)dict;

@end
