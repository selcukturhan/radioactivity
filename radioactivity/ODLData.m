//
//  ODLData.m
//  radioactivity
//
//  Created by Selcuk Turhan on 29.06.11.
//  Copyright 2011 own. All rights reserved.
//

#import "OdlData.h"


@implementation ODLData


@synthesize zip;
@synthesize locale;
@synthesize longitude;
@synthesize latitude;
@synthesize date;
@synthesize measurement;



- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:zip forKey:@"zip"];
	[encoder encodeObject:locale forKey:@"locale"];
	[encoder encodeObject:longitude forKey:@"longitude"];
	[encoder encodeObject:latitude forKey:@"latitude"];
    [encoder encodeObject: date forKey:@"date"];
	[encoder encodeObject:measurement forKey:@"measurement"];
}


- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super init];
	
	// For each instance variable that is archived, we decode it,
	// and pass it to our setters. (Where it is retained)
	[self setZip:[decoder decodeObjectForKey:@"zip"]];
	[self setLocale:[decoder decodeObjectForKey:@"locale"]];
	[self setLongitude:[decoder decodeObjectForKey:@"longitude"]];
	[self setLatitude: [decoder decodeObjectForKey:@"latitude"]];
    [self setDate: [decoder decodeObjectForKey:@"date"]];
	[self setMeasurement: [decoder decodeObjectForKey:@"measurement"]];
	
	
	return self;
}


- (void)dealloc {
    [zip release];
    [locale release];
    [longitude release];
    [latitude release];
    [date release];
    [measurement release];
    [super dealloc];
}

@end
