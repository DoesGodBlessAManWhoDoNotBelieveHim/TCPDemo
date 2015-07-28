//
//  TCPTool.h
//  SocketClient
//
//  Created by ZhangJing on 15/7/21.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

#define kHostName @"192.168.0.135"
#define kHostPort 5222

#define kHeader1 0xA5
#define kHeader2 0X5A

#define kTag_Curtains_Open      100
#define kTag_Curtains_Close     101
#define kTag_Curtains_Search    102

#define kTag_Lights_Brigtness   1000
#define kTag_Lights_Search      1001

#define kTag_Story_Ctrol        10000
#define kTag_Story_Search       10001

@protocol TCPToolDelegate <NSObject>

@optional
//
- (void)didConnectToHost:(NSString *)host port:(int)port;
//
- (void)didOpenCurtains:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didCloseCurtains:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didReceivedCuratainsStates:(NSArray *)states;
//
- (void)didCtrolLightsSuccess:(BOOL)success WithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
- (void)didReceivedLightsStates:(NSArray *)states;
//
- (void)didEnabelStorySuccess:(BOOL)success WithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room;
- (void)didReceivedStoriesPattern:(NSString *)pattern;
@end

@interface TCPTool : NSObject<GCDAsyncSocketDelegate>

@property (strong,nonatomic) GCDAsyncSocket *client;

@property (strong,nonatomic) NSMutableArray *delegates;

@property (nonatomic,assign) BOOL connected;

+ (instancetype)shareInstance;
- (void)connectToHost:(NSString *)host port:(NSInteger)port;
- (void)disconnect;
- (void)addDelegate:(id)sender;
#pragma mark - 窗帘控制
/*
 开窗：0xA5  0x5A  0x5A  0xA5  0x05  0x11 栋号 层号 房号 编号
 回复：0xA5  0x5A  0x5A  0xA5  0x06  0x11 栋号 层号 房号 编号 结果
 释义：栋号、层号、房号，编号，全部默认从01开始，编号代表第几个窗帘。
 　　　结果：0：控制失败，1：控制成功。下同。
 */
- (void)openCurtainsWithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
/*
 关窗：0xA5  0x5A  0x5A  0xA5  0x05  0x12 栋号 层号 房号 编号
 回复：0xA5  0x5A  0x5A  0xA5  0x06  0x12 栋号 层号 房号 编号 结果
 */
- (void)closeCurtainsWithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
/*
 查询：0xA5  0x5A  0x5A  0xA5  0x01  0x15
 回复：0xA5  0x5A  0x5A  0xA5  0xXX  0x15 栋号 层号 房号 编号 状态 [栋号 层号 房号 编号 状态 …]
 释义：状态，0x00：关闭，0x0A：打开，0x01~0x09：打开幅度1~9。如果有多个窗帘，则重复：栋号 层号 房号 编号 状态
 */
- (void)searchCurtains;

#pragma mark - 灯光控制
/*
 控制：0xA5 0x5A 0x5A 0xA5 0x06 0x21 亮度 栋号 层号 房号 编号
 回复：0xA5 0x5A 0x5A 0xA5 0x07 0x21 亮度 栋号 层号 房号 编号 结果
 释义：亮度：00：关闭，0A：打开：0x01~0x09：亮度：0~9。
 */
- (void)controlLightingWithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number;
/*
 查询：0xA5 0x5A 0x5A 0xA5 0x01 0x16
 回复：0xA5 0x5A 0x5A 0xA5 0xXX 0x16亮度 栋号 层号 房号 编号 [亮度 栋号 层号 房号 编号 …]
 */
- (void)searchLightings;


#pragma mark - 情景控制
/*
 启用：0xA5  0x5A  0x5A  0xA5  0x05  0x23 模式号  栋号 层号 房号
 回复：0xA5  0x5A  0x5A  0xA5  0x06  0x23 模式号  栋号 层号 房号 结果
 释义：模式号取值从1开始，1：在家，2：离家，3：休闲
 */
- (void)enableStoryWithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room;
/*
 查询：0xA5  0x5A  0x5A  0xA5  0x01  0x17
 回复：0xA5  0x5A  0x5A  0xA5  0x02  0x17 模式号
 释义：模式号，如果是0，表示当前没有启用任何模式。
 */
- (void)searchStories;
@end
