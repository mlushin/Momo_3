//
//  MainScreenViewController.m
//  Momo_3
//
//  Created by Mikhail Lushin on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MainScreenViewController.h"
#import "MerchantViewController.h"
#import "SignInScreenViewController.h"


@implementation MainScreenViewController

@synthesize rspData;
@synthesize urlConnection, currentState;

int connectionType;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*---------------------------------------------------------------------------------------------------------------
 FUNC: callServerMethod
 
 Provides an interface to call a soap method on the server
 
 PARAMS: body - body of the soap request
 ---------------------------------------------------------------------------------------------------------------*/
- (BOOL)callServerMethod:(NSString*)body {
	
	//Create a URL, URL request and body length
	NSURL * url = [[NSURL alloc] initWithString:@"http://momo.webhop.net:8080/soap/servlet/rpcrouter"];
	NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	NSString *bodyLen = [NSString stringWithFormat:@"%d", [body length]];
	//NSString * body = [NSString stringWithFormat:MOMO_SOAP_REQUEST_FORMAT,@"urn:momo-gagarinsrvc",@"getList"];
	
	// Set up URL request
	[urlRequest setHTTPMethod:@"POST"];	
	[urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest addValue:bodyLen forHTTPHeaderField:@"Content-Length"];
	[urlRequest addValue:@"http://momo.webhop.net:8080/soap/servlet/rpcrouter" forHTTPHeaderField:@"SOAPAction"];
	[urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
		
	// Create a new connection of one does not yet exist (if it does, start it);
	if (urlConnection == nil) {
		[urlConnection release];
	}
	
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];	
	if (urlConnection != nil) {
		[rspData setLength:0];
		rspData = [[NSMutableData data] retain];
		[urlConnection start];
	} else {
		NSLog(@"cannot connect");
		return FALSE;
	}
	
	
	return TRUE;
}


/*---------------------------------------------------------------------------------------------------------------
 FUNC: getServerVersion
 
  Get server version
 
 PARAMS: body - body of the soap request
 ---------------------------------------------------------------------------------------------------------------*/
- (BOOL)getServerVersion {
	if (connectionType != MOMO_CONN_TYPE_NONE) {
		NSLog(@"Already connecting");
		return FALSE;
	}
	
	NSString * body = [NSString stringWithFormat:MOMO_SOAP_REQUEST_FORMAT_1,@"getVersion",MOMO_MARCOPOLO_SVC, @"getVersion"];
	BOOL bRet = [self callServerMethod:body];
	
	if (bRet) {
		connectionType = MOMO_CONN_TYPE_VERSION_REQ;
	}
	return bRet;
}

												  

/*---------------------------------------------------------------------------------------------------------------
 FUNC: getContentInfo
 
 Get server version
 
 PARAMS: body - body of the soap request
 ---------------------------------------------------------------------------------------------------------------*/												  
- (BOOL)getContentList {
	if (connectionType != MOMO_CONN_TYPE_NONE) {
		NSLog(@"Already connecting");
		return FALSE;
	}
	
	// Construct the body, need to make it neater later	
	NSString * body = [NSString stringWithFormat:@"<?xml version='1.0' encoding='UTF-8'?> \
					   <SOAP-ENV:Envelope xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/1999/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/1999/XMLSchema\">\
					   <SOAP-ENV:Body>\
					   <ns1:getFeedInfo xmlns:ns1=\"urn:momo-gagarinsrvc\"\
					   SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">\
					   <gagarininfo xmlns:ns2=\"urn:momo-gagarinsrvc-feedreq\" xsi:type=\"ns2:gagarininfo\">\
					   <verStr xsi:type=\"xsd:string\">00.00</verStr>\
					   </gagarininfo>\
					   </ns1:getFeedInfo>\
					   </SOAP-ENV:Body>\
					   </SOAP-ENV:Envelope>"];
	
	
	BOOL bRet = [self callServerMethod:body];
	
	if (bRet) {
		connectionType = MOMO_CONN_TYPE_GET_DEAL_LIST;
	}
	return bRet;
}

	
-(void) parseXML:(BOOL)isURL fromSource:(id)source {
	// initialize XML parser
	if (xmlParser == nil) {
		xmlParser = [NSXMLParser alloc];
		[xmlParser setDelegate:self];
		//[xmlParser setShouldProcessNamespaces:YES];
		//[xmlParser setShouldReportNamespacePrefixes:NO];
		//[xmlParser setShouldResolveExternalEntities:NO];
	}
	
	if (isURL) {
		NSURL *xmlURL = [NSURL URLWithString:(NSString *)source];
		[xmlParser initWithContentsOfURL:xmlURL];
	} else {
		[xmlParser initWithData:(NSData *)source];
	}


	[xmlParser parse];
						 
}

