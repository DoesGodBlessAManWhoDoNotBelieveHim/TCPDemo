//
//  CustomButton.m
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    CGFloat titleY = contentRect.size.height *0.6;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(contentRect.origin.x, titleY, titleW, titleH);
    
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    
    CGFloat imageH = contentRect.size.height * 0.6;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}

@end
