//
//  MeasuringMapPoint.m
//  radioactivity
//
//  Created by Selcuk Turhan on 01.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import "MeasuringMapPoint.h"


@implementation MeasuringMapPoint



@synthesize coordinate, title, odlData, subtitle;

- (id)initWithOdlData:(ODLData*) aOdlData
{
	self = [super init];
	odlData = aOdlData;
	self.title = [aOdlData locale];
    self.subtitle = [odlData zip];
 	coordinate.longitude = [[aOdlData latitude] doubleValue];
    coordinate.latitude = [[aOdlData longitude] doubleValue];
	return self;
}


- (void)dealloc {
    [title release];
    [subtitle release];
    [odlData release];
    [super dealloc];
}
@end
