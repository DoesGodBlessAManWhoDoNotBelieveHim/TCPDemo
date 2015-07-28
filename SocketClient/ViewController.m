//
//  ViewController.m
//  SocketClient
//
//  Created by ZhangJing on 15/7/21.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "ViewController.h"

#import "HexHelper.h"

#import "CustomButton.h"

#import "UIButton+CentreImageAndTitle.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *tipButton;
@property (strong, nonatomic) IBOutlet UITextField *hostTextField;
@property (strong, nonatomic) IBOutlet UITextField *portTextFiled;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hostConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bindConstraint;

- (IBAction)bind:(id)sender;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    _curtanisIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCurtains:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_curtanisIV addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    [tap2 setNumberOfTapsRequired:1];
    [tap2 setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap2];
    
    
    [[TCPTool shareInstance] addDelegate:self];
    
//    NSData *data = [HexHelper hexToByteToNSData:@"10"];
//    Byte *byte = (Byte *)[data bytes];
//    if (byte[0]==0x0a) {
//        
//    }
}

- (void)closeKeyboard:(UITapGestureRecognizer *)tap{
    if ([_hostTextField isFirstResponder]) {
        [_hostTextField resignFirstResponder];
    }
    
    if ([_portTextFiled isFirstResponder]) {
        [_portTextFiled resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[TCPTool shareInstance] searchCurtains];
    
    [self hideButton];
}

- (IBAction)bind:(id)sender {
    [[TCPTool shareInstance]connectToHost:_hostTextField.text port:_portTextFiled.text.integerValue];
}

- (void)hideButton{
    if (_tipButton.hidden) {
        return;
    }
    [UIView animateWithDuration:1 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tipButton.alpha=0;
    } completion:^(BOOL finished) {
        _tipButton.hidden = YES;
        _tipButton.enabled = NO;
        
        _hostConstraint.constant -= 20;
        _bindConstraint.constant -= 20;
    }];
}

- (IBAction)openCurtains:(UIButton *)sender {
    //这里假设开的窗帘 后面参数都是1
    if (_curtainsOpen) {
        [[TCPTool shareInstance]closeCurtainsWithBuilding:@"01" floor:@"01" room:@"01" number:@"01"];
    }
    else{
        [[TCPTool shareInstance]openCurtainsWithBuilding:@"01" floor:@"01" room:@"01" number:@"01"];
    }
    
}

- (void)didOpenCurtains:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    NSLog(@"success:%i\n bulding:%@\n floor:%@\n room:%@\n number:%@\n",success,bulding,floor,room,number);
    if (success) {
        [_curtanisIV setImage:[UIImage imageNamed:@"0-100.png"]];
        _curtainsOpen = YES;
    }
}

- (void)didCloseCurtains:(BOOL)success WithBuilding:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    if (success) {
        [_curtanisIV setImage:[UIImage imageNamed:@"0-0.png"]];
        _curtainsOpen = NO;
    }
}

- (void)didReceivedCuratainsStates:(NSArray *)states{
    for (NSArray *infos in states) {
        if ([[infos objectAtIndex:4] integerValue]==0x01) {//打开
            [_curtanisIV setImage:[UIImage imageNamed:@"0-100.png"]];
            _curtainsOpen = YES;
        }
        else{
            [_curtanisIV setImage:[UIImage imageNamed:@"0-0.png"]];
            _curtainsOpen = NO;
        }
    }
}

- (void)didConnectToHost:(NSString *)host port:(int)port{
    _portTextFiled.enabled = NO;
    _hostTextField.enabled = NO;
    NSLog(@"成功连接上了%@--%i",host,port);
}

@end
