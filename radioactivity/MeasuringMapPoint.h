//
//  MeasuringMapPoint.h
//  radioactivity
//
//  Created by Selcuk Turhan on 01.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "OdlData.h"

@interface MeasuringMapPoint : NSObject<MKAnnotation> {
    NSString* title;
    NSString* subtitle;
    CLLocationCoordinate2D coordinate;
    ODLData* odlData;
    
   
    
}
@property(nonatomic, readonly)  CLLocationCoordinate2D coordinate;
@property(nonatomic, retain)    NSString* title;
@property(nonatomic, retain)    NSString* subtitle;
@property(nonatomic, retain)    ODLData* odlData;
@end
