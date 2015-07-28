//
//  HexHelper.h
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexHelper : NSObject

+ (NSString *)toHex:(uint16_t)tempint;

+ (NSString *)hexStringFromString:(NSString *)string;

+(NSData *)hexToByteToNSData:(NSString *)str;
@end
