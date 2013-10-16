//
//  HomeVC.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/26/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepositoryManager.h"
#import "Constants.h"

#import "Alerts.h"
#import "Alerts+Extensions.h"
#import "GoodPushApi.h"
#import "AlertsModel.h"
#import "YRDropdownView.h"
#import "DateHelper.h"


@interface SurveyListVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>


@property (nonatomic, weak) IBOutlet UITableView *mainTableView;


-(IBAction)btnAction_Click:(id)sender;
@end


@interface AlertTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblDtm;
@property (nonatomic, weak) IBOutlet UIImageView *imgRate1;
@property (nonatomic, weak) IBOutlet UIImageView *imgRate2;
@property (nonatomic, weak) IBOutlet UIImageView *imgRate3;
@property (nonatomic, weak) IBOutlet UIImageView *imgRate4;
@property (nonatomic, weak) IBOutlet UIImageView *imgRate5;
@end

