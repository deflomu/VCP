//
//  FirewallViewController.m
//  VCP
//
//  Created by Jens Sproede on 07.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FirewallViewController.h"
#import "firewallRetData.h"
#import "checkLogin.h"

@interface FirewallViewController ()

@end

@implementation FirewallViewController
@synthesize firewallTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    amount4 = amount6 = counter = 0;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.atLeastIOS6)
    {
        refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadFirewall)];
        self.navigationItem.rightBarButtonItem = refresh;
    }
    
    // FIREWALLREGELN LADEN ...
    [self reloadFirewall];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (appDelegate.atLeastIOS6)
    {
        UIRefreshControl *refr = [[UIRefreshControl alloc] init];
        refr.attributedTitle = [[NSAttributedString alloc] initWithString:@"Runterziehen zum Aktualisieren"];
        [refr addTarget:self
                action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refr;
    }
}

-(void)refreshView:(UIRefreshControl *)refr {
    refr.attributedTitle = [[NSAttributedString alloc] initWithString:@"Aktualisieren ..."];
    
    [self reloadFirewall];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    refr.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refr endRefreshing];
}

- (void)reloadFirewall {
    checkLogin* chk = [[checkLogin alloc] init];
    [chk getVServerFirewall:self];
}

- (void)setFirewall:(firewallRetData*)rett {
    
    ret = rett;
    
    ip4ret = [[firewallRetData alloc] init];
    ip6ret = [[firewallRetData alloc] init];
    
    ip4ret.comment = [[NSMutableArray alloc] init];
    ip4ret.i_id = [[NSMutableArray alloc] init];
    ip4ret.direction = [[NSMutableArray alloc] init];
    ip4ret.destIP = [[NSMutableArray alloc] init];
    ip4ret.deactivated = [[NSMutableArray alloc] init];
    ip4ret.target = [[NSMutableArray alloc] init];
    ip4ret.destPort = [[NSMutableArray alloc] init];
    ip4ret.srcPort = [[NSMutableArray alloc] init];
    
    ip6ret.comment = [[NSMutableArray alloc] init];
    ip6ret.i_id = [[NSMutableArray alloc] init];
    ip6ret.direction = [[NSMutableArray alloc] init];
    ip6ret.destIP = [[NSMutableArray alloc] init];
    ip6ret.deactivated = [[NSMutableArray alloc] init];
    ip6ret.target = [[NSMutableArray alloc] init];
    ip6ret.destPort = [[NSMutableArray alloc] init];
    ip6ret.srcPort = [[NSMutableArray alloc] init];
        
    for (int i = 0; i < ret.i_id.count; i++)
    {        
        NSString* comment = [[NSString alloc] initWithFormat:@"%@", [ret.comment objectAtIndex:i]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (comment.length > 25)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:25]];
            }
        }
        else {
            if (comment.length > 100)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:100]];
            }
        }
        
        NSString* i_id = [[NSString alloc] initWithFormat:@"%@", [ret.i_id objectAtIndex:i]];
        NSString* dir = [[NSString alloc] initWithFormat:@"%@", [ret.direction objectAtIndex:i]];
        NSString* dest = [[NSString alloc] initWithFormat:@"%@", [ret.destIP objectAtIndex:i]];
        NSString* deac = [[NSString alloc] initWithFormat:@"%@", [ret.deactivated objectAtIndex:i]];
        NSString* tar = [[NSString alloc] initWithFormat:@"%@", [ret.target objectAtIndex:i]];
        NSString* dPort = [[NSString alloc] initWithFormat:@"%@", [ret.destPort objectAtIndex:i]];
        NSString* sPort = [[NSString alloc] initWithFormat:@"%@", [ret.srcPort objectAtIndex:i]];
        
        if ([[ret.destIP objectAtIndex:i] rangeOfString:@":"].location == NSNotFound)
        {
            [[ip4ret comment] addObject:comment];
            [[ip4ret i_id] addObject:i_id];
            [[ip4ret direction] addObject:dir];
            [[ip4ret destIP] addObject:dest];
            [[ip4ret deactivated] addObject:deac];
            [[ip4ret target] addObject:tar];
            [[ip4ret destPort] addObject:dPort];
            [[ip4ret srcPort] addObject:sPort];
        }
        else
        {
            [[ip6ret comment] addObject:comment];
            [[ip6ret i_id] addObject:i_id];
            [[ip6ret direction] addObject:dir];
            [[ip6ret destIP] addObject:dest];
            [[ip6ret deactivated] addObject:deac];
            [[ip6ret target] addObject:tar];
            [[ip6ret destPort] addObject:dPort];
            [[ip6ret srcPort] addObject:sPort];
        }
    }

    [[self firewallTable] reloadData];
}

