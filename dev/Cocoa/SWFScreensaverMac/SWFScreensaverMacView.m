//
//  SWFScreensaverMacView.m
//  SWFScreensaverMac
//
//  Created by Florian on 01.10.09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import "SWFScreensaverMacView.h"
#import <WebKit/WebKit.h>
#import <WebKit/WebPolicyDelegate.h>


@implementation SWFScreensaverMacView

WebView *webView;

NSImage *imageFromBundle;


- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview {
	
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
		
        [self setAnimationTimeInterval:-1];
		[self setAutoresizesSubviews:YES];
		
		// ::::::::::::::::::::::: Init stuff ::::::::::::::::::	
		
		// init 
		quitFlag = false;
		previewMode = false;
		
		// find out the path the screensaver bundle
		pMainBundle = [NSBundle bundleForClass:[self class]];
		pBundlePath = [pMainBundle bundlePath];
		
		// read Info.plist
		infoDict = [pMainBundle infoDictionary]; 
		
	
		// ::::::::::::::::::::::: Debug mode ::::::::::::::::::
		
		// Shall debug mode be activated? Check property in plist
		NSString *ValueDebugMode = [infoDict objectForKey:@"com.florianplag.DebugMode"];
		ValueDebugMode = [ValueDebugMode lowercaseString];	
		debugMode = [ValueDebugMode isEqualToString:@"true"];	
		
		
		if (debugMode) {
			
			pathToLogFile = [[NSMutableString alloc] initWithString:pBundlePath];
			[pathToLogFile appendString:@"/Contents/Log.txt"];
			
			// read file
			NSError *myError = nil;
			NSString *contentsOfFile = [[NSString alloc] initWithContentsOfFile:pathToLogFile encoding:NSUTF8StringEncoding error:&myError];
			
			// if file doesn't exist, create it
			if (myError != nil) {
				contentsOfFile = @"";
				[contentsOfFile writeToFile:pathToLogFile atomically:YES];
			}
		}
		
		
		
		// ::::::::::::::::::::::: Interactive mode ::::::::::::::::::
		
		// Shall interactive mode be activated? Check property in plist
		NSString *ValueInteractiveMode = [infoDict objectForKey:@"com.florianplag.InteractiveMode"];
		ValueInteractiveMode = [ValueInteractiveMode lowercaseString];	
		interactiveMode = [ValueInteractiveMode isEqualToString:@"true"];	
		//NSLog(@"The value of the bool is %@\n", (interactiveMode ? @"YES" : @"NO"));
		
		
		// ::::::::::::::::::::::: Logging ::::::::::::::::::
		
		LogToFile(@" --------- Init screensaver ----------");
		
		if (isPreview) {
			LogToFile(@"Screensaver runs in preview mode");
			previewMode = true;
		} else {
			previewMode = false;
		}
		  
		
	}
	
		
		 
    return self;
}

