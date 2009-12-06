//
//  SWFScreensaverMacView.h
//  SWFScreensaverMac
//
//  Created by Florian on 01.10.09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SystemConfiguration.h>


@interface SWFScreensaverMacView : ScreenSaverView {
	
	IBOutlet id configSheet;
	IBOutlet id showInfoPic;
	IBOutlet id showInfoText;
	IBOutlet id showConfig;
	
	// running in preview mode
	Boolean previewMode:true;

	
}

Boolean debugMode;				// running in debug mode (true / false)

Boolean interactiveMode;		// running in interactive mode (true / false)

// path to main bundle
NSBundle *pMainBundle;
NSString *pBundlePath;


NSDictionary *infoDict;			// plist file
NSMutableString *pathToLogFile;	// path to the log file


WebScriptObject *scriptObject;	// Scriptobjekt für JS


Boolean quitFlag;				// flag for shutting down

WebView *webView;				// webview for displaying html/flash


static Boolean checkOnline(const char *serverName);
static void LogToFile(NSString *message, ...);
- (void) quitScreenSaver;
- (void) gotoUrl:(NSString *) destinationURL;


@end
