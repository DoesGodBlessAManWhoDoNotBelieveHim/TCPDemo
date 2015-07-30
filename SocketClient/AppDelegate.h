//
//  AppDelegate.h
//  SocketClient
//
//  Created by ZhangJing on 15/7/21.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#ifdef DEBUG

#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabbarController;
@end

