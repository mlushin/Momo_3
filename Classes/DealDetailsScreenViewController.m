//
//  DealDetailsScreenViewController.m
//  Momo_3
//
//  Created by Mikhail Lushin on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DealDetailsScreenViewController.h"
#import "MainScreenViewController.h"


@implementation DealDetailsScreenViewController

@synthesize dealName, merchantName, description, mapView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dealName setText:[[[CONTENT_STORAGE dealArray] objectAtIndex:[CONTENT_STORAGE currIndex]]	
                            objectForKey:@"DealName"]];
    [self.merchantName setText:[[[CONTENT_STORAGE dealArray] objectAtIndex:[CONTENT_STORAGE currIndex]]	
                            objectForKey:@"Merchant"]];
    [self.description setText:[[[CONTENT_STORAGE dealArray] objectAtIndex:[CONTENT_STORAGE currIndex]]	
                            objectForKey:@"Description"]];
    
    
    //mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 5, 5, 310, 150)];
    //[self.view addSubview:mapView];
    
    mapView.showsUserLocation = TRUE;
    mapView.delegate = self;
    
    
    MKCoordinateRegion region; 
    region.center.latitude = 40.814849;
    region.center.longitude = -73.622732;//mapView.userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.2;
    region.span.longitudeDelta = 0.2;
    
    [mapView setRegion:region animated:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
