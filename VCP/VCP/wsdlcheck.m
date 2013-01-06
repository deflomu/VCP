//
//  wsdlcheck.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "wsdlcheck.h"
#import "AppDelegate.h"
#import "retdata.h"
#import "parse.h"
#import "serverDetailsTableViewController.h"
#import "internetIsActive.h"
#import "parseFirewall.h"

@implementation wsdlcheck

@synthesize alert;

- (retdata*)startConnection:(NSString*) type: (NSString*) user: (NSString*) pass
{
    BOOL on = [[[internetIsActive alloc] init] connected];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!(on))
    {
        retdata *ret = [[retdata alloc] init];
        ret.ret = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Keine Internetverbindung!"], nil];

        return ret;
    }
    else if ([appDelegate.onlineFlag isEqualToString:@"NO"] && (!([type isEqualToString:@"checkLogindata"])))
    {
        retdata *ret = [[retdata alloc] init];
        ret.ret = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Nicht angemeldet"], nil];
        
        return ret;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* yourPostString;
    
    NSString* serverName = appDelegate.curServer;
    
    if ([type isEqualToString:@"checkLogindata"] || [type isEqualToString:@"getServers"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServers><loginName>%@</loginName><password>%@</password></end:getVServers></soapenv:Body></soapenv:Envelope>", user, pass];
    }
    else if ([type isEqualToString:@"serverState"])
    {        
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerState><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerState></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"serverLoad"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerLoad><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerLoad></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"serverUptime"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerUptime><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerUptime></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"serverIP"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerIPs><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerIPs></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"processes"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerProcesses><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerProcesses></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"startServer"])
    {        
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:startVServer><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:startVServer></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"stopServer"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:stopVServer><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:stopVServer></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    else if ([type isEqualToString:@"getFirewall"])
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getFirewall><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getFirewall></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    }
    
    
    dataWeb = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.vservercontrolpanel.de/WSEndUser"]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if ([type isEqualToString:@"startServer"] || [type isEqualToString:@"stopServer"])
    {
        [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(showAlertView) userInfo:nil repeats:NO];
        
        NSURLConnection *myConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        [myConnection start];
        
        retdata *ret = [[retdata alloc] init];
        ret.message = [[NSString alloc] initWithFormat:@"cmdSent"];
                
        return ret;
    }
    else
    {
        NSURLResponse* response;
        NSError* error = nil;
        
        NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        NSString *rString = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
        
        parse *pu = [[parse alloc] init];
        retdata *ret = [pu parseReturn:rString];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return ret;
    }
}

- (firewallRetData*)startConnectionFW:(NSString*) type: (NSString*) user: (NSString*) pass: (NSString*)ruleID
{
    BOOL on = [[[internetIsActive alloc] init] connected];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!(on))
    {
        firewallRetData *ret = [[firewallRetData alloc] init];
        ret.deactivated = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Keine Internetverbindung!"], nil];
        
        return ret;
    }
    else if ([appDelegate.onlineFlag isEqualToString:@"NO"])
    {
        firewallRetData *ret = [[firewallRetData alloc] init];
        ret.deactivated = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Nicht angemeldet"], nil];
        
        return ret;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString* yourPostString;
    
    NSString* serverName = appDelegate.curServer;
    
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getFirewall><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getFirewall></soapenv:Body></soapenv:Envelope>", user, pass, serverName];
    
    dataWeb = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.vservercontrolpanel.de/WSEndUser"]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse* response;
    NSError* error = nil;
        
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *rString = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    parseFirwall *pu = [[parseFirwall alloc] init];
    firewallRetData *ret = [pu parseReturn:rString];
    
    if ( [ruleID isEqualToString:@"-1"] )
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        return ret;
    }
    else 
    {
        firewallRetData *specificRule = [[firewallRetData alloc] init];
        
        specificRule.comment = [[NSMutableArray alloc] init];
        specificRule.deactivated = [[NSMutableArray alloc] init];
        specificRule.destIP = [[NSMutableArray alloc] init];
        specificRule.destPort = [[NSMutableArray alloc] init];
        specificRule.srcPort = [[NSMutableArray alloc] init];
        specificRule.srcIP = [[NSMutableArray alloc] init];
        specificRule.direction = [[NSMutableArray alloc] init];
        specificRule.i_id = [[NSMutableArray alloc] init];
        specificRule.match = [[NSMutableArray alloc] init];
        specificRule.matchValue = [[NSMutableArray alloc] init];
        specificRule.protocol = [[NSMutableArray alloc] init];
        specificRule.sort = [[NSMutableArray alloc] init];
        specificRule.target = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < ret.deactivated.count; i++) {
            if ([[ret.i_id objectAtIndex:i] isEqualToString:ruleID])
            {
                [specificRule.comment addObject:[ret.comment objectAtIndex:i]];
                [specificRule.deactivated addObject:[ret.deactivated objectAtIndex:i]];
                [specificRule.destIP addObject:[ret.destIP objectAtIndex:i]];
                [specificRule.destPort addObject:[ret.destPort objectAtIndex:i]];
                [specificRule.direction addObject:[ret.direction objectAtIndex:i]];
                [specificRule.i_id addObject:[ret.i_id objectAtIndex:i]];
                [specificRule.match addObject:[ret.match objectAtIndex:i]];
                [specificRule.matchValue addObject:[ret.matchValue objectAtIndex:i]];
                [specificRule.protocol addObject:[ret.protocol objectAtIndex:i]];
                [specificRule.sort addObject:[ret.sort objectAtIndex:i]];
                [specificRule.srcIP addObject:[ret.srcIP objectAtIndex:i]];
                [specificRule.srcPort addObject:[ret.srcPort objectAtIndex:i]];
                [specificRule.target addObject:[ret.target objectAtIndex:i]];
                break;
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        return specificRule;
    }
}

