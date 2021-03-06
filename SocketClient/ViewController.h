//
//  ViewController.h
//  SocketClient
//
//  Created by ZhangJing on 15/7/21.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPTool.h"

@interface ViewController : UIViewController<TCPToolDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *curtanisIV;

@property (nonatomic,assign)  BOOL curtainsOpen;

@property (strong, nonatomic) IBOutlet UIView *bindingView;
- (IBAction)openCurtains:(UIButton *)sender;
- (IBAction)showBindingView:(id)sender;
@end

