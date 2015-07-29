//
//  TCPServerTool.m
//  SocketClient
//
//  Created by wrt on 15/7/23.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "TCPServerTool.h"

#import "TCPTool.h"

static TCPServerTool *_instance;

@implementation TCPServerTool

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[TCPServerTool alloc]init];
        }
    });
    return _instance;
}

- (GCDAsyncSocket *)serverSocket{
    if (!_serverSocket) {
        _serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _serverSocket;
}

- (void)startListeningPort:(NSInteger)port error:(NSError **)err{
    
    if (!_listenning) {
        [self.serverSocket acceptOnPort:port error:err];
        if (!(*err)) {
            _listenning = YES;
            NSLog(@"start listhening!");
        }
        else{
            NSLog(@"监听失败：%@",*err);
        }
    }
    else{
        _listenning = NO;
        // 先断开
        [self.serverSocket disconnect];
    }
    
}

- (void)disAllConnect{
    if (_clientSocket) {
        [_clientSocket disconnect];
    }
}

- (void)sendData:(NSData *)data{
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)sendResultOfCurtainsOpen:(BOOL)open Success:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    
    NSData *resultDataToWrite = [self _curtainsDataToWriteWithBuilding:bulding floor:floor room:room number:number forOpen:open];
    
    [self sendData:resultDataToWrite];
}
- (void)sendResultOfCurtainsSearch:(NSArray *)array{
    NSString *curtainsHexStr = [HexHelper toHex:[array[0] intValue]];
    NSData *curtainsData = [HexHelper hexToByteToNSData:curtainsHexStr];
    Byte *curtainsBytes= (Byte *)[curtainsData bytes];
    Byte bytes[] ={kHeader1,kHeader2,kHeader2,kHeader1,0x06,0x15,0x01,0x01,0x01,0x01,curtainsBytes[0]};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self sendData:data];
}

- (void)sendResultOfLightsCtrolSuccess:(BOOL)success WithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    NSData *resultDataToWrite = [self _lightsDataToWriteWithBrightness:brightness building:bulding floor:floor room:room number:number];
    [self sendData:resultDataToWrite];
}
- (void)sendResultOfLightsSearch:(NSArray *)array{
    NSString *hallHexStr = [HexHelper toHex:[array[0] intValue]];
    NSData *hallData = [HexHelper hexToByteToNSData:hallHexStr];
    Byte *hallBytes= (Byte *)[hallData bytes];
    
    NSString *DinningHexStr = [HexHelper toHex:[array[1] intValue]];
    NSData *DinningData = [HexHelper hexToByteToNSData:DinningHexStr];
    Byte *DinningBytes= (Byte *)[DinningData bytes];
    
    Byte bytes[] ={kHeader1,kHeader2,kHeader2,kHeader1,0x0B,0x16,hallBytes[0],0x01,0x01,0x01,0x01,DinningBytes[0],0x01,0x01,0x01,0x02};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self sendData:data];
    
}

- (void)sendResultOfStoryEnabelSuccess:(BOOL)success WithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room{
    NSData *resultDataToWrite =[self _storyDataToWriteWithPattern:pattern building:bulding floor:floor room:room];
    [self sendData:resultDataToWrite];
}
- (void)sendResultOfStorySearch:(NSString *)pattern{
    Byte bytes[]= {kHeader1,kHeader2,kHeader2,kHeader1,0x02,0x17,pattern.integerValue==1?0x01:0x02};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [self sendData:data];
}

#pragma mark =======私有方法=========
- (void)readDataFromClient:(NSTimer *)timer{
    if (_clientSocket) {
        [_clientSocket readDataWithTimeout:-1 tag:0];
    }
}

- (NSData *)_curtainsDataToWriteWithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number forOpen:(BOOL)forOpen{
    
    NSData *buldingData = [HexHelper hexToByteToNSData:bulding];
    Byte *buldingBytes = (Byte *)[buldingData bytes];
    
    NSData *floorData = [HexHelper hexToByteToNSData:floor];
    Byte *floorBytes = (Byte *)[floorData bytes];
    
    NSData *roomData = [HexHelper hexToByteToNSData:room];
    Byte *roomBytes = (Byte *)[roomData bytes];
    
    NSData *numberData = [HexHelper hexToByteToNSData:number];
    Byte *numberBytes = (Byte *)[numberData bytes];
    
    Byte bytes[] = {kHeader1,kHeader2,kHeader2,kHeader1,0x05,forOpen?0x11:0x12,buldingBytes[0],floorBytes[0],roomBytes[0],numberBytes[0],0x01};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    return data;
}

