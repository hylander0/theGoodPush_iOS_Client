//
//  NotificationSettingsVC.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/29/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "NotificationSettingsVC.h"

@interface NotificationSettingsVC ()

@end

@implementation NotificationSettingsVC
{
    DeviceSetting *currentSettings;
    GoodPushApi *api;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        api = [[GoodPushApi alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
	// Do any additional setup after loading the view.
}

-(void)setupView
{
    [api setDelegate:self];
    UIRemoteNotificationType notifySettingsBitmask = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    if (notifySettingsBitmask == UIRemoteNotificationTypeNone) {
        [self.swAlerts setEnabled:NO];
        [self.swAllNotifications setEnabled:NO];
        [self.swSetYourPush setEnabled:NO];
        [self.swSetYourSound setEnabled:NO];
        [self.txtAlias setEnabled:NO];
        [self.btnSetAlias setEnabled:NO];
        return;
    }
    BOOL isAlertsEnabled = [[NSUserDefaults standardUserDefaults]
                                boolForKey:@"isOptInForNotifications"];
    [self.swAlerts setOn:isAlertsEnabled];
    
    
    if(CONSTANTS_IS_URBAN_AIRSHIP_IN_USE == YES)
    {
        [self.swAllNotifications
            setOn:[UAPush shared].pushEnabled
         ];
        [self.txtAlias
            setText:[UAPush shared].alias
         ];
    }
    else
    {
        [self.swAllNotifications setEnabled:NO];
        [self.txtAlias setEnabled:false];
    }
    
    //setup service base config
    NSString *token = [[NSUserDefaults standardUserDefaults]
             objectForKey:@"currentDeviceToken"];
    NSString *alias;
    if(CONSTANTS_IS_URBAN_AIRSHIP_IN_USE == YES)
    {
        alias = [UAPush shared].alias;
    }
    [api getDeviceSettingWithDeviceToken:token Alias:alias];

    
    

}
-(void)bindServerSettings
{
    [self.swSetYourPush setOn:currentSettings.IsPushEnabled];
    [self.swSetYourSound setOn:currentSettings.IsSoundEnabled];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions
-(IBAction)swAlerts_toggled:(id)sender
{
    UISwitch *toggle = (UISwitch*)sender;
    //Persist setting is user defaults
    [[NSUserDefaults standardUserDefaults]
        setBool:toggle.isOn forKey:@"isOptInForNotifications"];
    
    if(toggle.isOn)
    {
        NSLog(@"registerForRemoteNotificationTypes Called");
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge
          | UIRemoteNotificationTypeSound
          | UIRemoteNotificationTypeAlert)
         ];
    }
    else
    {
        //You should call this method in rare circumstances only, as you might be dropping
        //Support for push notifications
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}
-(IBAction)swAllNotifications_toggled:(id)sender
{
    UISwitch *toggle = (UISwitch*)sender;
    if(CONSTANTS_IS_URBAN_AIRSHIP_IN_USE == YES)
        [[UAPush shared] setPushEnabled:toggle.isOn];
    else
        [toggle setOn:NO];
}
-(IBAction)btnSetAlias_Click:(id)sender
{
    if(CONSTANTS_IS_URBAN_AIRSHIP_IN_USE == YES)
    {
        if(self.txtAlias.text.length > 0)
            [[UAPush shared] setAlias:self.txtAlias.text];
        else
            [[UAPush shared] setAlias:nil];
        [[UAPush shared] updateRegistration];
        
        currentSettings.Alias = self.txtAlias.text;
        [api setDeviceSettingWithSetting:currentSettings];
    }

    
}
-(IBAction)swSetYourPush_Click:(id)sender
{
    currentSettings.IsPushEnabled = [((UISwitch*)sender) isOn];
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       objectForKey:@"currentDeviceToken"];
    
    currentSettings.Alias = [UAPush shared].alias;
    currentSettings.DeviceToken =token;
    
    [api setDeviceSettingWithSetting:currentSettings];
}
-(IBAction)swSetYourSound_Click:(id)sender
{
    currentSettings.IsSoundEnabled = [((UISwitch*)sender) isOn];
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       objectForKey:@"currentDeviceToken"];
    
    currentSettings.Alias = [UAPush shared].alias;
    currentSettings.DeviceToken =token;
    
    [api setDeviceSettingWithSetting:currentSettings];
}
#pragma mark - Service Handlers
-(void)getDeviceSettingWithHandler:(GoodPushApi*)handler Setting:(DeviceSetting*)setting
{
    currentSettings = setting;
    [self bindServerSettings];
}
-(void)setDeviceSettingWithHandler:(GoodPushApi*)handler IsSuccessful:(BOOL)isSuccess
{
    NSString *msg;
    if(isSuccess)
    {
        msg = @"Your setting was change successfully on your server.";
    }
    else
        msg = @"Opps.  Something happend.  Try Again.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Settings"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
