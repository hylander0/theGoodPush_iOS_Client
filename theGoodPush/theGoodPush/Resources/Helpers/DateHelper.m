//
//  DateHelper.m
//  zityApp
//
//  Created by Justin H on 4/15/13.
//  Copyright (c) 2013 iteedee. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+(BOOL)isSameDayWithDate:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
    
}
+(NSArray*)sortArray:(NSArray*)arry withObjectKey:(NSString*)key ascending:(BOOL)isAsc
{
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                 ascending:isAsc];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [arry sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}
+(NSArray*)getObjectsBetweenDatesWithArray:(NSArray*)arry
                                  StartDtm:(NSDate*)dtm1
                                    endDtm:(NSDate*)dtm2
                                 FieldName:(NSString*)field
{
    NSLog(@"StartDtm: %@", [DateHelper dateWithOutTime:dtm1]);
    NSLog(@"endDtm: %@", [DateHelper dateWithOutTime:dtm2]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K >= %@) && (%K <= %@)",
                              field,
                              [DateHelper dateWithOutTime:dtm1],
                              field,
                              [DateHelper dateWithOutTime:dtm2]];

    NSArray *retval = [arry filteredArrayUsingPredicate:predicate];
    //NSLog(@"count: %i", retval.count);
    //return [[NSArray alloc] init];
    return retval;
}
+(NSDate*)addDaysWithDate:(NSDate*)dtm
                    days:(int)d {
    return [dtm dateByAddingTimeInterval:60*60*24*d];
}

+(NSDate *)dateWithOutTime:(NSDate *)datDate
{
    if( datDate == nil )
        datDate = [NSDate date];
    
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:datDate];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];

}
+(NSString*)getDayOfMonthSuffixWithDate:(NSDate*)dtm
{
//    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
//    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
//    [prefixDateFormatter setDateFormat:@"EEEE MMMM d"];
    //NSString *prefixDateString;
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:dtm] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    //NSString *dateString = [prefixDateString stringByAppendingString:suffix];
    
    return suffix;

}
+(NSString*)getPrettyHeaderDtmWithDate:(NSDate*)dtm
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"EEE LLL d"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:dtm];
    NSString *displayDtm = [NSString stringWithFormat:@"%@%@, %i",
                            [f stringFromDate:dtm],
                            [DateHelper getDayOfMonthSuffixWithDate:dtm],
                            [components year]
                            ];

    return displayDtm;
}
//Constants
#define SECOND 1
#define MINUTE (60 * SECOND)
#define HOUR (60 * MINUTE)
#define DAY (24 * HOUR)
#define MONTH (30 * DAY)

+ (NSString*)timeIntervalWithStartDate:(NSDate*)d1 withEndDate:(NSDate*)d2
{
    //Calculate the delta in seconds between the two dates
    NSTimeInterval delta = [d2 timeIntervalSinceDate:d1];
    
    if (delta < 1 * MINUTE)
    {
        return delta == 1 ? @"one second ago" : [NSString stringWithFormat:@"%d seconds ago", (int)delta];
    }
    if (delta < 2 * MINUTE)
    {
        return @"a minute ago";
    }
    if (delta < 45 * MINUTE)
    {
        int minutes = floor((double)delta/MINUTE);
        return [NSString stringWithFormat:@"%d minutes ago", minutes];
    }
    if (delta < 90 * MINUTE)
    {
        return @"an hour ago";
    }
    if (delta < 24 * HOUR)
    {
        int hours = floor((double)delta/HOUR);
        return [NSString stringWithFormat:@"%d hours ago", hours];
    }
    if (delta < 48 * HOUR)
    {
        return @"yesterday";
    }
    if (delta < 30 * DAY)
    {
        int days = floor((double)delta/DAY);
        return [NSString stringWithFormat:@"%d days ago", days];
    }
    if (delta < 12 * MONTH)
    {
        int months = floor((double)delta/MONTH);
        return months <= 1 ? @"one month ago" : [NSString stringWithFormat:@"%d months ago", months];
    }
    else
    {
        int years = floor((double)delta/MONTH/12.0);
        return years <= 1 ? @"one year ago" : [NSString stringWithFormat:@"%d years ago", years];
    }
}
@end
