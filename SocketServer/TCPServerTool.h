//
//  TCPServerTool.h
//  SocketClient
//
//  Created by wrt on 15/7/23.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#import "HexHelper.h"

@protocol TCPServerToolDelegate <NSObject>

@optional
- (void)didReceivedCurtainsOpenOrderWithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didReceivedCurtainsCloseOrderWithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didReceivedCurtainsStatusSearchOrder;
//
- (void)didReceivedLightsCtrolOrderWithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didReceivedLightsStatusSearchOrder;
//
- (void)didReceivedStoryEnabelOrderWithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room;
- (void)didReceivedStoriesSearchOrder;
@end

@interface TCPServerTool : NSObject<GCDAsyncSocketDelegate>

@property (strong,nonatomic) GCDAsyncSocket *serverSocket;

@property (strong,nonatomic) GCDAsyncSocket *clientSocket;

@property (nonatomic,assign) id<TCPServerToolDelegate> delegate;

@property (nonatomic,assign) BOOL listenning;

+ (instancetype)shareInstance;

- (void)startListeningPort:(NSInteger)port error:(NSError **)err;

- (void)disAllConnect;


- (void)sendData:(NSData *)data;


- (void)sendResultOfCurtainsOpen:(BOOL)open Success:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)sendResultOfCurtainsSearch:(NSArray *)array;

- (void)sendResultOfLightsCtrolSuccess:(BOOL)success WithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)sendResultOfLightsSearch:(NSArray *)array;

- (void)sendResultOfStoryEnabelSuccess:(BOOL)success WithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room;
- (void)sendResultOfStorySearch:(NSString *)pattern;

@end
