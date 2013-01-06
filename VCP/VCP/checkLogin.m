//
//  checkLogin.m
//  VCP
//
//  Created by Jens Sproede on 10.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "checkLogin.h"
#import "internetIsActive.h"
#import "AppDelegate.h"
#import "retdata.h"
#import "parse.h"
#import "serverDetailsTableViewController.h"
#import "processViewController.h"
#import "firewallRetData.h"
#import "parseFirewall.h"

@implementation checkLogin

- (BOOL) checkForConn: (BOOL) checking {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    BOOL on = [[[internetIsActive alloc] init] connected];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!(on))
    {
        [appDelegate showNoConnection];
        return false;
    }
    else if ([appDelegate.onlineFlag isEqualToString:@"NO"] && checking == false)
    {
        [appDelegate notLoggedIn];
        return false;
    }
    else {
        return true;
    }
}

- (void)clearLogin {
    [self stopAnimation];
    [loginController reloadTable];
}

- (void) checkLogindata: (NSString*)user: (NSString*)pass: (loginTableViewController*)view {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    loginController = view;
    if ([self checkForConn:true] == false)
    {
        [NSTimer scheduledTimerWithTimeInterval:0.250 target:self selector:@selector(clearLogin) userInfo:nil repeats:NO];
        return;
    }
    
    NSString* yourPostString;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServers><loginName>%@</loginName><password>%@</password></end:getVServers></soapenv:Body></soapenv:Envelope>", user, pass];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServers: (serverTableView*)view {
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    serverController = view;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServers><loginName>%@</loginName><password>%@</password></end:getVServers></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerState:(serverDetailsTableViewController *)view:(NSString*)t {
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    serverDetailController = view;
    type = t;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerState><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerState></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerUptime:(serverDetailsTableViewController *)view:(NSString*)t {
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    serverDetailController = view;
    type = t;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerUptime><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerUptime></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerLoad:(serverDetailsTableViewController *)view:(NSString*)t {
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    serverDetailController = view;
    type = t;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerLoad><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerLoad></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerIP:(serverDetailsTableViewController *)view:(NSString*)t {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    serverDetailController = view;
    type = t;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerIPs><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerIPs></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerIPs:(ipsTableViewController *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    ipController = view;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerIPs><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerIPs></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerProcesses:(processViewController *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    processController = view;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getVServerProcesses><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getVServerProcesses></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerFirewall:(FirewallViewController *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    firewallController = view;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getFirewall><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getFirewall></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) getVServerSpecificRule:(detailRuleTableViewController *)view:(NSString*)rule_id
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
    
    detailController = view;
    r_id = rule_id;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:getFirewall><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:getFirewall></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

- (void) changeVServerState:(serverDetailsTableViewController*)view:(NSString*)state
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if ([self checkForConn:false] == false)
    {
        return;
    }
        
    if ( [state isEqualToString:@"stop"] )
    {
        msg = [NSString stringWithFormat:@"vServer wird gestoppt!\nBitte warten ..."];
    }
    else {
        msg = [NSString stringWithFormat:@"vServer wird gestartet!\nBitte warten ..."];
    }
        
    serverDetailController = view;
    
    [NSTimer scheduledTimerWithTimeInterval:0.250 target:self selector:@selector(showWorking) userInfo:nil repeats:NO];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString* yourPostString;
    NSString* serverName = appDelegate.curServer;
    
    if ( [state isEqualToString:@"start"] )
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:startVServer><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:startVServer></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    }
    else 
    {
        yourPostString = [NSString stringWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:end=\"http://enduser.service.web.vcp.netcup.de/\"><soapenv:Header/><soapenv:Body><end:stopVServer><loginName>%@</loginName><password>%@</password><vserverName>%@</vserverName></end:stopVServer></soapenv:Body></soapenv:Envelope>", appDelegate.username, appDelegate.password, serverName];
    }
    
    webData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appDelegate.beta]];
    NSString *postLength =  [NSString stringWithFormat:@"%d", [yourPostString length]];
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:postLength forHTTPHeaderField:@"Content-Length"];    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[yourPostString dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (conn)
    {
        webData = [[NSMutableData alloc] init];
    }
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error {
    UIAlertView* Eerror = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Es ist ein Fehler bei der Abfrage aufgetreten. Bitte versuchen Sie es erneut!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [Eerror show];
    [self stopAnimation];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
        
    if (working)
    {
        [NSTimer scheduledTimerWithTimeInterval:2.000 target:self selector:@selector(closeWorking) userInfo:nil repeats:NO];
        return;
    }
    
    NSString *theXML = [[NSString alloc]
                        initWithBytes: [webData mutableBytes]
                        length:[webData length]
                        encoding:NSUTF8StringEncoding];
    
    parse *pu;
    retdata *ret;
    
    parseFirwall *pf;
    firewallRetData *retf;
    
    if (!(firewallController) && !(detailController))
    {
        pu = [[parse alloc] init];
        ret = [pu parseReturn:theXML];
    }
    else {
        pf = [[parseFirwall alloc] init];
        retf = [pf parseReturn:theXML];
    }
    
    if (loginController) {
        if ([ret.ret count] != 0)
        {
            NSString* retString = [ret.ret objectAtIndex:0];
        
            if ([retString isEqualToString:@"undefined error"] || [retString isEqualToString:@"wrong password"] || [retString isEqualToString:@"Keine Internetverbindung!"])
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Entweder sind Ihre eingegebenen Benutzerdaten falsch oder Sie haben den Webservice nicht aktiviert!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [loginController reloadTable];
            }
            else
            {
                [loginController loginsuccess];
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                appDelegate.onlineFlag = @"YES";
                [loginController reloadTable];
            } 
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Der Webservice hat eine leere vServer-Liste zurückgegeben.\n\nMöglicherweise haben Sie nicht die Anmeldedaten für den Webservice verwendet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [loginController reloadTable];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (serverController)
    {
        [serverController servers: ret.ret];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (serverDetailController)
    {
        if ([type isEqualToString:@"state"])
        {
            [serverDetailController setzeState:[ret.ret objectAtIndex:0]];
        }
        else if ([type isEqualToString:@"load"])
        {
            if (!([[ret.ret objectAtIndex:0] isEqualToString:@"VServer not online"]))
                [serverDetailController setzeLoad:[ret.ret objectAtIndex:0]];
            else
                [serverDetailController setzeLoad:@"-"];            
        }
        else if ([type isEqualToString:@"uptime"])
        {
            NSUInteger uptime = [[ret.ret objectAtIndex:0] integerValue];
            
            /*
             SekundenTotal / 3600 ergibt die Stunden 
             (SekundenTotal - (Stunden*3600)) / 60 ergibt die Minuten 
             (SekundenTotal - (Stunden*3600) - (Minuten*60) ergibt die Sekunden 
             */
            
            int Tage = uptime / 86400;
            int Stunden = (uptime - (Tage * 86400)) / 3600;
            int Minuten = (uptime - (Stunden*3600) - (Tage * 86400)) / 60;
            
            [serverDetailController setzeUptime:[NSString stringWithFormat:@"%02id %02ih %02im", Tage, Stunden, Minuten]];
        }
        else if ([type isEqualToString:@"ip"])
        {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSString* stat = nil;
            stat = [[NSString alloc] initWithFormat:@"%@", appDelegate.removeSubnet];
            
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
            
            if ( [stat isEqualToString:@"YES"] && ([ip rangeOfString:@"/"].location != NSNotFound) )
            {
                int beginIndex= [ip rangeOfString:@"/"].location;
                ip = [ip substringToIndex:beginIndex];
            }
            
            [serverDetailController setzeIP:ip];
        }
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (processController)
    {
        [processController setzeProzesse:[ret.ret objectAtIndex:0]];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (ipController)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString* stat = nil;
        stat = [[NSString alloc] initWithFormat:@"%@", appDelegate.removeSubnet];
        
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
        
        [ipController setIPs:ret.ret];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (firewallController)
    {
        [firewallController setFirewall:retf];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
    else if (detailController)
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
        
        for (int i = 0; i < retf.deactivated.count; i++) 
        {
            if ([[retf.i_id objectAtIndex:i] isEqualToString:r_id])
            {
                [specificRule.comment addObject:[retf.comment objectAtIndex:i]];
                [specificRule.deactivated addObject:[retf.deactivated objectAtIndex:i]];
                [specificRule.destIP addObject:[retf.destIP objectAtIndex:i]];
                [specificRule.destPort addObject:[retf.destPort objectAtIndex:i]];
                [specificRule.direction addObject:[retf.direction objectAtIndex:i]];
                [specificRule.i_id addObject:[retf.i_id objectAtIndex:i]];
                [specificRule.match addObject:[retf.match objectAtIndex:i]];
                [specificRule.matchValue addObject:[retf.matchValue objectAtIndex:i]];
                [specificRule.protocol addObject:[retf.protocol objectAtIndex:i]];
                [specificRule.sort addObject:[retf.sort objectAtIndex:i]];
                [specificRule.srcIP addObject:[retf.srcIP objectAtIndex:i]];
                [specificRule.srcPort addObject:[retf.srcPort objectAtIndex:i]];
                [specificRule.target addObject:[retf.target objectAtIndex:i]];
                break;
            }
        }
        
        [detailController setzeRule:specificRule];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
        return;
    }
}

- (void)showWorking {
    working = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [working show];
    
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(working.bounds.size.width / 2, working.bounds.size.height - 50);
    [indicator startAnimating];
    
    [working addSubview:indicator];
}

- (void)closeWorking {
    [working dismissWithClickedButtonIndex:0 animated:YES];
    working = nil;    
    [self stopAnimation];
    [serverDetailController reloadServerData];
}

- (void)stopAnimation {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)abortConn {
    [conn cancel];
    [self stopAnimation];
}

@end
