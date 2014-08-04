//
//  DataDownloadFinishedDelegate.h
//  radioactivity
//
//  Created by Selcuk Turhan on 03.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataDownloadFinishedDelegate <NSObject>

@required
- (void) didFinishedDataSetup:(NSMutableArray *) measuringMapPoints;
- (void) dataDownloadFailed:(NSString *) reason;
@end
