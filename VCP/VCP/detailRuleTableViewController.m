//
//  detailRuleTableViewController.m
//  VCP
//
//  Created by Jens Sproede on 08.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "detailRuleTableViewController.h"
#import "AppDelegate.h"
#import "checkLogin.h"
#import "firewallRetData.h"

@interface detailRuleTableViewController ()

@end

@implementation detailRuleTableViewController
@synthesize ruleTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)reloadRule {
    checkLogin* chk = [[checkLogin alloc] init];
    [chk getVServerSpecificRule:self:ruleID];
}

- (void)setzeRule:(firewallRetData*)rule
{
    ret = [[NSMutableArray alloc] initWithCapacity:13];
    
    [ret addObject:[rule.comment objectAtIndex:0]];
    [ret addObject:[rule.deactivated objectAtIndex:0]];
    [ret addObject:[rule.destIP objectAtIndex:0]];
    [ret addObject:[rule.destPort objectAtIndex:0]];
    [ret addObject:[rule.direction objectAtIndex:0]];
    [ret addObject:[rule.i_id objectAtIndex:0]];
    [ret addObject:[rule.match objectAtIndex:0]];
    [ret addObject:[rule.matchValue objectAtIndex:0]];
    [ret addObject:[rule.protocol objectAtIndex:0]];
    [ret addObject:[rule.sort objectAtIndex:0]];
    [ret addObject:[rule.srcIP objectAtIndex:0]];
    [ret addObject:[rule.srcPort objectAtIndex:0]];
    [ret addObject:[rule.target objectAtIndex:0]];
    
    [[self ruleTable] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.atLeastIOS6)
    {
        UIBarButtonItem* reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadRule)];
        self.navigationItem.rightBarButtonItem = reload;
    }
    
    ruleID = [[NSString alloc] initWithFormat:@"%@", appDelegate.firewallRule];
    
    [self reloadRule];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    [self reloadRule];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}


- (void)viewDidUnload
{
    [self setRuleTable:nil];
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
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ( [ret objectAtIndex:9] == nil )
    {
        return @"Bitte warten ...";
    }
    else 
    {
        NSString* ruleNumber = [NSString stringWithFormat:@"Regeldetails von Regel %@", [ret objectAtIndex:9]];
        return ruleNumber;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ret.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    switch (indexPath.row) {
        case 0:
            [cell.textLabel setText:@"Kommentar"];
            break;
        case 1:
            [cell.textLabel setText:@"Deaktiviert"];
            break;
        case 2:
            [cell.textLabel setText:@"Ziel IP"];
            break;
        case 3:
            [cell.textLabel setText:@"Ziel Port"];
            break;
        case 4:
            [cell.textLabel setText:@"Richtung"];
            break;
        case 5:
            [cell.textLabel setText:@"ID"];
            break;
        case 6:
            [cell.textLabel setText:@"Match"];
            break;
        case 7:
            [cell.textLabel setText:@"MatchValue"];
            break;
        case 8:
            [cell.textLabel setText:@"Protokoll"];
            break;
        case 9:
            [cell.textLabel setText:@"Nummer"];
            break;
        case 10:
            [cell.textLabel setText:@"Src IP"];
            break;
        case 11:
            [cell.textLabel setText:@"Src Port"];
            break;
        case 12:
            [cell.textLabel setText:@"Target"];
            break;
        default:
            break;
    }
    
    [cell.detailTextLabel setText:[ret objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
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
