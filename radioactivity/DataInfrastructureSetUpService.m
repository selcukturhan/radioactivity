//
//  DataInfrastructureSetUpService.m
//  iSharkHistory
//
//  Created by Selcuk Turhan on 21.02.11.
//  Copyright 2011 own. All rights reserved.
//

#import "DataInfrastructureSetUpService.h"
#import "OdlData.h"
#import "ISO8601DateFormatter.h"

@implementation DataInfrastructureSetUpService

- (id) init{
	if(self = [super init]){
    }
	return self;
}


- (NSMutableArray*) getPayLoad: (NSDictionary*)receivedOdls {
	//    ----------
	NSArray *aRow, *aData;
    NSMutableArray* odls = [[NSMutableArray alloc]init]; 
	NSArray *receivedOdlArray = [receivedOdls objectForKey:@"odlData"];
    
    for (NSDictionary* odlData in receivedOdlArray) {
        [odls addObject:[self processReceivedOdlData: odlData]];
    }
    return odls;
}


-(ODLData*) processReceivedOdlData:(NSDictionary*) receivedOdl{
    ODLData* odlData = [[[ODLData alloc]init]autorelease];
    
    odlData.locale      = (NSString*)[receivedOdl objectForKey:@"locale"];
    odlData.zip         = (NSNumber*)[receivedOdl objectForKey:@"zip"];
    odlData.date        = [self getStringAsDate:(NSString*)[receivedOdl objectForKey:@"date"]];
    odlData.latitude    =   [NSNumber numberWithDouble:[[receivedOdl objectForKey:@"latitude"]doubleValue]];
    odlData.longitude   =   [NSNumber numberWithDouble:[[receivedOdl objectForKey:@"longitude"]doubleValue]];
    odlData.measurement  = [NSNumber numberWithDouble:[[receivedOdl objectForKey:@"measurement"]doubleValue]];

    return odlData;
}


- (NSDate*) getStringAsDate:(NSString*) dateString{
    return [[[[ISO8601DateFormatter alloc]init]autorelease]dateFromString:dateString];  
}


-(BOOL) handleJavaBool: (NSString*) boolValue{
	if(boolValue != nil){
		return ([boolValue isEqualToString: @"true"]) ? YES : NO; 
	}
	return nil;
}


- (NSDate *) nilDate {
	//        -------
	NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"01/01/0001"];
	
	NSDate *dValue = [oFormat dateFromString:@"01/01/0001"];
	
	[oFormat release];
	
	return dValue;
}

- (NSDate *) asDate: (NSString*) timeIndication {
	//        ------
	// YYYY-MM-DD HH:MM -> Datum
	// siehe http://unicode.org/reports/tr35/tr35-6.html#Date%5FFormat%5FPatterns
	if (timeIndication == nil) {
		return [self nilDate];
	}
	
	static NSDateFormatter *oDateFormatter = nil;
	
	if (oDateFormatter == nil) {
		NSLocale *oLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		oDateFormatter = [[NSDateFormatter alloc] init];
		oDateFormatter.locale = oLocale;
		//[oDateFormatter release];
		[oLocale release];
	}
	
	oDateFormatter.dateFormat = @"dd-MMM-yyyy";
	NSDate *dValue = [oDateFormatter dateFromString:timeIndication];
	
	
	
	return dValue;
}




-(NSDate*)normalizeDate:(NSDate*) date{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
	NSUInteger mask =	NSYearCalendarUnit | NSMonthCalendarUnit |
						NSDayCalendarUnit  | NSHourCalendarUnit  |
						NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
    NSDateComponents *components = [gregorian components: mask fromDate: date];
	
	[components setHour:    0];
	[components setMinute:  0];
	[components setSecond:  0];
	
	return [gregorian dateFromComponents: components];
	
}


@end
