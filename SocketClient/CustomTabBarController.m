//
//  CustomTabBarController.m
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "CustomTabBarController.h"

#import "AppDelegate.h"

@implementation CustomTabBarController

- (instancetype)init{
    if (self = [super init]) {
        [self.tabBar setHidden:YES];
        [self _initNewTabBarView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self.tabBar setHidden:YES];
        [self _initNewTabBarView];
    }
    return self;
}

- (void)_initNewTabBarView{
    NSLog(@"%@",NSStringFromCGSize(SCREEN_SIZE));
    CGFloat rate = SCREEN_SIZE.width / 720.0;
    CGFloat height = 196.0*rate;
    _customTabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_SIZE.height - height, SCREEN_SIZE.width, height)];
    [_customTabBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_customTabBarView];
    
    NSArray *normalImages = @[@"窗帘1.png",@"灯光1.png",@"情景1.png"];
    
    NSArray *selectedImages = @[@"窗帘2.png",@"灯光2.png",@"情景2.png"];
    NSInteger buttonCount = normalImages.count;
    CGFloat buttonWidth = SCREEN_SIZE.width/buttonCount;
    for (int i = 0; i < buttonCount; i++) {
        @autoreleasepool {
            NSString *normal = normalImages[i];
            NSString *selected = selectedImages[i];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, height);
            button.tag = i;
            [button setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
            NSString *title = @"";
            if (i==0) {
                title = @"窗 帘";
            }
            else if(i==1){
                title = @"灯 光";
            }
            else{
                title = @"情 景";
            }
            
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateSelected];
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
//            [button centerImageAndTitle];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, -75, 0)];
            [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchDown];
            [_customTabBarView addSubview:button];
            if (i==0) {
                [button setSelected:YES];
            }
        }
    }
}

- (void)selectTab:(UIButton *)button{
    if (button.tag == self.selectedIndex) {
        return;
    }
    
    for (UIView *subView in _customTabBarView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setSelected:NO];
        }
    }
    button.selected = YES;
    
    [self setSelectedIndex:button.tag];
}

@end





















