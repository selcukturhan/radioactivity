//
//  Utilities.h
//  iSharkHistory
//
//  Created by Selcuk Turhan on 03.03.11.
//  Copyright 2011 own. All rights reserved.
//




@interface Utilities : NSObject {

}
+ (NSString*) getFormattedDate: (NSDate*) aDate;
NSString *pathInDocumentDirectory(NSString *fileName);
@end
