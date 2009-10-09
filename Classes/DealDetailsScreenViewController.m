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

@synthesize dealName, merchantName, description;

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
