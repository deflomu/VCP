//
//  serverDetailsTableViewController.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "serverDetailsTableViewController.h"
#import "checkLogin.h"
#import "AppDelegate.h"

@interface serverDetailsTableViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
- (void)reloadServerData;
- (void)setDetailItem:(id)newDetailItem;
- (void)dismissPopover;
- (void)clear;
@end


@implementation serverDetailsTableViewController

@synthesize detailItem = _detailItem;
@synthesize table = _table;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize serverDetailTableView;

- (void)setDetailItem:(id)newDetailItem
{
    // Server soll sich immer ändern, auch wenn man auf den selben wieder Tippt -->>
    //if (_detailItem != newDetailItem) {
    
    
    _detailItem = newDetailItem;
    [self configureView];
    
    
    //}
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSString* serverName = appDelegate.curServer;
        self.title = serverName;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        if ([self.detailItem rangeOfString:@"v"].location != NSNotFound)
            [self reloadServerData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!appDelegate.atLeastIOS6)
    {
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadServerData)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    
    NSString* serverName = appDelegate.curServer;
    
    self.title = serverName;
    
    online = [[NSString alloc] init];
    load = [[NSString alloc] init];
    uptime = [[NSString alloc] init];
    ip = [[NSString alloc] init];
    
    reloadTries = 0;
    shown = false;
    
    if ([appDelegate.device isEqualToString:@"iphone"])
        [self reloadServerData];
    
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
    
    [self reloadServerData];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)showProcesses
{
    UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"processView"];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)setzeState:(NSString*)s {
    if (reloadTries > 3)
    {
        [self showError];
        return;
    }
    
    if ([s isEqualToString:@"undefined error"])
    {
        reloadTries++;
        [self reloadState];
        return;
    }
    else
    {
        online = s;
        [[self serverDetailTableView] reloadData];
    }
}

- (void)setzeLoad:(NSString*)l {
    if (reloadTries > 3)
    {
        [self showError];
        return;
    }
    
    if ([l isEqualToString:@"undefined error"])
    {
        reloadTries++;
        [self reloadLoad];
        return;
    }
    else
    {
        load = l;
        [[self serverDetailTableView] reloadData];
    }
}

- (void)setzeUptime:(NSString*)u {
    if (reloadTries > 3)
    {
        [self showError];
        return;
    }
    
    if ([u isEqualToString:@"undefined error"])
    {
        reloadTries++;
        [self reloadUptime];
        return;
    }
    else
    {
        uptime = u;
        [[self serverDetailTableView] reloadData];
    }
}
    
- (void)setzeIP:(NSString*)i {
    if (reloadTries > 3)
    {
        [self showError];
        return;
    }
    
    if ([i isEqualToString:@"undefined error"] || [i rangeOfString:@"function"].location != NSNotFound)
    {
        reloadTries++;
        [self reloadIP];
        return;
    }
    else
    {
        ip = i;
        [[self serverDetailTableView] reloadData];
    }
}

- (void)showError{
    if (!shown)
    {
        shown = true;
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(goBack) userInfo:nil repeats:NO];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate errorWhileLoad];
    }
}

- (void)goBack {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([appDelegate.device isEqualToString:@"iphone"])
        [[self navigationController] popToRootViewControllerAnimated:YES];
    else
    {
        uptime = @"";
        load = @"";
        ip = @"";
        online = @"Fehler";
        appDelegate.curServerOnline = @"Fehler";
        [[self serverDetailTableView] reloadData];
        
        reloadTries = 0;
        shown = false;
    }
}

- (void)reloadServerData
{
    if (reloadTries <= 10)
    {        
        [self reloadState];
        [self reloadLoad];
        [self reloadUptime];
        [self reloadIP];
    }
    else if (!shown)
    {
        shown = true;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate errorWhileLoad];
        [[self navigationController] popToRootViewControllerAnimated:YES];
        return;
    }
}

- (void)reloadState {
    checkLogin *chk = [[checkLogin alloc] init];
    [chk getVServerState:self :@"state"];
}

- (void)reloadLoad {
    checkLogin *chk = [[checkLogin alloc] init];
    [chk getVServerLoad:self :@"load"];
}

- (void)reloadUptime {
    checkLogin *chk = [[checkLogin alloc] init];
    [chk getVServerUptime:self :@"uptime"];
}

- (void)reloadIP {
    checkLogin *chk = [[checkLogin alloc] init];
    [chk getVServerIP:self :@"ip"];
}

