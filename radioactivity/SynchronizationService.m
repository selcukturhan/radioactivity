//
//  ActivityService.m
//  iActiviti
//
//  Created by Selcuk Turhan on 30.06.10.
//  Copyright 2010 own. All rights reserved.
//

#import "AsynchronousNetworkService.h"
#import "SynchronizationService.h"
#import "DataInfrastructureSetUpService.h"
#import "ISO8601DateFormatter.h"
#import "DataDownloadFinishedDelegate.h"

@implementation SynchronizationService
@synthesize dataDownloadFinisheddelegate;


- (id) initWithDelegate:(id <DataDownloadFinishedDelegate>) aDataDownloadFinishedDelegate{
	if((self = [super init])){
		self.dataDownloadFinisheddelegate = aDataDownloadFinishedDelegate;
    }
	return self;
}



- (void) didReceiveData:(NSData *) theData{
	
    //no update is required
    if(theData == nil || [theData length] == 0){
        NSLog(@"No Data received");
        return;
    }
   
    NSData* data = theData;
    NSString* tmp = [[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding]autorelease];
	NSDictionary* dictionary = [tmp JSONValue];
    DataInfrastructureSetUpService* d = [[[DataInfrastructureSetUpService alloc]init]autorelease];
    NSMutableArray* odls = [d getPayLoad: dictionary];
    [self.dataDownloadFinisheddelegate didFinishedDataSetup:odls];
}



-(void) synchronizeData{
    //prepare url
    
	[AsynchronousNetworkService sharedInstance].delegate = self;
    [AsynchronousNetworkService sharedInstance].username = @"freedom4x2";
    [AsynchronousNetworkService sharedInstance].password = @"4477b67b4b";
    [AsynchronousNetworkService download: URL_SYNCHRONIZATION_SERVICE];
    
    
}


- (void) dataDownloadFailed:(NSString *) reason{
	if (self.dataDownloadFinisheddelegate && [self.dataDownloadFinisheddelegate respondsToSelector:@selector(dataDownloadFailed:)]){
		[self.dataDownloadFinisheddelegate dataDownloadFailed:reason];
	}
}


- (NSDate*) getStringAsDate:(NSString*) dateString{
    return [[[[ISO8601DateFormatter alloc]init]autorelease]dateFromString:dateString];  
}


- (NSString*) getDateAsString:(NSDate*) date{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];  
    return [dateFormatter stringFromDate:date];
}

- (void)dealloc {
    self.dataDownloadFinisheddelegate = nil;
    [super dealloc];
}
@end
