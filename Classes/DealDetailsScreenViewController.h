//
//  DealDetailsScreenViewController.h
//  Momo_3
//
//  Created by Mikhail Lushin on 10/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DealDetailsScreenViewController : UIViewController {
	
	IBOutlet UITextView * merchantName;
	IBOutlet UITextView * dealName;
	IBOutlet UITextView * description;
	
    IBOutlet MKMapView * mapView; 

}


@property (nonatomic, retain)	IBOutlet UITextView * merchantName;
@property (nonatomic, retain)	IBOutlet UITextView * dealName;
@property (nonatomic, retain)	IBOutlet UITextView * description;
@property (nonatomic, retain)   IBOutlet MKMapView  * mapView;

@end
