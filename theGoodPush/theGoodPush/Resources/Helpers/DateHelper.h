//
//  DateHelper.h
//  zityApp
//
//  Created by Justin H on 4/15/13.
//  Copyright (c) 2013 iteedee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject
+(NSArray*)sortArray:(NSArray*)arry withObjectKey:(NSString*)key ascending:(BOOL)isAsc;
+(BOOL)isSameDayWithDate:(NSDate*)date1 date2:(NSDate*)date2;
+(NSDate*)addDaysWithDate:(NSDate*)dtm
                     days:(int)d;
+(NSArray*)getObjectsBetweenDatesWithArray:(NSArray*)arry
                                  StartDtm:(NSDate*)dtm1
                                    endDtm:(NSDate*)dtm2
                                 FieldName:(NSString*)field;
+(NSDate *)dateWithOutTime:(NSDate *)datDate;
+(NSString*)getDayOfMonthSuffixWithDate:(NSDate*)dtm;
+(NSString*)getPrettyHeaderDtmWithDate:(NSDate*)dtm;
+(NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2;
@end
