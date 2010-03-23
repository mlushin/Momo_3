//
//  OptionsScreenViewController.h
//  Momo_3
//
//  Created by Mikhail Lushin on 9/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OptionsScreenViewController : UITableViewController {
	UITableView * optoinsTable;  

}

typedef enum {
    OPTIONS_SCREEN_SELECTION_SETTINGS = 0,
    OPTIONS_SCREEN_SELECTION_RECENTS,
    OPTIONS_SCREEN_SELECTION_MAX
} OPTIONS_SCREEN_SELECTION;

@property (nonatomic, retain) UITableView * optionsTable;

@end
