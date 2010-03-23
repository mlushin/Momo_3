//
//  SignInScreenViewController.m
//  Momo_3
//
//  Created by Mikhail Lushin on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SignInScreenViewController.h"


@implementation SignInScreenViewController

@synthesize usernameField, passwordField, signInButton;

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
    usernameField.delegate = self;
    passwordField.delegate = self;
    passwordField.secureTextEntry = YES;

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


/*---------------------------------------------
 
 UI TEXT FIELD IMPLEMENTATION
 
 ----------------------------------------------*/
 - (void)textFieldShouldReturn:(UITextField *)textField 
{
    
    [textField resignFirstResponder];
}


- (IBAction)signInButtonPressed:(id)sender 
{
    if ([usernameField.text length] != 0 &&
        [passwordField.text length] != 0)
    {
        NSUserDefaults * login = [NSUserDefaults standardUserDefaults];
      
        [login setObject:usernameField.text forKey:@"Momo_username"];
        [login setObject:passwordField.text forKey:@"Momo_password"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
