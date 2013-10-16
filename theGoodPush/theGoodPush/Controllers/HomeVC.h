//
//  HomeVC.h
//  theGoodPush
//
//  Created by Justin Hyland on 9/21/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryManager.h"
#import "Constants.h"
#import "GoodPushApi.h"
#import "Alerts.h"
#import "Alerts+Extensions.h"

#import "YRDropdownView.h"



@interface HomeVC : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *lblSurveyCnt;
@property (nonatomic,weak) IBOutlet UILabel *lblMessageCnt;

@property (nonatomic, weak) IBOutlet UIView *vRatingBar1;
@property (nonatomic, weak) IBOutlet UIView *vRatingBar2;
@property (nonatomic, weak) IBOutlet UIView *vRatingBar3;
@property (nonatomic, weak) IBOutlet UIView *vRatingBar4;
@property (nonatomic, weak) IBOutlet UIView *vRatingBar5;

-(IBAction)btnAlertsList_Click:(id)sender;
-(IBAction)btnMessages_Click:(id)sender;
-(IBAction)btnSettings_Click:(id)sender;


@end
