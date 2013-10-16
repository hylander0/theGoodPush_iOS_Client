//
//  HomeVC.m
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "SurveyListVC.h"



@interface SurveyListVC ()

@end

@implementation SurveyListVC
{
    NSArray *repoAlerts;
    GoodPushApi *api;
    UIActionSheet *asActions;
    UIRefreshControl *refreshControl;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        api = [[GoodPushApi alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(NewAlert:)
                                                     name:CONSTANTS_NOTIFICATION_NAME_DID_RECEIVE_REMOTE_NOTIFICATION
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
	// Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)NewAlert:(NSNotification*)notification
{
    [self syncAndRefresh];
    
}
-(void)appDidEnterForeground:(NSNotification*)n
{
    [self syncAndRefresh];
}

-(void)setupView
{
    [self.mainTableView setDataSource:self];
    [self.mainTableView setDelegate:self];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.mainTableView addSubview:refreshControl];
    
    
    [api setDelegate:self];
    
    [self setActionSheet];

    [self syncAndRefresh];
}
-(void)setActionSheet
{
    NSString *actionSheetTitle = @"What would you like to do?"; //Action Sheet Title
    //NSString *other1 = @"Refresh";
    NSString *other1 = @"Clear Notifications";
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    NSString *other2;
    if (types == UIRemoteNotificationTypeNone)
        other2 = @"Opt-in Notifications";
    else
        other2 = @"Re-register";
    NSString *other3 = @"Settings";
    NSString *cancelTitle = @"Cancel";
    asActions = [[UIActionSheet alloc]
                 initWithTitle:actionSheetTitle
                 delegate:self
                 cancelButtonTitle:cancelTitle
                 destructiveButtonTitle:nil
                 otherButtonTitles:other1, other2, other3, nil];


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadDataFromRepo
{
    repoAlerts = [[RepositoryManager sharedInstance]
              fetchArrayFromDBWithEntity:@"Alerts"
              forKey:@"alert_dtm"
              withPredicate:nil
              ];
}
-(void)syncAndRefresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [api getAllAlerts];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return repoAlerts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertItemCell"];
    Alerts *item = ((Alerts*)[repoAlerts objectAtIndex:indexPath.row]);
    if(item.alert_msg.length > 0)
    {
        cell.lblName.text = [NSString stringWithFormat:@"%@ commented: %@", item.alert_name, item.alert_msg];
    }
    else
        cell.lblName.text = [NSString stringWithFormat:@"%@ gave a rating of %@ thumbs up.", item.alert_name, item.alert_importance];
    
    cell.lblDtm.text = [DateHelper timeIntervalWithStartDate:item.alert_dtm withEndDate:[NSDate date]]; //[self formatDtmWithDate:item.alert_dtm];
    
    if([item.alert_importance intValue] >= 1)
        [cell.imgRate1 setHidden:NO];
    else
        [cell.imgRate1 setHidden:YES];
    
    if([item.alert_importance intValue] >= 2)
        [cell.imgRate2 setHidden:NO];
    else
        [cell.imgRate2 setHidden:YES];
    
    if([item.alert_importance intValue] >= 3)
        [cell.imgRate3 setHidden:NO];
    else
        [cell.imgRate3 setHidden:YES];
    
    if([item.alert_importance intValue] >= 4)
        [cell.imgRate4 setHidden:NO];
    else
        [cell.imgRate4 setHidden:YES];
    
    if([item.alert_importance intValue] >= 5)
        [cell.imgRate5 setHidden:NO];
    else
        [cell.imgRate5 setHidden:YES];
    
    
    
    return cell;
    
}
-(NSString*)formatDtmWithDate:(NSDate*)dtm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    return [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
}
-(void)handleRefresh:(id)sender
{
    [self syncAndRefresh];
}
#pragma mark - UI Actions
-(IBAction)btnAction_Click:(id)sender
{
    [asActions showInView:self.view];
}
#pragma mark Action Sheet Handlers
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([buttonTitle isEqualToString:@"Refresh"]) {
//        [self syncAndRefresh];
//    }
    if([buttonTitle isEqualToString:@"Clear Notifications"])
    {
        [api removeAllAlerts];
        
    }
    else if ([buttonTitle isEqualToString:@"Settings"])
    {
        [self performSegueWithIdentifier:@"sgSettingsPush" sender:actionSheet];
    }
    else if ([buttonTitle isEqualToString:@"Opt-in Notifications"])
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                (UIRemoteNotificationTypeBadge
                 | UIRemoteNotificationTypeSound
                 | UIRemoteNotificationTypeAlert)
         ];
    }
    else if ([buttonTitle isEqualToString:@"Re-register"])
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setBool:YES
                       forKey:@"isOptInForNotifications"];
        
        BOOL isOptedIn = [[NSUserDefaults standardUserDefaults]
                                boolForKey:@"isOptInForNotifications"];
        if(isOptedIn) {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeBadge
              | UIRemoteNotificationTypeSound
              | UIRemoteNotificationTypeAlert)
             ];
        }
    }
    else if([buttonTitle isEqualToString:@"Opt-out Notifications"])
    {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet];
}
#pragma mark - Service Handlers
-(void)getAlertsWithHandler:(GoodPushApi*)handler Alerts:(NSArray*)alerts
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Alerts SyncSvcAlertsWithRepo:alerts];
//    [alerts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        AlertsModel *item = ((AlertsModel*)obj);
//        [Alerts SyncAlertAgaintRepoWithItems:[NSString stringWithFormat:@"%d", item.AlertId]
//                                   alertName:item.AlertName
//                                    AlertMsg:item.AlertMsg
//                             AlertImportance:[NSNumber numberWithInt:item.Importance]
//                                    AlertDtm:item.AlertDtm
//                                      Source:CONSTANTS_ALERT_SOURCE_TYPE_API];
//    }];
//    
    [self loadDataFromRepo];
    [self.mainTableView reloadData];
    [refreshControl endRefreshing];
//    NSIndexPath * ndxPath= [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.mainTableView scrollToRowAtIndexPath:ndxPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

-(void)removeAllAlertsWithHandler:(GoodPushApi*)handler ResponseCode:(NSString*)code
{
    [Alerts ClearAllAlerts];
    [self syncAndRefresh];
}
@end


@interface  AlertTableViewCell  ()

@end

@implementation AlertTableViewCell



@end