- (NSMutableArray*)getSpecificRule:(NSString*)user: (NSString*) pass: (NSString*) ruleID {
    NSMutableArray* ret = [[NSMutableArray alloc] initWithCapacity:13];
    
    firewallRetData* temp_ret = [[firewallRetData alloc] init];
    temp_ret = [self startConnectionFW:@"getFirewall" :user :pass :ruleID];
    
    [ret addObject:[temp_ret.comment objectAtIndex:0]];
    [ret addObject:[temp_ret.deactivated objectAtIndex:0]];
    [ret addObject:[temp_ret.destIP objectAtIndex:0]];
    [ret addObject:[temp_ret.destPort objectAtIndex:0]];
    [ret addObject:[temp_ret.direction objectAtIndex:0]];
    [ret addObject:[temp_ret.i_id objectAtIndex:0]];
    [ret addObject:[temp_ret.match objectAtIndex:0]];
    [ret addObject:[temp_ret.matchValue objectAtIndex:0]];
    [ret addObject:[temp_ret.protocol objectAtIndex:0]];
    [ret addObject:[temp_ret.sort objectAtIndex:0]];
    [ret addObject:[temp_ret.srcIP objectAtIndex:0]];
    [ret addObject:[temp_ret.srcPort objectAtIndex:0]];
    [ret addObject:[temp_ret.target objectAtIndex:0]];
    
    return ret;
}

- (void)setzeReferenz:(serverDetailsTableViewController*)view
{
    parentPhone = view;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [NSTimer scheduledTimerWithTimeInterval:2.001 target:self selector:@selector(closeAlertView) userInfo:nil repeats:NO]; 
    [NSTimer scheduledTimerWithTimeInterval:1.000 target:self selector:@selector(refreshServerData) userInfo:nil repeats:NO]; 
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)showAlertView
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.curServerOnline isEqualToString:@"Offline"])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"vServer wird gestartet" message:@"Der Vorgang kann bis zu einer Minute dauern. Dieser Hinweis schließt sich von selbst!"
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil, nil]; 
    }
    else 
    {
        alert = [[UIAlertView alloc] initWithTitle:@"vServer wird gestoppt" message:@"Der Vorgang kann bis zu einer Minute dauern. Dieser Hinweis schließt sich von selbst!"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil]; 
    }
    
    
    [alert show];
}

- (void)closeAlertView
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

