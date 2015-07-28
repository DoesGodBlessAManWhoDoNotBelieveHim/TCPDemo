//
//  HexHelper.m
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "HexHelper.h"

@implementation HexHelper

+ (NSString *)toHex:(uint16_t)tmpid{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
    }
    return str;
}

//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

//16进制转换为10进制数
-(NSInteger)HexChangeDo:(NSString *)tmpid{
    NSInteger Do=0;//获取10进制数
    NSInteger length=[tmpid length];
    NSInteger array[length];//获取每个字节的10进制数
    
    for(int i=0;i<length;i++)
    {
        unichar hex_char1 = [tmpid characterAtIndex:i]; //16进制数中的第i位
        if(hex_char1>='0'&&hex_char1<='9')//// 0 的Ascll  48
        {
            array[i]=(hex_char1-48)*pow(16, length-1-i);
        }
        else if(hex_char1>='A'&&hex_char1<='F')//// A 的Ascll  65
        {
            array[i]=(hex_char1-65+10)*pow(16, length-1-i);
        }
        else//// a 的Ascll  97
        {
            array[i]=(hex_char1-97+10)*pow(16, length-1-i);
        }
    }
    for(int k=0;k<length;k++)
    {
        Do+=array[k];
    }
    return Do;
}

//发送数据时,16进制数－>Byte数组->NSData,加上校验码部分
+(NSData *)hexToByteToNSData:(NSString *)str
{
    if (str.length%2==1) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    int j=0;
    Byte bytes[[str length]/2];                         ////Byte数组即字节数组,类似于C语言的char[],每个汉字占两个字节，每个数字或者标点、字母占一个字节
    for(int i=0;i<[str length];i++)
    {
        /**
         *  在iphone/mac开发中，unichar是两字节长的char，代表unicode的一个字符。
         *  两个单引号只能用于char。可以采用直接写文字编码的方式来初始化。采用下面方法可以解决多字符问题
         */
        int int_ch;                                     ///两位16进制数转化后的10进制数
        unichar hex_char1 = [str characterAtIndex:i];   ////两位16进制数中的第一位(高位*16)
        
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
        {
            int_ch1 = (hex_char1-48)*16;                //// 0 的Ascll - 48
        }
        else if(hex_char1 >= 'A' && hex_char1 <='F')
        {
            int_ch1 = (hex_char1-55)*16;                //// A 的Ascll - 65
        }
        else
        {
            int_ch1 = (hex_char1-87)*16;                //// a 的Ascll - 97
        }
        i++;
        unichar hex_char2 = [str characterAtIndex:i];   ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
        {
            int_ch2 = (hex_char2-48);                   //// 0 的Ascll - 48
        }
        else if(hex_char2 >= 'A' && hex_char2 <='F')
        {
            int_ch2 = hex_char2-55;                     //// A 的Ascll - 65
        }
        else
        {
            int_ch2 = hex_char2-87;                     //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;                              ///将转化后的数放入Byte数组里
        j++;
    }
    return [NSData dataWithBytes:bytes length:[str length]/2];
}
//接收数据时,NSData－>Byte数组->16进制数
-(NSString *)NSDataToByteTohex:(NSData *)data
{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    
    for(int i=0;i<[data length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数,与 0xff 做 & 运算会将 byte 值变成 int 类型的值，也将 -128～0 间的负值都转成正值了。
        if([newHexStr length]==1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}
-(NSString *)charToBinary:(NSString *)hex{
    NSString *binary = nil;
    if([hex isEqualToString:@"0"])
    {
        binary = @"0000";
    }
    else if ([hex isEqualToString:@"1"])
    {
        binary = @"0001";
    }
    else if ([hex isEqualToString:@"2"])
    {
        binary = @"0010";
    }
    else if ([hex isEqualToString:@"3"])
    {
        binary = @"0011";
    }
    else if ([hex isEqualToString:@"4"])
    {
        binary = @"0100";
    }
    else if ([hex isEqualToString:@"5"])
    {
        binary = @"0101";
    }
    else if ([hex isEqualToString:@"6"])
    {
        binary = @"0110";
    }
    else if ([hex isEqualToString:@"7"])
    {
        binary = @"0111";
    }
    else if ([hex isEqualToString:@"8"])
    {
        binary = @"1000";
    }
    else if ([hex isEqualToString:@"9"])
    {
        binary = @"1001";
    }
    else if ([hex isEqualToString:@"a"]||[hex isEqualToString:@"A"])
    {
        binary = @"1010";
    }
    else if ([hex isEqualToString:@"b"]||[hex isEqualToString:@"B"])
    {
        binary = @"1011";
    }
    else if ([hex isEqualToString:@"c"]||[hex isEqualToString:@"C"])
    {
        binary = @"1100";
    }
    else if ([hex isEqualToString:@"d"]||[hex isEqualToString:@"D"])
    {
        binary = @"1101";
    }
    else if ([hex isEqualToString:@"e"]||[hex isEqualToString:@"E"])
    {
        binary = @"1110";
    }
    else if ([hex isEqualToString:@"f"]||[hex isEqualToString:@"F"])
    {
        binary = @"1111";
    }
    return binary;
}
//16进制转二进制
-(NSString *)hexToBinary:(NSString *)hex{
    NSMutableString *string =[[NSMutableString alloc]init];
    
    for(int i=0;i<hex.length;i++)
    {
        NSString *temp=[self charToBinary:[hex substringWithRange:NSMakeRange(i, 1)]];
        [string appendString:temp];
    }
    return string;
}
//二进制转16进制
-(NSString *)binaryToHex:(NSString *)b{
    NSString *hexStr=nil;
    if([b isEqualToString:@"0000"])
    {
        hexStr = @"0";
    }
    else if([b isEqualToString:@"0001"])
    {
        hexStr = @"1";
    }
    else if([b isEqualToString:@"0010"])
    {
        hexStr = @"2";
    }
    else if([b isEqualToString:@"0011"])
    {
        hexStr = @"3";
    }
    else if([b isEqualToString:@"0100"])
    {
        hexStr = @"4";
    }
    else if([b isEqualToString:@"0101"])
    {
        hexStr = @"5";
    }
    else if([b isEqualToString:@"0110"])
    {
        hexStr = @"6";
    }
    else if([b isEqualToString:@"0111"])
    {
        hexStr = @"7";
    }
    else if([b isEqualToString:@"1000"])
    {
        hexStr = @"8";
    }
    else if ([b isEqualToString:@"1001"])
    {
        hexStr = @"9";
    }
    else if([b isEqualToString:@"1010"])
    {
        hexStr = @"A";
    }
    else if([b isEqualToString:@"1011"])
    {
        hexStr = @"B";
    }
    else if([b isEqualToString:@"1100"])
    {
        hexStr = @"C";
    }
    else if([b isEqualToString:@"1101"])
    {
        hexStr = @"D";
    }
    else if([b isEqualToString:@"1110"])
    {
        hexStr = @"E";
    }
    else if([b isEqualToString:@"1111"])
    {
        hexStr = @"F";
    }
    return hexStr;
}


@end