- (void)viewDidUnload
{
    [self setServerDetailTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.onlineFlag isEqualToString:@"NO"])
    {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [uvc setModalPresentationStyle:UIModalPresentationFormSheet];
        [uvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:uvc animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void) clear {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.curServer = @"Detailansicht";
    self.title = @"Detailansicht";
    [[self serverDetailTableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];   
        
    if ([appDelegate.curServer rangeOfString:@"v"].location != NSNotFound)
    {
        return 3;
    }
    else 
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([appDelegate.curServer rangeOfString:@"v"].location != NSNotFound)
    {
        if (section == 0)
        {
            return 4;
        }
        else if (section == 1)
            return 1;
        else
            return 2;
        }
    else {
        return 0;
    }
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
   
    if (section == 0)
        return @"Serverinformationen";
    else if (section == 1)
        return @"Server steuern";
    else
        return @"Sonstiges";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"serverDetails"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 0)
    {         
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"serverDetails"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Status";
            cell.detailTextLabel.text = online;
            
            if ([online isEqualToString:@"Online"])
            {
                [cell.detailTextLabel setTextColor:[UIColor colorWithRed:50/255.f green:110/255.f blue:50/255.f alpha:1]]; 
            }
            else 
            {
                [cell.detailTextLabel setTextColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
            }
            
            appDelegate.curServerOnline = online;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Auslastung";
            cell.detailTextLabel.text = load;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"Laufzeit";
            cell.detailTextLabel.text = uptime;
        }
        else if (indexPath.row == 3)
        {
            cell.textLabel.text = @"IP";
            cell.detailTextLabel.text = ip;
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        
        if ([appDelegate.curServerOnline isEqualToString:@"Fehler"])
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.userInteractionEnabled = false;
        }
    
        return cell;
    }
    else if (indexPath.section == 1)
    {           
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        if (indexPath.row == 0)
        {
            if ( [appDelegate.curServerOnline isEqualToString:@"Online"] )
            {                
                [cell.textLabel setText:@"Server stoppen"];
            }
            else if ([appDelegate.curServerOnline isEqualToString:@"Offline"])
            {
                [cell.textLabel setText:@"Server starten"];
            }
            else if ([appDelegate.curServerOnline isEqualToString:@"Fehler"])
            {
                [cell.textLabel setText:@"Server starten / stoppen"];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                cell.userInteractionEnabled = false;
            }
            else
            {
                [cell.textLabel setText:@"Bitte warten ..."];
            }
        }
        
        return cell;
    }
    else
    {
        if (indexPath.row == 0)
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];        
            [cell.textLabel setText:@"Prozessliste"];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:@"Firewall"];
        }
        
        if ([appDelegate.curServerOnline isEqualToString:@"Fehler"])
        {
            cell.userInteractionEnabled = false;
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
            
        return cell;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"Prozessliste"])
    {
        [self showProcesses];
    }
    else if ([cell.textLabel.text isEqualToString:@"Firewall"])
    {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"firewallView"];
        [self.navigationController pushViewController:uvc animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"IP"])
    {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ipTableView"];
        [self.navigationController pushViewController:uvc animated:YES];
    }
    else if ([cell.textLabel.text isEqualToString:@"Server starten"])
    {    
        UIAlertView* cmd = [[UIAlertView alloc] initWithTitle:@"vServer starten?" message:@"Möchten Sie den vServer wirklich starten?" delegate:self cancelButtonTitle:@"Ja" otherButtonTitles:@"Nein", nil];
        cmd.tag = 11;
        [cmd show];
    }
    else if ([cell.textLabel.text isEqualToString:@"Server stoppen"])
    {                
        UIAlertView* cmd = [[UIAlertView alloc] initWithTitle:@"vServer stoppen?" message:@"Möchten Sie den vServer wirklich stoppen?" delegate:self cancelButtonTitle:@"Ja" otherButtonTitles:@"Nein", nil];
        cmd.tag = 12;
        [cmd show];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 11)
    {
        if (buttonIndex == 0)
        {   
            checkLogin* chk = [[checkLogin alloc] init];
            [chk changeVServerState:self:@"start"];
        }
    }
    else if (actionSheet.tag == 12)
    {
        if (buttonIndex == 0)
        {
            checkLogin* chk = [[checkLogin alloc] init];
            [chk changeVServerState:self:@"stop"];
        }
    }
}

- (void) dismissPopover {
    [self.masterPopoverController dismissPopoverAnimated:YES];
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"vServer", @"vServer");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