- (void)viewDidUnload
{
    [self setFirewallTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        if (ip4ret.destIP.count != 0)
            return @"IPv4 - Firewall";
        else
            return @"IPv4 - Keine Regeln";
    }
    else
    {
        if (ip6ret.destIP.count != 0)
            return @"IPv6 - Firewall";
        else
            return @"IPv6 - Keine Regeln";
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
    
    if (ret.destIP.count != 0)
        return @"Grün: IPv4\nBlau: IPv6\n\nTippen Sie auf eine Regel um diese vollständig in einer eigenen Tabelle anzuzeigen.";
    else {
        return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if (section == 0)
        return ip4ret.i_id.count;
    else
        return ip6ret.i_id.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    cell.textLabel.numberOfLines = 0;
    
    if (indexPath.section == 0)
    {
        // IPv4 Auflistung
        
        NSString* comment = [[NSString alloc] initWithFormat:@"%@", [ip4ret.comment objectAtIndex:indexPath.row]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (comment.length > 25)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:25]];
            }
        }
        else {
            if (comment.length > 100)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:100]];
            }
        }
        
        NSString* dir = [[NSString alloc] initWithFormat:@"%@", [ip4ret.direction objectAtIndex:indexPath.row]];
        NSString* dest = [[NSString alloc] initWithFormat:@"%@", [ip4ret.destIP objectAtIndex:indexPath.row]];
        NSString* deac = [[NSString alloc] initWithFormat:@"%@", [ip4ret.deactivated objectAtIndex:indexPath.row]];
        NSString* tar = [[NSString alloc] initWithFormat:@"%@", [ip4ret.target objectAtIndex:indexPath.row]];
        NSString* dPort = [[NSString alloc] initWithFormat:@"%@", [ip4ret.destPort objectAtIndex:indexPath.row]];
        NSString* sPort = [[NSString alloc] initWithFormat:@"%@", [ip4ret.srcPort objectAtIndex:indexPath.row]];
        
        NSString* text = [[NSString alloc] initWithFormat:@"Kommentar: %@\nRichtung: %@\nZiel-IP: %@\nZiel-Port: %@\nQuell-Port: %@\nDeaktiviert: %@\nTarget: %@", comment, dir, dest, dPort, sPort, deac, tar];
        
        [cell.textLabel setText:text];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [cell setTag:[[ip4ret.i_id objectAtIndex:indexPath.row] integerValue]];
    }
    else
    {
        NSString* comment = [[NSString alloc] initWithFormat:@"%@", [ip6ret.comment objectAtIndex:indexPath.row]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            if (comment.length > 25)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:25]];
            }
        }
        else {
            if (comment.length > 100)
            {
                comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:100]];
            }
        }
        
        NSString* dir = [[NSString alloc] initWithFormat:@"%@", [ip6ret.direction objectAtIndex:indexPath.row]];
        NSString* dest = [[NSString alloc] initWithFormat:@"%@", [ip6ret.destIP objectAtIndex:indexPath.row]];
        NSString* deac = [[NSString alloc] initWithFormat:@"%@", [ip6ret.deactivated objectAtIndex:indexPath.row]];
        NSString* tar = [[NSString alloc] initWithFormat:@"%@", [ip6ret.target objectAtIndex:indexPath.row]];
        NSString* dPort = [[NSString alloc] initWithFormat:@"%@", [ip6ret.destPort objectAtIndex:indexPath.row]];
        NSString* sPort = [[NSString alloc] initWithFormat:@"%@", [ip6ret.srcPort objectAtIndex:indexPath.row]];
        
        NSString* text = [[NSString alloc] initWithFormat:@"Kommentar: %@\nRichtung: %@\nZiel-IP: %@\nZiel-Port: %@\nQuell-Port: %@\nDeaktiviert: %@\nTarget: %@", comment, dir, dest, dPort, sPort, deac, tar];
        
        [cell.textLabel setText:text];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
        [cell setTag:[[ip6ret.i_id objectAtIndex:indexPath.row] integerValue]];
    }
    
/*
    ====================================
    WIRD THEORETISCH NICHT MEHR BENÖTIGT
    ==================================== 
 
    NSString* comment = [[NSString alloc] initWithFormat:@"%@", [ret.comment objectAtIndex:indexPath.row]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (comment.length > 25)
        {
            comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:25]];
        }
    }
    else {
        if (comment.length > 100)
        {
            comment = [NSString stringWithFormat:@"%@ ...", [comment substringToIndex:100]];
        }
    }
    
    NSString* dir = [[NSString alloc] initWithFormat:@"%@", [ret.direction objectAtIndex:indexPath.row]];
    NSString* dest = [[NSString alloc] initWithFormat:@"%@", [ret.destIP objectAtIndex:indexPath.row]];
    NSString* deac = [[NSString alloc] initWithFormat:@"%@", [ret.deactivated objectAtIndex:indexPath.row]];
    NSString* tar = [[NSString alloc] initWithFormat:@"%@", [ret.target objectAtIndex:indexPath.row]];
    NSString* dPort = [[NSString alloc] initWithFormat:@"%@", [ret.destPort objectAtIndex:indexPath.row]];
    NSString* sPort = [[NSString alloc] initWithFormat:@"%@", [ret.srcPort objectAtIndex:indexPath.row]];
    
    NSString* text = [[NSString alloc] initWithFormat:@"Kommentar: %@\nRichtung: %@\nZiel-IP: %@\nZiel-Port: %@\nQuell-Port: %@\nDeaktiviert: %@\nTarget: %@", comment, dir, dest, dPort, sPort, deac, tar];
    
    [cell.textLabel setText:text];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cell setTag:[[ret.i_id objectAtIndex:indexPath.row] integerValue]];
    
    if ( [dest rangeOfString:@":"].location == NSNotFound && indexPath.section == 0 )
    {
        UIColor *farbe = [UIColor colorWithRed:100/ 255.f green:200/ 255.f blue:100/ 255.f alpha:1];
        [cell setBackgroundColor:farbe];
        [cell.textLabel setBackgroundColor:farbe];
    }
    else {
        UIColor *farbe = [UIColor colorWithRed:100/ 255.f green:100/ 255.f blue:200/ 255.f alpha:1];
        [cell setBackgroundColor:farbe];
        [cell.textLabel setBackgroundColor:farbe];
    }
 */
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.firewallRule = [[NSString alloc] initWithFormat:@"%i", [tableView cellForRowAtIndexPath:indexPath].tag];
    
    UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailRule"];
    [self.navigationController pushViewController:uvc animated:YES];
}

@end
