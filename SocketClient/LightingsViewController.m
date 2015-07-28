//
//  LightingsViewController.m
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import "LightingsViewController.h"
#import "TCPTool.h"

@interface LightingsViewController ()<TCPToolDelegate>

@end

@implementation LightingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dinningRoomBrightnessSlider.continuous=NO;
    _hallLightsBrigtnessSlider.continuous=NO;
    [[TCPTool shareInstance] addDelegate:self];
    
    self.view.userInteractionEnabled = YES;
    _dinningRoomLightsImageView.userInteractionEnabled = YES;
    _hallLightsImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrCloseLight:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [_hallLightsImageView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrCloseLight:)];
    [tap2 setNumberOfTapsRequired:1];
    [tap2 setNumberOfTouchesRequired:1];
    [_dinningRoomLightsImageView addGestureRecognizer:tap2];
    
}

- (void)openOrCloseLight:(UITapGestureRecognizer *)tap{
    if (tap.view == _hallLightsImageView) {
        if (_hallLightsBrigtnessSlider.value==0) {
            _hallLightsBrigtnessSlider.value = 10;
        }
        else{
            _hallLightsBrigtnessSlider.value = 0;
        }
        
        [self changeHallBrightness:_hallLightsBrigtnessSlider];
    }
    else{
        if (_dinningRoomBrightnessSlider.value==0) {
            _dinningRoomBrightnessSlider.value = 10;
        }
        else{
            _dinningRoomBrightnessSlider.value = 0;
        }
        
        [self changeDinningRoomBrightness:_dinningRoomBrightnessSlider];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[TCPTool shareInstance] searchLightings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeHallBrightness:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int value = (int)slider.value;
    NSString *valueStr=@"";
    valueStr = [NSString stringWithFormat:@"0%i",value];
    if (value==10) {
        valueStr = @"0a";
    }
    
    
    [_hallLightsBrigtness setText:[NSString stringWithFormat:@"%i%%",value*10]];
    [[TCPTool shareInstance]controlLightingWithBrightness:valueStr building:@"01" floor:@"01" room:@"01" number:@"01"];
}
- (IBAction)changeDinningRoomBrightness:(UISlider *)sender {
    
    int value = (int)sender.value;
    NSString *valueStr=@"";
    valueStr = [NSString stringWithFormat:@"0%i",value];
    if (value==10) {
        valueStr = @"0a";
    }
    
    [_dinningRoomLightBrightness setText:[NSString stringWithFormat:@"%i%%",value*10]];
    [[TCPTool shareInstance]controlLightingWithBrightness:valueStr building:@"01" floor:@"01" room:@"01" number:@"02"];
}

#pragma mark =======<#title#>=========

- (void)didReceivedLightsStates:(NSArray *)states{
    for (NSArray *infos in states) {
        NSInteger bringtness =[infos[0] integerValue];
        if ([[infos objectAtIndex:4] integerValue]==1) {
            _hallLightsBrigtnessSlider.value =bringtness ;
            [_hallLightsBrigtness setText:[NSString stringWithFormat:@"%li%%",bringtness*10]];
            [_hallLightsImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",(long)bringtness*10]]];
        }
        else{
            _dinningRoomBrightnessSlider.value =bringtness ;
            [_dinningRoomLightBrightness setText:[NSString stringWithFormat:@"%li%%",bringtness*10]];
            [_dinningRoomLightsImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li.png",(long)bringtness*10]]];
        }
    }
}

- (void)didCtrolLightsSuccess:(BOOL)success WithBrightness:(NSString *)brightness building:(NSString *)bulding floor:(NSString *)floor room:(NSString *)room number:(NSString *)number{
    
    if (success) {
        NSString *imageName = [NSString stringWithFormat:@"%li",brightness.integerValue*10];
        if (number.integerValue==1) {
            [_hallLightsImageView setImage:[UIImage imageNamed:imageName]];
        }
        else{
            [_dinningRoomLightsImageView setImage:[UIImage imageNamed:imageName]];
        }
    }
    else{//失败了，要将slider和灯的图片改回去
        
    }
}

@end






