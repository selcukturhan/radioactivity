//
//  UIMapViewController.m
//  radioactivity
//
//  Created by Selcuk Turhan on 01.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import "UIMapViewController.h"
#import "MeasuringDetailView.h"
#import "ODLData.h"


@implementation UIMapViewController
@synthesize currentLocation, locationManager, overlay, synchService;

-(id)init{
    self = [super initWithNibName:@"UIMapViewController" bundle:nil];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDistanceFilter:kCLDistanceFilterNone];   
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager startUpdatingLocation];
    }
    return self;
}


-(void)showDelay{
    self.overlay = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.overlay setBackgroundColor: [UIColor colorWithWhite:0.7f alpha:0.5f] ];
	[self.overlay addSubview: activityIndicator];
    [mapView addSubview: self.overlay];
	[activityIndicator	startAnimating];
}

-(void)endDelay{
    [activityIndicator stopAnimating];
	[self.overlay removeFromSuperview];
}


- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
	//handle currentLocation annotation
	if (annotation == mapView.userLocation){
		return nil;
	}
	
	//handle incident annotations
    static NSString *AnnotationViewID = @"measuringpoint";
	MKPinAnnotationView* measuringPoint	= (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
	if(measuringPoint == nil) {
		measuringPoint								= [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID]autorelease];
		measuringPoint.animatesDrop					= NO;
		measuringPoint.canShowCallout				= YES;
		UIButton* button							= [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		measuringPoint.rightCalloutAccessoryView	= button;
		measuringPoint.annotation					= annotation;
    }
	return measuringPoint;
}


- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
   
    mapView.delegate = self;
    //disable further location for the moment
	self.locationManager.delegate = nil;
	[self.locationManager stopUpdatingLocation];
	// Set the current location
	self.currentLocation = newLocation;
	// Set the map to that location and allow user interaction
	mapView.region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.5f, 0.5f));
    mapView.zoomEnabled = YES;
}



-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
	[self endDelay];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Do I need to create the instance of measuringDetailView?
	if (!measuringDetailView) {
		measuringDetailView = [[MeasuringDetailView alloc] init];
	}
	// Give detail view controller a pointer to the possession object in this row
    measuringDetailView.detailData = view.annotation;
    
	// Push it onto the top of the navigation controller's stack
	[[self navigationController] pushViewController:measuringDetailView animated:YES];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

#pragma UPDATE_STUFF

-(void) doUpdateStuff{
    [self showDelay];
    NSString *odlDataPath = pathInDocumentDirectory(@"ODLData.data");
    
    if([self dataSynchronisationRequired:odlDataPath]){
        self.synchService = [[SynchronizationService alloc]initWithDelegate: self];
        [self.synchService synchronizeData];
    } else {
        [self getOdlDataFromArchive];    
    }
}


- (void) getOdlDataFromArchive{
    // Unarchive it in to an array
    NSString *odlDataPath = pathInDocumentDirectory(@"ODLData.data");

    NSMutableArray *odlDataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:odlDataPath];
    [odlDataArray retain];
    NSArray* measuringMapPoints = [self transferOdlData2MeasuringMapPoints: odlDataArray];
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotations:measuringMapPoints];
} 


- (void) didFinishedDataSetup:(NSMutableArray *) measuringMapPoints{
    
    NSMutableArray* annotations = [self transferOdlData2MeasuringMapPoints: measuringMapPoints];
    [annotations retain];
    //archive fresh odls
    if (annotations == nil || [annotations count] == 0) {
       // UIAlertView* dataDownalertView
    } else {
        [NSKeyedArchiver archiveRootObject:measuringMapPoints toFile: pathInDocumentDirectory(@"ODLData.data")];
        [mapView removeAnnotations:mapView.annotations];
        [mapView addAnnotations:annotations];
    }
    [annotations release];
    
    [self.synchService release];
    self.synchService = nil;
}

- (void) dataDownloadFailed:(NSString *) reason{
    UIAlertView* alertView = [[[UIAlertView alloc]  initWithTitle: @"Fehler beim Update"
                                                    message: @"Das Update ist fehlgeschlagen. Bitte überprüfen Sie Ihre Internetverbindung und starten Sie das Programm neu! Falls vorhanden, werden die Daten letzen Update angezeigt"
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil,
                                                    nil]
                                                    autorelease];
    [alertView show];
    [self getOdlDataFromArchive];

}


-(NSMutableArray*) transferOdlData2MeasuringMapPoints:(NSMutableArray*)aMeasuringMapPoints{
    
    NSMutableArray* annotations = [[[NSMutableArray alloc]init]autorelease];
    
    for (ODLData* odlData in aMeasuringMapPoints) {
        MeasuringMapPoint *tmpMapPoint = [[MeasuringMapPoint alloc] initWithOdlData:odlData];
        [annotations addObject:tmpMapPoint];
        [tmpMapPoint release];
        tmpMapPoint = nil;
    }
    return annotations;
}

-(BOOL) dataSynchronisationRequired:(NSString*) odlDataPath{
    return TRUE;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath: odlDataPath])
        return TRUE;
    
    NSError* error;
    NSDictionary* attrs = [fileManager attributesOfItemAtPath:odlDataPath error:&error];
    
    if(!error){
        NSLog(@"Error during file-properties read: %@ ", [error localizedDescription]);
    }
    
    NSCalendar* currentCalendar =  [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]; 
    
    [currentCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
    
    NSDateComponents* thresholdComponent = [currentCalendar components: NSYearCalendarUnit  |
                                                                        NSMonthCalendarUnit |
                                                                        NSDayCalendarUnit   |
                                                                        NSHourCalendarUnit  |
                                                                        NSMinuteCalendarUnit|
                                                                        NSSecondCalendarUnit 
                                                            fromDate:   [[NSDate alloc]init]];
    
    [thresholdComponent setHour:    16];
	[thresholdComponent setMinute:  30];
	[thresholdComponent setSecond:   0];
    
    NSDate* threshold = [currentCalendar dateFromComponents:thresholdComponent];
    NSLog(@"Date threshold: %@", [threshold description]);
    //TODO: Error handling
    if (attrs != nil) {
        NSDate *creationDate = (NSDate*)[attrs objectForKey: NSFileCreationDate];
        NSLog(@"Date file was created: %@", [creationDate description]);
        return [threshold compare:creationDate] == NSOrderedDescending;
    } else {
        NSLog(@"No creation Date found");
        return FALSE;
    }
}

-(void) setMeasuringMapPoints:(NSMutableArray *) aMeasuringMapPoints
{
    [aMeasuringMapPoints retain];
    [self endDelay];
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotations:aMeasuringMapPoints];
    [aMeasuringMapPoints release];
}

- (void)dealloc
{   
    [mapView release];
    [activityIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.showsUserLocation = YES;
    [self doUpdateStuff];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