- (NSData *)_lightsDataToWriteWithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    NSData *brightnessData = [HexHelper hexToByteToNSData:brightness];
    Byte *brightnessBytes = (Byte *)[brightnessData bytes];
    
    NSData *buldingData = [HexHelper hexToByteToNSData:bulding];
    Byte *buldingBytes = (Byte *)[buldingData bytes];
    
    NSData *floorData = [HexHelper hexToByteToNSData:floor];
    Byte *floorBytes = (Byte *)[floorData bytes];
    
    NSData *roomData = [HexHelper hexToByteToNSData:room];
    Byte *roomBytes = (Byte *)[roomData bytes];
    
    NSData *numberData = [HexHelper hexToByteToNSData:number];
    Byte *numberBytes = (Byte *)[numberData bytes];
    
    Byte bytes[] = {kHeader1,kHeader2,kHeader2,kHeader1,0x06,0x21,brightnessBytes[0],buldingBytes[0],floorBytes[0],roomBytes[0],numberBytes[0],0x01};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    return data;
}

- (NSData *)_storyDataToWriteWithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room{
    
    NSData *patternData = [HexHelper hexToByteToNSData:pattern];
    Byte *patternBytes = (Byte *)[patternData bytes];
    
    NSData *buldingData = [HexHelper hexToByteToNSData:bulding];
    Byte *buldingBytes = (Byte *)[buldingData bytes];
    
    NSData *floorData = [HexHelper hexToByteToNSData:floor];
    Byte *floorBytes = (Byte *)[floorData bytes];
    
    NSData *roomData = [HexHelper hexToByteToNSData:room];
    Byte *roomBytes = (Byte *)[roomData bytes];
    
    Byte bytes[] = {kHeader1,kHeader2,kHeader2,kHeader1,0x05,0x23,patternBytes[0],buldingBytes[0],floorBytes[0],roomBytes[0],0x01};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    return data;
}

#pragma mark =======Delegate=========

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    if (!_clientSocket) {
        newSocket.delegate = self;
        _clientSocket = newSocket;
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(readDataFromClient:) userInfo:nil repeats:YES];
        NSLog(@"新的socket连接，同时server端接受了");
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSLog(@"serverReceivedData:\n");
    Byte *bytes = (Byte *)[data bytes];
    if (bytes[5] == 0x11 || bytes[5]==0x12) {
        NSString *bulding = [NSString stringWithFormat:@"%i",bytes[6]];
        NSString *floor = [NSString stringWithFormat:@"%i",bytes[7]];
        NSString *room = [NSString stringWithFormat:@"%i",bytes[8]];
        NSString *number = [NSString stringWithFormat:@"%i",bytes[9]];
        if (bytes[5] == 0x11) {
            [self.delegate didReceivedCurtainsOpenOrderWithBuilding:bulding floor:floor room:room number:number];
        }
        else{
            [self.delegate didReceivedCurtainsCloseOrderWithBuilding:bulding floor:floor room:room number:number];
        }
        
    }
    else if(bytes[5]==0x15){
        [self.delegate didReceivedCurtainsStatusSearchOrder];
    }
    else if (bytes[5]==0x21){
        NSString *brightness = [NSString stringWithFormat:@"%i",bytes[6]];
        NSString *bulding = [NSString stringWithFormat:@"%i",bytes[7]];
        NSString *floor = [NSString stringWithFormat:@"%i",bytes[8]];
        NSString *room = [NSString stringWithFormat:@"%i",bytes[9]];
        NSString *number = [NSString stringWithFormat:@"%i",bytes[10]];
        [self.delegate didReceivedLightsCtrolOrderWithBrightness:brightness building:bulding floor:floor room:room number:number];
    }
    else if (bytes[5]==0x16){
        [self.delegate didReceivedLightsStatusSearchOrder];
    }
    else if (bytes[5]==0x23){
        NSString *pattern = [NSString stringWithFormat:@"%i",bytes[6]];
        NSString *bulding = [NSString stringWithFormat:@"%i",bytes[7]];
        NSString *floor = [NSString stringWithFormat:@"%i",bytes[8]];
        NSString *room = [NSString stringWithFormat:@"%i",bytes[9]];
        [self.delegate didReceivedStoryEnabelOrderWithPattern:pattern building:bulding floor:floor room:room];
    }
    else if (bytes[5]==0x17){
        [self.delegate didReceivedStoriesSearchOrder];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    _listenning = NO;
    _clientSocket.delegate = nil;
    _clientSocket = nil;
    NSLog(@"断开链接！");
}



@end
