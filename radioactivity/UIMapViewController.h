//
//  UIMapViewController.h
//  radioactivity
//
//  Created by Selcuk Turhan on 01.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "DataDownloadFinishedDelegate.h"
#import "SynchronizationService.h"

@class MeasuringDetailView;

@interface UIMapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, DataDownloadFinishedDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UIActivityIndicatorView* activityIndicator;
    UIView *overlay;
    
    
    CLLocationManager *locationManager;
    CLLocation*	currentLocation;
    
    MeasuringDetailView* measuringDetailView;
    NSMutableArray * measuringMapPoints;
    
    SynchronizationService* synchService;
}


-(void) setMeasuringMapPoints:(NSMutableArray *) measuringMapPoints;
@property (nonatomic, retain) CLLocation*          currentLocation;

@property (nonatomic, retain) SynchronizationService* synchService;
@property (nonatomic, retain) CLLocationManager*   locationManager;
@property (nonatomic, retain) UIView*						overlay;
@end
