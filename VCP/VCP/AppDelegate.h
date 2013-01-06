//
//  AppDelegate.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "serverTableView.h"
#import "serverDetailsTableViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *username;
    NSString *password;
    NSString *onlineFlag;
    
    NSString *saveData;
    NSString *curServer;
    NSString *curServerOnline;
    
    NSString *removeSubnet;
    NSString *forceIPv4;
    NSString *beta;
    NSString *betaState;
    NSString *autoLoadServer;
    NSString *alwaysSaveLogin;
    NSString *dontAskBeforeDel;
    
    NSString *firewallRule;
    
    NSString *device;
    
    BOOL pleaseLogout;
    BOOL atLeastIOS6;
    BOOL firstLogin;
    
    UISplitViewController* splitViewController;
    
    serverTableView* master;
    serverDetailsTableViewController* detail;
    
    UIAlertView* noConn;
    BOOL noConnShowing;
    
    UIAlertView* noLogin;
    BOOL noLoginShowing;
    
    UIAlertView* errorLoading;
    BOOL errorWhileLoading;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) NSString* username;
@property (nonatomic,retain) NSString* password;
@property (nonatomic,retain) NSString* onlineFlag;

@property (nonatomic,retain) NSString* saveData;
@property (nonatomic,retain) NSString* curServer;
@property (nonatomic,retain) NSString* curServerOnline;

@property (nonatomic,retain) NSString* removeSubnet;
@property (nonatomic,retain) NSString* forceIPv4;
@property (nonatomic,retain) NSString* beta;
@property (nonatomic,retain) NSString* betaState;
@property (nonatomic,retain) NSString* autoLoadServer;
@property (nonatomic,retain) NSString* alwaysSaveLogin;
@property (nonatomic,retain) NSString* dontAskBeforeDel;

@property (nonatomic,retain) NSString* firewallRule;

@property (nonatomic,retain) NSString* device;

@property (nonatomic) BOOL pleaseLogout;
@property (nonatomic) BOOL atLeastIOS6;
@property (nonatomic) BOOL firstLogin;

@property (nonatomic,retain) UISplitViewController* splitViewController;

@property (nonatomic,retain) serverTableView* master;
@property (nonatomic,retain) serverDetailsTableViewController* detail;

- (void)showNoConnection;
- (void)notLoggedIn;
- (void)errorWhileLoad;
- (void)changeLogintype:(NSString*)state;

@end
