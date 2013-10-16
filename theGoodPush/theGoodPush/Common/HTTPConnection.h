//
//  HTTPConnection.h
//  theGoodPush
//
//  Created by Justin Hyland on 8/27/13.
//  Copyright (c) 2013 Justin Hyland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@class HTTPConnection;

@protocol HTTPConnectionDelegate <NSObject>
- (void)dataReceivedWithHandler:(HTTPConnection*)handler Data:(NSData *)data;
- (void)responseReceivedWithHandler:(HTTPConnection*)handler Response:(NSURLResponse *)response;
@end

@interface HTTPConnection : NSObject

-(id)initWithServiceEndpointUrl:(NSString*)url;
-(void)setDelegate:(id<HTTPConnectionDelegate>)delegate;

@property (nonatomic, retain) NSString *action;

-(NSURLConnection*)processNSConnectionRequest:(NSString *)url;
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod;
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod Parms:(NSDictionary*)parms;
-(NSURLConnection*)processNSConnectionRequest:(NSString*)Action Method:(NSString*)HTTPMethod Parms:(NSDictionary*)parms PostData:(NSData*)postData;

@end
