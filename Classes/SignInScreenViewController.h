//
//  SignInScreenViewController.h
//  Momo_3
//
//  Created by Mikhail Lushin on 10/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignInScreenViewController : UIViewController {
    
    IBOutlet UITextField * usernameField;
    IBOutlet UITextField * passwordField;
    IBOutlet UIButton    * signInButton;

}

@property (nonatomic,retain)  IBOutlet UITextField * usernameField;
@property (nonatomic,retain)  IBOutlet UITextField * passwordField;
@property (nonatomic,retain)  IBOutlet UIButton * signInButton;
- (IBAction)signInButtonPressed:(id)sender;
@end
