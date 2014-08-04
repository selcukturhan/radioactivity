//
//  ActivityService.h
//  iActiviti
//
//  Created by Selcuk Turhan on 30.06.10.
//  Copyright 2010 own. All rights reserved.
//




#import "DataDownloadFinishedDelegate.h"
#import "AsynchronousNetworkServiceDelegate.h"


#define URL_SYNCHRONIZATION_SERVICE @"http://radioactivityupdateservice.appspot.com/resources/updateService/getUpdate"
//#define URL_SYNCHRONIZATION_SERVICE @"http://localhost:8888/resources/updateService/getUpdate"


@interface SynchronizationService : NSObject<AsynchronousNetworkServiceDelegate>{
	id <DataDownloadFinishedDelegate> dataDownloadFinisheddelegate;
}

@property(nonatomic, retain) id <DataDownloadFinishedDelegate> dataDownloadFinisheddelegate;
-(void) synchronizeData;
@end
