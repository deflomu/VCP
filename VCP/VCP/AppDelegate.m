//
//  AppDelegate.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SplitViewController.h"
#include "Appirater.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize username;
@synthesize password;
@synthesize onlineFlag;

@synthesize saveData;
@synthesize curServer;
@synthesize curServerOnline;
@synthesize firewallRule;

@synthesize pleaseLogout;
@synthesize atLeastIOS6;
@synthesize firstLogin;

@synthesize device;

@synthesize removeSubnet;
@synthesize forceIPv4;
@synthesize beta;
@synthesize betaState;
@synthesize autoLoadServer;
@synthesize alwaysSaveLogin;
@synthesize dontAskBeforeDel;

@synthesize master;
@synthesize detail;
@synthesize splitViewController;

- (void)showNoConnection {
    if (!noConnShowing)
    {
        noConn = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Es besteht leider keine Internetverbindung!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        noConn.tag = 1;
        noConnShowing = true;
        [noConn show];
    }
}

- (void)notLoggedIn {
    if (!noLoginShowing)
    {
        noLogin = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Sie sind leider nicht angemeldet!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        noLogin.tag = 2;
        noLoginShowing = true;
        [noLogin show];
    }
}

- (void)errorWhileLoad {
    if (!errorWhileLoading)
    {
        errorLoading = [[UIAlertView alloc] initWithTitle:@"Fehler beim Laden der Serverdaten" message:@"Es liegt anscheinend gerade ein Fehler im VCP Webservice vor. Bitte versuchen Sie es später erneut." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        errorLoading.tag = 3;
        errorWhileLoading = true;
        [errorLoading show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        noConnShowing = false;
    }
    else if (alertView.tag == 2)
    {
        noLoginShowing = false;
    }
    else if (alertView.tag == 3)
    {
        errorWhileLoading = false;
    }
}

- (void)changeLogintype:(NSString*) state {
    
    if ([state isEqualToString:@"NO"])
    {
        beta = [[NSString alloc] initWithFormat:@"%@", @"https://www.vservercontrolpanel.de/WSEndUser"];
        betaState = @"NO";
    }
    else
    {
        beta = [[NSString alloc] initWithFormat:@"%@", @"https://vcptest.netcup.net/WSEndUser"];
        betaState = @"YES";
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Appirater setAppId:@"518324375"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    
    pleaseLogout = false;
    firstLogin = true;
    
    atLeastIOS6 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *name = [[NSString alloc] init];
    NSString *pass = [[NSString alloc] init];
	NSString *sub = [[NSString alloc] init];
    NSString *force = [[NSString alloc] init];
    NSString *betaIn = [[NSString alloc] init];
    NSString *autoshow = [[NSString alloc] init];
    NSString *autosave = [[NSString alloc] init];
    NSString *askDel = [[NSString alloc] init];
    
    onlineFlag = @"NO";
    
	if (standardUserDefaults) 
    {
		name = [standardUserDefaults objectForKey:@"username"];
        pass = [standardUserDefaults objectForKey:@"password"];
        sub = [standardUserDefaults objectForKey:@"explodeSubnet"];
        force = [standardUserDefaults objectForKey:@"forceIP4"];
        betaIn = [standardUserDefaults objectForKey:@"beta"];
        autoshow = [standardUserDefaults objectForKey:@"autoshow"];
        autosave = [standardUserDefaults objectForKey:@"autosave"];
        askDel = [standardUserDefaults objectForKey:@"askdelete"];
        
        if ((name != @"(null)" && name != nil) && (pass != @"(null)" && pass != nil))
        {
            username = [[NSString alloc] initWithFormat:@"%@", name];
            password = [[NSString alloc] initWithFormat:@"%@", pass];
        }
        
        removeSubnet = [[NSString alloc] initWithFormat:@"%@", sub];
        forceIPv4 = [[NSString alloc] initWithFormat:@"%@", force];
        autoLoadServer = [[NSString alloc] initWithFormat:@"%@", autoshow];
        alwaysSaveLogin = [[NSString alloc] initWithFormat:@"%@", autosave];
        dontAskBeforeDel = [[NSString alloc] initWithFormat:@"%@", askDel];
        
        if ([betaIn isEqualToString:@"YES"])
        {
            beta = [[NSString alloc] initWithFormat:@"%@", @"https://vcptest.netcup.net/WSEndUser"];
            betaState = @"YES";
        }
        else
        {
            beta = [[NSString alloc] initWithFormat:@"%@", @"https://www.vservercontrolpanel.de/WSEndUser"];
            betaState = @"NO";
        }
        
        curServer = @"Detailansicht";
    }
    
    // Override point for customization after application launch.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        device = @"ipad";
        
        splitViewController = (SplitViewController *)self.window.rootViewController;
        master = [[[splitViewController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
        detail = [[[splitViewController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0];
                
        /*
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        */
        splitViewController.delegate = detail;
        
        UIColor *color = [UIColor colorWithRed:51/255.f green:149/255.f blue:168/255.f alpha:1];
        detail.navigationController.navigationBar.tintColor = color;
        master.navigationController.navigationBar.tintColor = color;
        
        [_window makeKeyAndVisible];
    }
    else {
        device = @"iphone";
    }
    
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{    
   
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
}

@end
