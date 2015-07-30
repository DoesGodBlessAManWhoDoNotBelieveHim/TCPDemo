//
//  StoriesViewController.m
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "StoriesViewController.h"
#import "TCPTool.h"

@interface StoriesViewController ()<TCPToolDelegate,UIGestureRecognizerDelegate>

@end

@implementation StoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enabelInHomeStory:)];
    tap.delegate =self;
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    _inHomeImageView.userInteractionEnabled = YES;
    [_inHomeImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enabelInHomeStory:)];
    tap2.delegate =self;
    [tap2 setNumberOfTapsRequired:1];
    [tap2 setNumberOfTouchesRequired:1];

    _outImageView.userInteractionEnabled = YES;
    [_outImageView addGestureRecognizer:tap2];
    
    [[TCPTool shareInstance]addDelegate:self];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)enabelInHomeStory:(UIGestureRecognizer *)gesture{
    if (gesture.view==_inHomeImageView) {
        [[TCPTool shareInstance]enableStoryWithPattern:@"01" building:@"01" floor:@"01" room:@"01"];
    }
    else{
        [[TCPTool shareInstance]enableStoryWithPattern:@"02" building:@"01" floor:@"01" room:@"01"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[TCPTool shareInstance] searchStories];
}

- (void)didReceivedStoriesPattern:(NSString *)pattern{
    [self updateViewWithPatter:pattern];
}

- (void)updateViewWithPatter:(NSString *)pattern{
    if (pattern.integerValue==0) {//没有启用任何模式
        
    }
    else if(pattern.integerValue ==1){//在家模式
        _inHomeImageView.layer.borderColor = [UIColor redColor].CGColor;
        _inHomeImageView.layer.masksToBounds = YES;
        _inHomeImageView.layer.borderWidth = 2.f;
        
        _outImageView.layer.borderColor = [UIColor clearColor].CGColor;
        _outImageView.layer.masksToBounds = NO;
        _outImageView.layer.borderWidth = 0.f;
    }
    else if(pattern.integerValue ==2){//离家模式
        _inHomeImageView.layer.borderColor = [UIColor clearColor].CGColor;
        _inHomeImageView.layer.masksToBounds = NO;
        _inHomeImageView.layer.borderWidth = 0.f;
        
        _outImageView.layer.borderColor = [UIColor redColor].CGColor;
        _outImageView.layer.masksToBounds = YES;
        _outImageView.layer.borderWidth = 2.f;
    }
}

- (void)didEnabelStorySuccess:(BOOL)success WithPattern:(NSString *)pattern building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room{
    if (success) {
        [self updateViewWithPatter:pattern];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
