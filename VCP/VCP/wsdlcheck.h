//
//  wsdlcheck.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "retdata.h"
#import "serverDetailsTableViewController.h"
#import "firewallRetData.h"

@interface wsdlcheck : NSObject{
    NSMutableData *dataWeb;
    UIAlertView *alert;
    
    serverDetailsTableViewController* parentPhone;
}

- (BOOL)checkLogindata:(NSString *)user :(NSString *)pass;
- (retdata*)startConnection:(NSString*) type: (NSString*) user: (NSString*) pass;
- (firewallRetData*)startConnectionFW:(NSString*) type: (NSString*) user: (NSString*) pass: (NSString*)ruleID;
- (NSMutableArray*)getSpecificRule:(NSString*)user: (NSString*) pass: (NSString*) ruleID;
- (NSMutableArray*)getServers:(NSString*) user: (NSString*) pass;
- (NSMutableArray*)getServerIPs:(NSString*) user: (NSString*) pass;
- (NSString*)getServerState:(NSString*) user: (NSString*) pass;
- (NSString*)getServerLoad:(NSString*) user: (NSString*) pass;
- (NSString*)getFirstServerIP:(NSString*) user: (NSString*) pass;
- (NSString*)getProcesses:(NSString*) user: (NSString*) pass;
- (NSString*)getServerUptime:(NSString*) user: (NSString*) pass;
- (NSString*)startvServer:(NSString*)user: (NSString*)pass;
- (NSString*)stopvServer:(NSString*)user: (NSString*)pass;

- (void)setzeReferenz:(serverDetailsTableViewController*)view;
- (void)refreshServerData;

@property (nonatomic,retain) UIAlertView *alert;

@end
