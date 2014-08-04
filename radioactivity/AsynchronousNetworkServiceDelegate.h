//
//  AsynchronousNetworkServiceDelegate.h
//  iActiviti
//
//  Created by Selcuk Turhan on 30.06.10.
//  Copyright 2010 own. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AsynchronousNetworkServiceDelegate <NSObject>
@optional
- (void) didReceiveData:		(NSData *) theData;
- (void) didReceiveFilename:	(NSString *) aName;
- (void) dataDownloadFailed:	(NSString *) reason;
- (void) dataDownloadAtPercent: (NSNumber *) aPercent;
@end


