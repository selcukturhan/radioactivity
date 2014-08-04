//
//  MeasuringDetailView.h
//  radioactivity
//
//  Created by Selcuk Turhan on 11.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODLData.h"
#import "MeasuringMapPoint.h"

@interface MeasuringDetailView : UIViewController {
    IBOutlet UILabel*       zipValue;
    IBOutlet UILabel*       dateValue;
    IBOutlet UILabel*       measurementValue;
    MeasuringMapPoint*      detailData;
}
@property (nonatomic, retain)  MeasuringMapPoint* detailData;

@end
