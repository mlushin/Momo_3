//
//  SettingsScreenViewController.h
//  Momo_3
//
//  Created by Mikhail Lushin on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsScreenViewController : UIViewController {

    IBOutlet UIButton * logOutButton; 
}

@property (nonatomic, retain) IBOutlet UIButton * logOutButton;

- (IBAction)buttonPressed:(id)sender;

@end
