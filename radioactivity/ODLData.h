//
//  ODLData.h
//  radioactivity
//
//  Created by Selcuk Turhan on 29.06.11.
//  Copyright 2011 own. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ODLData : NSObject <NSCoding> {
    NSString*   zip;
    NSString*   locale;
    NSNumber*   longitude;
    NSNumber*   latitude;
    NSDate*     date;
    NSNumber*   measurement;
}

@property(nonatomic, retain) NSString*   zip;
@property(nonatomic, retain) NSString*   locale;
@property(nonatomic, retain) NSNumber*   longitude;
@property(nonatomic, retain) NSNumber*   latitude;
@property(nonatomic, retain) NSDate*     date;
@property(nonatomic, retain) NSNumber*   measurement;

@end
