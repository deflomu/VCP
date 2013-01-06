//
//  checkLogin.h
//  VCP
//
//  Created by Jens Sproede on 10.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "serverTableView.h"
#import "processViewController.h"
#import "ipsTableViewController.h"
#import "FirewallViewController.h"
#import "detailRuleTableViewController.h"
#import "loginTableViewController.h"
#import "AppDelegate.h"

@class loginTableViewController;

@interface checkLogin : NSObject <NSURLConnectionDelegate> {
    NSMutableData *webData;
    NSURLConnection *conn;
    
    NSString* type;
    
    loginTableViewController* loginController;
    serverTableView* serverController;
    serverDetailsTableViewController* serverDetailController;
    processViewController* processController;
    ipsTableViewController* ipController;
    detailRuleTableViewController* detailController;
    FirewallViewController* firewallController;
    
    UIAlertView* working;
    NSString *msg;
    
    NSString* r_id;
}

- (BOOL) checkForConn: (BOOL) checking;

- (void) checkLogindata: (NSString*)user: (NSString*)pass: (loginTableViewController*)view;

- (void) getVServers: (serverTableView*)view;
- (void) getVServerState: (serverDetailsTableViewController*)view:(NSString*)t;
- (void) getVServerUptime: (serverDetailsTableViewController *)view:(NSString*)t;
- (void) getVServerLoad: (serverDetailsTableViewController *)view:(NSString*)t;
- (void) getVServerIP: (serverDetailsTableViewController *)view:(NSString*)t;
- (void) getVServerProcesses:(processViewController *)view;
- (void) getVServerIPs:(ipsTableViewController *)view;
- (void) getVServerFirewall:(FirewallViewController *)view;
- (void) getVServerSpecificRule:(detailRuleTableViewController *)view:(NSString*)rule_id;
- (void) changeVServerState:(serverDetailsTableViewController*)view:(NSString*)state;

- (void) abortConn;

@end