-(void) transitionMainScreenState: (int) newState {

	switch (newState) {
		case MAIN_SCREEN_STATE_VER_RET:
			[self getServerVersion];
			break;
		case MAIN_SCREEN_STATE_VER_PARSE:
		case MAIN_SCREEN_STATE_CONT_LOC_PARSE:
			// Start parsing XML response
			[self parseXML:FALSE fromSource:rspData];
			break;
		case MAIN_SCREEN_STATE_CONT_LOC_RET:
			[self getContentList];
			break;


		default:
			break;
	}
}

/*---------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------
 NS XML PARSER DELEGATE IMPLEMENTATION
 ---------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------*/													  
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"Did end document");
	if (self.currentState == MAIN_SCREEN_STATE_CONT_PARSE) {
        
        [[CONTENT_STORAGE tableContents] addObjectsFromArray:[CONTENT_STORAGE dealArray]];
        [activityIndicator stopAnimating];
		[myTableView reloadData];
	}
	[self transitionMainScreenState:++self.currentState];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	NSLog(@"parsing %@ element", elementName);
	currentElement = [elementName copy];
	[currentElementStr setString:@""];
	if ([currentElement isEqualToString:@"Deal"]) {
		if (currentDeal == nil) {
			currentDeal = [[NSMutableDictionary alloc] init];
		}
		if (currentElementStr == nil) {
			currentElementStr = [[NSMutableString alloc] init];
		}
		if ([CONTENT_STORAGE dealArray] == nil) {
			NSMutableArray * array = [[NSMutableArray alloc] init];
			[CONTENT_STORAGE setDealArray:array];
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
	if ((self.currentState == MAIN_SCREEN_STATE_CONT_PARSE)) {
		if ([elementName isEqualToString:@"Deal"]) {
			// Deal ended 
			[[CONTENT_STORAGE dealArray] addObject:[currentDeal copy]];
		} else {
			
			[currentDeal setObject:[currentElementStr copy] forKey:[elementName copy]];
			[currentElementStr setString:@""];
		}
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"parser error %d", [parseError code]);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	switch (self.currentState) {
		case MAIN_SCREEN_STATE_VER_PARSE:
			if ( [currentElement isEqualToString:@"version"] ) {
				if (srvVersion == nil){
					srvVersion = [[NSMutableString alloc] init];;
				}
				[srvVersion appendString:string];
			}
			break;
		case MAIN_SCREEN_STATE_CONT_LOC_PARSE:
			if ( [currentElement isEqualToString:@"feedUriStr"] ) {
				// We got what we needed at this point, now parse the xml inside URL
				[xmlParser abortParsing];
				self.currentState++;
				// Something is wrong with the string
				[self parseXML:TRUE fromSource:string];
			}
			break;
		case MAIN_SCREEN_STATE_CONT_PARSE:
			//NSLog(@"Tag %@, val %@", currentElement, string);
			[currentElementStr appendString:string];
			break;
		default:
			break;
	}
		
}

/*---------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------
 NS URL CONNECTION DELEGATE IMPLEMENTATION
 ---------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------*/													  
-(void)connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"GotResponse!!!");
}

-(void)connection: (NSURLConnection *) connection didReceiveData:(NSData *)data {
	
	[rspData appendData:data];
}

-(void)connectionDidFinishLoading: (NSURLConnection *)connection {
	NSLog(@"**********************Finished loading got %d data", [rspData length]);

	// content loading finished
	NSString *responseStr = [[NSString alloc] initWithBytes:[rspData mutableBytes] length:[rspData length] encoding:NSUTF8StringEncoding];
	//NSLog(responseStr);
	NSLog(@"-------------------------------------------------------");
	[responseStr release];

	connectionType = MOMO_CONN_TYPE_NONE;
	self.currentState++;
	[self transitionMainScreenState:self.currentState];
	
	// If version was downloaded, download contetn list
/*	if (connectionType == MOMO_CONN_TYPE_VERSION_REQ) {
		connectionType = MOMO_CONN_TYPE_NONE;
		[self getContentList];
	}
*/    

	
		
}

