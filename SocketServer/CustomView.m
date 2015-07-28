//
//  CustomView.m
//  SocketClient
//
//  Created by wrt on 15/7/28.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)]; //RGB plus Alpha Channel
    [self setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self setLayer:viewLayer];
    viewLayer.masksToBounds = YES;
    viewLayer.cornerRadius = 5.0;
    // Drawing code here.
//    [[NSColor whiteColor] set];  //设置颜色
//    NSRectFill(dirtyRect);		//填充rect区域
}

@end
