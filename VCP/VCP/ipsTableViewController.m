//
//  ipsTableViewController.m
//  VCP
//
//  Created by Jens Sproede on 06.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ipsTableViewController.h"
#import "AppDelegate.h"
#import "checkLogin.h"

@interface ipsTableViewController ()
- (void)reloadIPs;
@end

@implementation ipsTableViewController
@synthesize ipsTable;

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
    self.title = @"IP-Adressen";
    
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (!appDelegate.atLeastIOS6)
    {
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadIPs)];
        [self.navigationItem setRightBarButtonItem:bbi];
    }
    
    [self reloadIPs];
    
    if (appDelegate.atLeastIOS6)
    {
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Runterziehen zum Aktualisieren"];
        [refresh addTarget:self
                action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
    }
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Aktualisieren ..."];
    
    [self reloadIPs];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)reloadIPs {
    checkLogin* chk = [[checkLogin alloc] init];
    [chk getVServerIPs:self];
}

- (void)setIPs:(NSMutableArray*)ip_list
{
    IPs = [[NSMutableArray alloc] init];
    IPv4 = [[NSMutableArray alloc] init];
    IPv6 = [[NSMutableArray alloc] init];
    
    IPs = ip_list;
    
    for (int i = 0; i < IPs.count; i++)
    {
        if ([[IPs objectAtIndex:i] rangeOfString:@":"].location == NSNotFound)
        {
            [IPv4 addObject:[IPs objectAtIndex:i]];
        }
        else {
            [IPv6 addObject:[IPs objectAtIndex:i]];
        }
    }
    
    [[self ipsTable] reloadData];
}

- (void)viewDidUnload
{
    [self setIpsTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections. 
    if (IPv4.count > 0 && IPv6.count > 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        return IPv4.count;
    }
    else {
        return IPv6.count;
    }
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (IPv4.count == 0 && IPv6.count == 0)
    {
        return @"Bitte warten ...";
    }
    
    if (section == 0)
    {
        return @"IPv4";
    }
    else {
        return @"IPv6";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [IPv4 objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [IPv6 objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
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
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