- (void)startAnimation
{
	
	// standard command (screensaver)
    [super startAnimation];
	
	// ::::::::::::::::::::::: Setup and load Webkit with flash content ::::::::::::::::::
	
	// new webkit
	webView = [WebView alloc];
	[webView initWithFrame:[self bounds]];
	[webView setDrawsBackground:NO];
	// delegation policy for interactive mode
	[webView setPolicyDelegate: self];
	[webView setUIDelegate:self]; 

	
	// ::::::::::::::::::::::: Online Check ::::::::::::::::::
	
	// Shall online check be executed? Check property in plist
	NSString *ValueCheckIfOnline = [infoDict objectForKey:@"com.florianplag.CheckIfOnline"];
	ValueCheckIfOnline = [ValueCheckIfOnline lowercaseString];	
	Boolean executeOnlineCheck = [ValueCheckIfOnline isEqualToString:@"true"];	
	
	// Init onlineStatus with false
	Boolean onlineStatus = false;
	
	// Online check
	if (executeOnlineCheck) {
		
		LogToFile(@"Check internet connection ...");
		
		// read servername from plist
		NSString *ValueOnlineCheckServername = [infoDict objectForKey:@"com.florianplag.OnlineCheckServername"];
		const char *server = [ValueOnlineCheckServername fileSystemRepresentation];
		
		// save online status
		onlineStatus = checkOnline (server);		
		
	}
	
	// combine: bundle path + filename for screensaver file 
	NSMutableString *pathToScreensaver = [[NSMutableString alloc] initWithString:pBundlePath];
	NSString *ValueScreensaverFile;
	
	// if application is online (after online check) or no online check executed
	if ( (executeOnlineCheck && onlineStatus) || !(executeOnlineCheck) ) {
		ValueScreensaverFile = [infoDict objectForKey:@"com.florianplag.ScreensaverFile"];
		if (executeOnlineCheck) {
			LogToFile(@"Internet connection available");
		}
	}
	
	// else (= online check failed)
	else {
		ValueScreensaverFile = [infoDict objectForKey:@"com.florianplag.ScreensaverFileOnlineCheckFailed"];	
		LogToFile(@"Internet connection not available");
	}
	
	
	// ::::::::::::::::::::::: Load screensaver ::::::::::::::::::
	
	// add filename to bundle path
	[pathToScreensaver appendString:ValueScreensaverFile];
	LogToFile(@"Loading file:");
	LogToFile(pathToScreensaver);	
	
	// complete NSURL to the screensaver file
	NSURL *SwfURL = [NSURL fileURLWithPath: pathToScreensaver];
	
	// load screensaver
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:SwfURL]];
	
	// Event Listener for page load
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:WebViewProgressFinishedNotification object:nil];
	
	// add to display	
	[self addSubview:webView];
	
	
	// Release
	[pathToScreensaver release];
	
	// Add JavaScript Interface
	scriptObject = [webView windowScriptObject];
	[scriptObject setValue:self forKey:@"swfscreensaver"];	
	
	

	
	// ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
	
}

- (void) updateProgress:(NSNotification *) notif;
{
	LogToFile(@"WebViewProgressFinishedNotification");
	
	
	
}


- (void)stopAnimation
{
	
	LogToFile(@"Shutting down");
	
	// stop and remove webkit
	[[webView mainFrame] stopLoading];
	[webView removeFromSuperview];
	//[webView release];
	
	// standard command of screensaver
    [super stopAnimation];	
	
	[pathToLogFile release];
	
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}


- (NSWindow *)configureSheet {
	
	
	if (!configSheet) {
		if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
			NSLog( @"Failed to load configure sheet." );
			NSBeep();
		}
	}
	
	
  	// find out the path to the screensaver bundle
	NSBundle *pMainBundle = [NSBundle bundleForClass:[self class]];
	NSString *pBundlePath = [pMainBundle bundlePath];
	
	
 	// ::::::::::::::::::::::: Setup info text :::::::::::::::::: 
	
	
	// check company
	NSDictionary *infoDict = [pMainBundle infoDictionary];
	
	NSString *myCompany = [infoDict objectForKey:@"com.florianplag.Creator"];
	
	if ([myCompany isEqualToString:@"http://www.video-flash.de"]) {
		[showInfoText setStringValue:@""];
	}
	
	
	
	
	// ::::::::::::::::::::::: Setup config flash panel ::::::::::::::::::
	
	// path to bundle
	NSMutableString *pathToConfig = [[NSMutableString alloc] initWithString:pBundlePath];
	
	NSString *pTemp2 = [infoDict objectForKey:@"com.florianplag.ConfigFile"];
	
	// add file path to bundle path
	[pathToConfig appendString:pTemp2];
	
	// NSURL to config file
	NSURL *configURL = [NSURL fileURLWithPath: pathToConfig];	
	
	// load config file
	[[showConfig mainFrame] loadRequest:[NSURLRequest requestWithURL:configURL]];
	
	// Release
	[pathToConfig release];
	
	return configSheet;
}


- (IBAction) okClick: (id)sender {
	
	// Close the sheet
	[[NSApplication sharedApplication] endSheet:configSheet];
}



