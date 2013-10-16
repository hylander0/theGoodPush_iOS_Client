//
//  MessagesModel.h
//  theGoodPush
//
//  Created by Justin Hyland on 9/23/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesModel : NSObject
@property NSInteger Id;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Msg;
@property (nonatomic, strong) NSDate *Dtm;
@end