- (void)loadSignInScreen {
        
    NSLog(@"Sign in screen loading");
    SignInScreenViewController * viewController = [[SignInScreenViewController alloc] initWithNibName:@"SignInScreenViewController" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"View did load");

    // Initialize main screen state
	self.currentState = MAIN_SCREEN_STATE_NONE;
	
    // Determine if SignIn button needs to be displayed
    NSUserDefaults * login = [NSUserDefaults standardUserDefaults];
    
    NSString * username = [login objectForKey:@"Momo_username"];
    NSString * password = [login objectForKey:@"Momo_password"];
    if ((username == nil) || ([username length] == 0) ||
        (password == nil) || ([password length] == 0)) {
        signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" 
                                                    style: UIBarButtonItemStyleBordered target:self action:@selector(loadSignInScreen)];
        self.navigationItem.rightBarButtonItem = signInButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        NSLog(@"%@ %@", username, password);
    }
    
	
	self.currentState++;
	[self transitionMainScreenState:self.currentState];
    
    //[self.tableView initWithStyle:CGRectMake(0, 31, 320, 400)];
    
    srchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,30)];
    srchBar.delegate = self;
    [self.view addSubview:srchBar];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,31, 320, 400)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50,50,50,50)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    
    // Allocate table contents
    if ([CONTENT_STORAGE tableContents] == nil) {
        [CONTENT_STORAGE setTableContents:[[NSMutableArray alloc] init]];
    }
                                

    /*self.searchDisplayController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;*/
	
}




- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSLog(@"View will appear");
    NSUserDefaults * login = [NSUserDefaults standardUserDefaults];
    NSString * username = [login objectForKey:@"Momo_username"];
    NSString * password = [login objectForKey:@"Momo_password"];
    if ((username == nil) || ([username length] == 0) ||
         (password == nil) || ([password length] == 0)) {
        signInButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" 
                                                        style: UIBarButtonItemStyleBordered target:self action:@selector(loadSignInScreen)];
        self.navigationItem.rightBarButtonItem = signInButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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


#pragma mark Table view methods
/*-----------------------------------------------------*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*-----------------------------------------------------*/
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[CONTENT_STORAGE tableContents] count];
}

/*-----------------------------------------------------*/
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	[cell.textLabel setText: [[[CONTENT_STORAGE tableContents] objectAtIndex:INDEX_FROM_PATH(indexPath)] objectForKey:@"Category"]];
    return cell;
}

/*-----------------------------------------------------*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	[CONTENT_STORAGE setCurrIndex:INDEX_FROM_PATH(indexPath)];
	
	MerchantViewController *merchantViewController = [[MerchantViewController alloc] initWithNibName:@"MerchantViewController" 
																							  bundle:[NSBundle mainBundle]];
	[self.navigationController pushViewController:merchantViewController animated:YES];
	[merchantViewController release];
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


/*---------------------------------------------
 
 SEARCH BAR IMPLEMENTATION
 
 ----------------------------------------------*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // When text begins editing, clear contents of the table
    srchBar.showsCancelButton = YES;
    [[CONTENT_STORAGE tableContents] removeAllObjects];
        
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Now find the entries with givne text
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Merchant beginswith %@)",searchText];
    NSArray * array = [[CONTENT_STORAGE dealArray] filteredArrayUsingPredicate:predicate];
    [[CONTENT_STORAGE tableContents] removeAllObjects];
    [[CONTENT_STORAGE tableContents] addObjectsFromArray:array];
    [myTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // Resign First Responder
    [searchBar resignFirstResponder];
    
    // Set table contents to deals array and reload data
    [[CONTENT_STORAGE tableContents] removeAllObjects];
    [[CONTENT_STORAGE tableContents] addObjectsFromArray:[CONTENT_STORAGE dealArray]];
    [myTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}





@end



@implementation ContentStorageClass
@synthesize dealArray, currIndex, tableContents;

+(ContentStorageClass *)sharedInstance 
{
	static ContentStorageClass * instance = nil;
	
	if (instance == nil) {
		instance = [[[self class] alloc] init];
	}
	
	return instance;
}

@end

