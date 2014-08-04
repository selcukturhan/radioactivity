//
//  RestService.h
//  iActiviti
//
//  Created by Selcuk Turhan on 24.06.10.
//  Copyright 2010 own. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousNetworkServiceDelegate.h"

#define DELEGATE_CALLBACK(X, Y) if (sharedInstance.delegate && [sharedInstance.delegate respondsToSelector:@selector(X)]) [sharedInstance.delegate performSelector:@selector(X) withObject:Y];
#define NUMBER(X) [NSNumber numberWithFloat:X]



@interface AsynchronousNetworkService : NSObject<NSURLAuthenticationChallengeSender>{
	NSURLResponse *response;
	NSMutableData *data;
	NSString *urlString;
	NSString *password;
	NSString *username;
	NSURLConnection *urlconnection;
	id <AsynchronousNetworkServiceDelegate> delegate;
	BOOL isDownloading;
}

@property (retain) NSString*			password;
@property (retain) NSString*			username;
@property (retain) NSURLResponse*		response;
@property (retain) NSURLConnection*		urlconnection;
@property (retain) NSMutableData*		data;
@property (retain) NSString*			urlString;
@property (retain) id					delegate;
@property (assign) BOOL					isDownloading;

+ (AsynchronousNetworkService *)		sharedInstance;
+ (void) download:(NSString *)			aURLString;
+ (void) cancel;
@end
