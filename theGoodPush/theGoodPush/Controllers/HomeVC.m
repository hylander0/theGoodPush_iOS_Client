//
//  HomeVC.m
//  theGoodPush
//
//  Created by Justin Hyland on 9/21/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
{
    NSArray *repoAlerts;
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView
{
    
    [api setDelegate:self];
    
    
    [self syncAndRefresh];
}

-(void)NewAlert:(NSNotification*)notification
{
    [YRDropdownView showDropdownInView:self.navigationController.navigationBar
                                 title:@"Notification"
                                detail:@"A new Notification has been received. Refreshing..."
                                 image:[UIImage imageNamed:@"dropdown-alert"]
                              animated:YES
                             hideAfter:1];
    [self syncAndRefresh];
    
}
-(void)appDidEnterForeground:(NSNotification*)n
{
    [self updateViewData];
}
-(void)syncAndRefresh
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [api getAllAlerts];
    [api getAllMessages];
}

-(void)updateViewData
{
    [self.lblSurveyCnt setText:[NSString stringWithFormat:@"%i", repoAlerts.count]];
    
    int maxBarWidth = 221;
    
    int rating1 = 0;
    int rating2 = 0;
    int rating3 = 0;
    int rating4 = 0;
    int rating5 = 0;
    
    Alerts *item;
    for(int i = 0; i < repoAlerts.count; i++)
    {
        item = [repoAlerts objectAtIndex:i];
        if([item.alert_importance  isEqual: @1])
            rating1 ++;
        else if([item.alert_importance  isEqual: @2])
            rating2 ++;
        else if([item.alert_importance  isEqual: @3])
            rating3 ++;
        else if([item.alert_importance  isEqual: @4])
            rating4 ++;
        else if([item.alert_importance  isEqual: @5])
            rating5 ++;
    }
    if(rating1 > 0)
        self.vRatingBar1.frame = modifyRectByWidth(self.vRatingBar1.frame, (((float)rating1 / (float)repoAlerts.count) * maxBarWidth));
    if(rating2 > 0)
        self.vRatingBar2.frame = modifyRectByWidth(self.vRatingBar2.frame, (((float)rating2 / (float)repoAlerts.count) * maxBarWidth));
    if(rating3 > 0)
        self.vRatingBar3.frame = modifyRectByWidth(self.vRatingBar3.frame, (((float)rating3 / (float)repoAlerts.count) * maxBarWidth));
    if(rating4 > 0)
        self.vRatingBar4.frame = modifyRectByWidth(self.vRatingBar4.frame, (((float)rating4 / (float)repoAlerts.count) * maxBarWidth));
    if(rating5 > 0)
        self.vRatingBar5.frame = modifyRectByWidth(self.vRatingBar5.frame, (((float)rating5 / (float)repoAlerts.count) * maxBarWidth));
    
}

-(void)loadDataFromRepo
{
    repoAlerts = [[RepositoryManager sharedInstance]
                  fetchArrayFromDBWithEntity:@"Alerts"
                  forKey:@"alert_dtm"
                  withPredicate:nil
                  ];
}

#pragma mark - Utility
CGRect modifyRectByWidth(CGRect originalRect, CGFloat newWidth)
{
    //221 Max
    CGRect result = originalRect;
    
    //result.origin.x += newWidth;
    result.size.width = newWidth;
    
    return result;
}

#pragma mark - IBOutlets
-(IBAction)btnAlertsList_Click:(id)sender
{
    [self performSegueWithIdentifier:@"sgAlertsList" sender:sender];
}
-(IBAction)btnSettings_Click:(id)sender
{
    [self performSegueWithIdentifier:@"sgSettings" sender:sender];
}
-(IBAction)btnMessages_Click:(id)sender
{
    //[self performSegueWithIdentifier:@"sgMessageList" sender:sender];
}
#pragma mark - Service Handlers
-(void)getAlertsWithHandler:(GoodPushApi*)handler Alerts:(NSArray*)alerts
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [Alerts SyncSvcAlertsWithRepo:alerts];
    
    [self loadDataFromRepo];
    [self updateViewData];
    
}
-(void)getAllMessagesWithHandler:(GoodPushApi*)handler Messages:(NSArray*)msgs
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if(msgs != nil)
        self.lblMessageCnt.text = [NSString stringWithFormat:@"%i", msgs.count];
}

@end
