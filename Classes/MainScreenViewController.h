//
//  MainScreenViewController.h
//  Momo_3
//
//  Created by Mikhail Lushin on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MOMO_CONN_TYPE_NONE,
	MOMO_CONN_TYPE_VERSION_REQ,
	MOMO_CONN_TYPE_GET_DEAL_LIST,
	MOMO_CONN_TYPE_MAX
} MOMO_CONN_TYPE;


#define MOMO_MARCOPOLO_SVC @"momo-marcopolosrvc"
#define MOMO_GAGARIN_SVC   @"momo-gagarinsrvc"
#define MOMO_SOAP_REQUEST_FORMAT_1 @"<?xml version='1.0' encoding='UTF-8'?>  \
<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\"> \
<SOAP-ENV:Body> \
<ns1:%@ xmlns:ns1=\"urn:%@\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">  \
</ns1:%@> \
</SOAP-ENV:Body> \
</SOAP-ENV:Envelope>"

#define MOMO_SOAP_REQUEST_FORMAT_2 @"<?xml version='1.0' encoding='UTF-8'?> \\
<SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">\
<SOAP-ENV:Body>\
<ns1:%@ xmlns:ns1=\"urn:@%\"\
SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\
<%@ xmlns:ns2=\"urn:%@\" xsi:type=\"ns2:%@\">\
<verStr xsi:type=\"xsd:string\">%@</verStr>\
</%@>\
</ns1:getFeedInfo>\
</SOAP-ENV:Body>\
</SOAP-ENV:Envelope>"

#define MOMO_SOAP_REQUEST_COMMON_START \
@"<?xml version='1.0' encoding='UTF-8'?> \
  <SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\"> \
  <SOAP-ENV:Body>"


#define MOMO_SOAP_REQUEST_COMMON_END \
@"</ns1:getFeedInfo>\
  </SOAP-ENV:Body>\
  </SOAP-ENV:Envelope>"

#define MOMO_SOAP_REQUEST_METHOD_TAG_OPEN \
@"<ns1:%@ xmlns:ns1=\"urn:%@\" SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"

#define MOMO_SOAP_REQUEST_METHOD_TAG_CLOSE \
@"</@%"

typedef enum {
	MAIN_SCREEN_STATE_NONE,
	MAIN_SCREEN_STATE_VER_RET,
	MAIN_SCREEN_STATE_VER_PARSE,
	MAIN_SCREEN_STATE_CONT_LOC_RET,
	MAIN_SCREEN_STATE_CONT_LOC_PARSE,
	MAIN_SCREEN_STATE_CONT_PARSE,
	MAIN_SCREEN_STATE_MAX

} MAIN_SCREEN_STATE;


#define CONTENT_STORAGE				[ContentStorageClass sharedInstance]
#define INDEX_FROM_PATH(indexPath)  [indexPath indexAtPosition:[indexPath length] - 1]

@interface MainScreenViewController : UIViewController {
    UITableView     * myTableView; 
    UIActivityIndicatorView * activityIndicator; 
    UIBarButtonItem         * signInButton; 
    
	NSMutableData   * rspData;
	NSURLConnection * urlConnection;
	NSXMLParser     * xmlParser; 

    UISearchBar     * srchBar; 
   // UITableView     * tableView; 
	
	// Global vars
	int        currentState;
	NSMutableString		* srvVersion;
	NSString			* currentElement;
	NSMutableString     * currentElementStr;
	//NSMutableArray		* dealArray;
	NSMutableDictionary * currentDeal; 
    
    

	
}

@property (nonatomic, retain) NSMutableData   * rspData;
@property (nonatomic, retain) NSURLConnection * urlConnection;
@property (nonatomic, retain) NSXMLParser     * xmlParser;
@property int currentState;
@end


@interface ContentStorageClass: NSObject {
	NSMutableString		* srvVersion;
	NSMutableArray		* dealArray;
    NSMutableArray      * tableContents; 
	int                   currIndex;
	
}
@property (assign) NSMutableArray		* dealArray;
@property (assign) NSMutableArray       * tableContents;
@property (assign) int					  currIndex;
+ (ContentStorageClass *)sharedInstance;
@end