static Boolean checkOnline(const char *serverName) {
	
	Boolean                     result;
    SCNetworkConnectionFlags    flags;
	
    assert(sizeof(SCNetworkConnectionFlags) == sizeof(int));
	
    result = false;
	
    if ( SCNetworkCheckReachabilityByName(serverName, &flags) ) {
        result =    !(flags & kSCNetworkFlagsConnectionRequired)
		&&  (flags & kSCNetworkFlagsReachable);
    }
	
	return result;
}

static void LogToFile(NSString *message, ...)
{

	//NSLog(@"%@", message);
	
	if (debugMode) {
		
		
		
		NSFileHandle *file;
		NSString	*fileName = [[NSString alloc]initWithString:pathToLogFile];
		file = [NSFileHandle fileHandleForWritingAtPath:fileName];
		[file truncateFileAtOffset:[file seekToEndOfFile]];
		
		va_list	 ap; // Points to each unamed argument in turn
		NSString	*debugMessage;
		va_start(ap, message); // Make ap point to the first unnamed argument 
		
		// write date
		NSDate *currentTime = [NSDate date];
		NSString *stringCurrentTime = [currentTime description];	
		[file writeData:[stringCurrentTime dataUsingEncoding:NSUTF8StringEncoding]];
		[file writeData:[@" " dataUsingEncoding:NSUTF8StringEncoding]];	
		
		// write message
		debugMessage = [[NSString alloc] initWithFormat:message arguments:ap]; 
		[file writeData:[debugMessage dataUsingEncoding:NSUTF8StringEncoding]];
		
		// write new line
		NSString *newline = [[NSString alloc]initWithString:@"\n"]; 
		[file writeData:[newline dataUsingEncoding:NSASCIIStringEncoding]];
		
		
		
		// Release
		//[fileName release];
		//[debugMessage release];
		//[newline release];
 		
	}
}



- (void)mouseMoved:(NSEvent *)theEvent         { 
	
	if (interactiveMode) {
		if (quitFlag) {
			[NSCursor hide];
			[super mouseMoved:theEvent];
		}
		else {
			[NSCursor unhide];
		}
	} else {
		[super mouseMoved:theEvent];
	}	
}

// delegation to the default browser for _blank links
- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener {
	[ [ NSWorkspace sharedWorkspace ] openURL:[ request URL ] ];
	LogToFile(@"link with _blank called");
}

/*
- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
   LogToFile(@"link with _blank called from javascript");
	
	
   //NSString * path    = @"/Developer/About Xcode Tools.pdf"; 	
   //NSURL    * fileURL = [NSURL fileURLWithPath: path];
   [ [ NSWorkspace sharedWorkspace ] openURL:[ request URL ]];	
	
	// makes no sense but just do it
    id myDocument = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:@"DocumentType" display:YES];
    [[[myDocument webView] mainFrame] loadRequest:request];
    return [myDocument webView];	
	
}
*/

- (void)webViewShow:(WebView *)sender
{
	LogToFile(@"webViewShow");
    id myDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[sender window]];
    [myDocument showWindows];
}


// Funktionen für JS freigeben
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
	//if ( (selector == @selector(quitScreenSaver)) || selector == @selector(quitScreensaverWithURL) ) {
    //    return NO;
    //}
    return NO;
}


// Variable für JS freigeben
+ (BOOL)isKeyExcludedFromWebScript:(const char *)property {
    if (strcmp(property, "previewMode") == 0) {
        return NO;
    }
    return YES;
}





- (void) quitScreenSaver {
	LogToFile(@"Quit triggered from JavaScript");
	quitFlag = true;
	
	NSEvent *event = [NSEvent mouseEventWithType:NSMouseMoved 
										location:NSMakePoint(10, 10) 
								   modifierFlags:0 
									   timestamp:0 
									windowNumber:1 
										 context:nil 
									 eventNumber:0 
									  clickCount:0 
										pressure:0.0];
	[NSApp postEvent:event atStart:NO];   
    
}

- (void) gotoUrl:(NSString *) destinationURL {
	LogToFile(@"gotoUrl triggered from JavaScript");
		
	NSString * path    = destinationURL;
	NSURL    * fileURL = [NSURL URLWithString:path];
	[ [ NSWorkspace sharedWorkspace ] openURL:fileURL ];		    
}



@end
