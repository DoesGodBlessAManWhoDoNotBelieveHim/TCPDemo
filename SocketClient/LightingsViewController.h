//
//  LightingsViewController.h
//  SocketClient
//
//  Created by wrt on 15/7/22.
//  Copyright (c) 2015年 SINGLE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *hallLightsImageView;
@property (strong, nonatomic) IBOutlet UILabel *hallLightsBrigtness;
@property (strong, nonatomic) IBOutlet UISlider *hallLightsBrigtnessSlider;
- (IBAction)changeHallBrightness:(id)sender;


@property (strong, nonatomic) IBOutlet UIImageView *dinningRoomLightsImageView;
@property (strong, nonatomic) IBOutlet UILabel *dinningRoomLightBrightness;
@property (strong, nonatomic) IBOutlet UISlider *dinningRoomBrightnessSlider;
- (IBAction)changeDinningRoomBrightness:(UISlider *)sender;


@end