-(BOOL)checkLogindata:(NSString *)user :(NSString *)pass
{
    retdata* ret = [self startConnection:@"checkLogindata" :user :pass];
    NSString* retString = [ret.ret objectAtIndex:0];
    
    if ([retString isEqualToString:@"undefined error"] || [retString isEqualToString:@"wrong password"] || [retString isEqualToString:@"Keine Internetverbindung!"])
    {
        return false;
    }
    else
    {
        return true;
    }    
}

- (NSMutableArray*)getServers:(NSString*) user: (NSString*) pass
{
    retdata* ret = [self startConnection:@"getServers" :user :pass];
    return ret.ret;
}

- (NSMutableArray*)getServerIPs:(NSString*) user: (NSString*) pass
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* stat = nil;
    stat = [[NSString alloc] initWithFormat:@"%@", appDelegate.removeSubnet];
    retdata* ret = [self startConnection:@"serverIP" :user :pass];

    if ([stat isEqualToString:@"YES"])
    {            
        for (int i = 0; i < ret.ret.count; i++)
        {
            if (!([[ret.ret objectAtIndex:i] isEqualToString:@"Keine Internetverbindung!"]))
            {
                NSString *ip = [ret.ret objectAtIndex:i];
                int beginIndex= [ip rangeOfString:@"/"].location;
                ip = [ip substringToIndex:beginIndex];
                [ret.ret replaceObjectAtIndex:i withObject:ip]; 
            }
        }
    }
    
    return ret.ret;
}

- (NSString*)getServerState:(NSString*) user: (NSString*) pass
{
    retdata* ret = [self startConnection:@"serverState" :user :pass];
    return [ret.ret objectAtIndex:0];
}

- (NSString*)getServerLoad:(NSString*) user: (NSString*) pass
{
    retdata* ret = [self startConnection:@"serverLoad" :user :pass];
    return [ret.ret objectAtIndex:0];
}

- (NSString*)getFirstServerIP:(NSString*) user: (NSString*) pass
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* stat = nil;
    stat = [[NSString alloc] initWithFormat:@"%@", appDelegate.removeSubnet];
    
    retdata* ret = [self startConnection:@"serverIP" :user :pass];
    NSString* ip = [[NSString alloc] init];
    
    if ([appDelegate.forceIPv4 isEqualToString:@"YES"] && (!([ip isEqualToString:@"Keine Internetverbindung!"])) && ret.ret.count > 1 )
    {
        for (int i = 0; i < ret.ret.count; i++)
        {
            if ([[ret.ret objectAtIndex:i] rangeOfString:@":"].location == NSNotFound) {
                ip = [ret.ret objectAtIndex:i];
            }
        }
    }
    else 
    {
       ip = [ret.ret objectAtIndex:0];
    }
    
    if ( [stat isEqualToString:@"YES"] && (!([ip isEqualToString:@"Keine Internetverbindung!"])) )
    {
        int beginIndex= [ip rangeOfString:@"/"].location;
        ip = [ip substringToIndex:beginIndex];
    }
    
    return ip;
}

- (NSString*)getProcesses:(NSString*) user: (NSString*) pass
{
    retdata* ret = [self startConnection:@"processes" :user :pass];
    return [ret.ret objectAtIndex:0];
}

- (NSString*)getServerUptime:(NSString *)user :(NSString *)pass
{
    retdata* ret = [self startConnection:@"serverUptime" :user :pass];
    NSUInteger uptime = [[ret.ret objectAtIndex:0] integerValue];
    
    /*
     SekundenTotal / 3600 ergibt die Stunden 
     (SekundenTotal - (Stunden*3600)) / 60 ergibt die Minuten 
     (SekundenTotal - (Stunden*3600) - (Minuten*60) ergibt die Sekunden 
     */
    
    int Tage = uptime / 86400;
    int Stunden = (uptime - (Tage * 86400)) / 3600;
    int Minuten = (uptime - (Stunden*3600) - (Tage * 86400)) / 60;
    
    return [NSString stringWithFormat:@"%02id %02ih %02im", Tage, Stunden, Minuten];
}

- (NSString*)startvServer:(NSString*)user: (NSString*)pass
{
    retdata* ret = [self startConnection:@"startServer" :user :pass];
    return ret.message;
}

- (NSString*)stopvServer:(NSString*)user: (NSString*)pass
{
    retdata* ret = [self startConnection:@"stopServer" :user :pass];
    return ret.message;
}

@end
