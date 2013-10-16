//
//  NotificationSettingsVC.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/29/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAPush.h"
#import "Constants.h"
#import "GoodPushApi.h"
#import "DeviceSetting.h"


@interface NotificationSettingsVC : UIViewController



@property (nonatomic, weak) IBOutlet UISwitch *swAlerts;
@property (nonatomic, weak) IBOutlet UISwitch *swAllNotifications;
@property (nonatomic, weak) IBOutlet UITextField *txtAlias;
@property (nonatomic, weak) IBOutlet UIButton *btnSetAlias;

@property (nonatomic, weak) IBOutlet UISwitch *swSetYourPush;
@property (nonatomic, weak) IBOutlet UISwitch *swSetYourSound;

-(IBAction)swAlerts_toggled:(id)sender;
-(IBAction)swAllNotifications_toggled:(id)sender;
-(IBAction)btnSetAlias_Click:(id)sender;

-(IBAction)swSetYourPush_Click:(id)sender;
-(IBAction)swSetYourSound_Click:(id)sender;
@end
