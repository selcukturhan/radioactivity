//
//  MeasuringDetailView.m
//  radioactivity
//
//  Created by Selcuk Turhan on 11.07.11.
//  Copyright 2011 own. All rights reserved.
//

#import "MeasuringDetailView.h"
#import "ODLData.h"

@implementation MeasuringDetailView

@synthesize detailData;

- (id)init
{
	return [super initWithNibName:@"MeasuringDetailView" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
	return [self init];
}


- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// Use properties of incoming possession to change user interface
	[zipValue setText:   self.detailData.odlData.zip];
	//[localeValue setText:self.detailData.odlData.locale];
    
    NSLog(@"%@",self.detailData.odlData.measurement);
    NSString* value = [[self getNumberFormatter]stringForObjectValue:self.detailData.odlData.measurement];
    [measurementValue setText:value];
    
    // Use filtered NSDate object to return string to set dateLabel contents
	[dateValue setText:[[self getDateFormatter] stringFromDate: self.detailData.odlData.date]];
	// Change the nav item to display name of possession
	[[self navigationItem] setTitle:self.detailData.odlData.locale];
}

-(NSNumberFormatter*) getNumberFormatter{
    static NSNumberFormatter* numberFormatter;
    
    if(numberFormatter == nil){
        numberFormatter= [[NSNumberFormatter alloc]init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
       
    }
    return numberFormatter;
}

-(NSDateFormatter*)getDateFormatter{
    static NSDateFormatter* dateFormatter;
    
    if(dateFormatter == nil){
        dateFormatter= [[NSDateFormatter alloc]init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    return dateFormatter;

}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];	
    
       
}
- (void)viewDidLoad
{
	[super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]]; 
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[zipValue release];
	zipValue = nil;
    
	[measurementValue release];
	measurementValue = nil;
    
    [dateValue release];
    dateValue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
