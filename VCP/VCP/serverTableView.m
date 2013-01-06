//
//  serverTableView.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
 */

#import "serverTableView.h"
#import "AppDelegate.h"
#import "checkLogin.h"
#import "serverDetailsTableViewController.h"

@class serverDetailsTableViewController;

@implementation serverTableView

@synthesize ServerDetailsTableViewController = _serverDetailsTableViewController;
@synthesize serverTableView;
@synthesize servers;

- (void)reloadNow {
    [self receiveServers];
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
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
        
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStyleBordered target:self action:@selector(switchSettings)];
    
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, UITextAttributeFont, nil]; 
    [addButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(infoButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = infoItem;
        
    self.ServerDetailsTableViewController = (serverDetailsTableViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
            
    if ([appDelegate.device isEqualToString:@"iphone"])
    {
        servers = [[NSMutableArray alloc] init];
        [self receiveServers];
    }
    else {
        servers = [[NSMutableArray alloc] initWithObjects:@"Sie sind nicht angemeldet", nil];
    }
    
    if (appDelegate.atLeastIOS6)
    {
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Runterziehen zum Aktualisieren"];
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
    }
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Aktualisieren ..."];
    
    [self receiveServers];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Letztes Update: %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void) infoButton {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([appDelegate.device isEqualToString:@"iphone"])
    {
        UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutTableView"];
        [self.navigationController pushViewController:uvc animated:YES];
    }
    else {        
        [appDelegate.detail dismissPopover];
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(showAbout) userInfo:nil repeats:NO];
    }
}

- (void)showAbout {
    UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutTableView"];
    
    [uvc setModalPresentationStyle:UIModalPresentationFormSheet];
    [uvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:uvc];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentModalViewController:navController animated:YES];
}

- (void)receiveServers
{
    UIColor *color = [UIColor colorWithRed:51/255.f green:149/255.f blue:168/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = color;
    
    checkLogin* chk = [[checkLogin alloc] init];
    [chk getVServers:self];
}

- (void)servers:(NSMutableArray*)srv
{
    servers = srv;
    [self.serverTableView beginUpdates];
    [self.serverTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.serverTableView endUpdates];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.device isEqualToString:@"ipad"] && [[appDelegate.detail.navigationController.viewControllers objectAtIndex:appDelegate.detail.navigationController.viewControllers.count-1] isKindOfClass: [serverDetailsTableViewController class]] )
    {
        appDelegate.curServer = [servers objectAtIndex:0];
        self.ServerDetailsTableViewController.detailItem = appDelegate.curServer;
    }
       
    if (appDelegate.firstLogin && !appDelegate.pleaseLogout && [appDelegate.autoLoadServer isEqualToString:@"YES"] && (![appDelegate.device isEqualToString:@"ipad"]))
    {
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
    }
    appDelegate.firstLogin = false;
}

- (void)viewDidUnload
{
    [self setServerTableView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.pleaseLogout)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if ([appDelegate.device isEqualToString:@"ipad"])
        {
            [appDelegate.detail dismissPopover];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(logout) userInfo:nil repeats:NO];
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
    return 2;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        if ( servers.count != 0 )
        {
            return @"";
        }
        else {
            return @"Bitte warten ...";
        }
    else {
        return @"";
    }
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate.betaState isEqualToString:@"YES"])
        {
            return @"Sie sind im Beta-VCP angemeldet.";
        }
        else
        {
            return @"";
        }
    }
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    // Return the number of rows in the section.
    if ( section == 0 )
    {
        return servers.count;
    }
    else 
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [servers objectAtIndex:indexPath.row];
    }
    else 
    {
        cell.textLabel.text = @"Abmelden";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        if ( !([cell.textLabel.text isEqualToString:@"Keine Internetverbindung!"]) )
        {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.curServer = [servers objectAtIndex:indexPath.row];
            
            if ([appDelegate.device isEqualToString:@"ipad"])
                self.ServerDetailsTableViewController.detailItem = appDelegate.curServer;
            else {
                appDelegate.curServer = cell.textLabel.text;
                UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"serverDetailsTableViewController"];
                [self.navigationController pushViewController:uvc animated:YES];
            }
        }
    }
    else 
    {
        if ([cell.textLabel.text isEqualToString:@"Abmelden"])
        {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            if ([appDelegate.alwaysSaveLogin isEqualToString:@"YES"])
            {                
                [self logout];
            }
            else
            {
                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"Abmelden und Benutzerdaten ..." delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"löschen", @"speichern", nil];
                sheet.tag = 1;
                
                if ([appDelegate.device isEqualToString:@"ipad"])
                    [sheet showInView:self.view.window];
                else
                    [sheet showInView:self.view];
            }
        }
    }
}

- (void)switchSettings {
    UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"Hinweis" message:@"Aliasnamen können vorerst nicht bearbeitet werden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msg show];
//        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        
//        appDelegate.curServer = [[NSString alloc] initWithFormat:@"%@", cell.textLabel.text];
//        
//        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editServer"];
//        [self.navigationController pushViewController:uvc animated:YES];
    }
}

- (IBAction)refreshServers:(id)sender {
    [self receiveServers];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    if (actionSheet.tag == 1)
    {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"löschen"])
        {
            if ([appDelegate.dontAskBeforeDel isEqualToString:@"YES"])
            {
                [self deleteAndLogout];
            }
            else
            {
                UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Fortfahren?" message:@"Ihre Benutzerdaten werden aus dieser App entfernt und Sie müssen beim nächsten Anmelden Ihre  Benutzerdaten erneut eingeben." delegate:self cancelButtonTitle:@"Ja" otherButtonTitles:@"Nein", nil];
                al.tag = 1;
                [al show];
            }
        }
        else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"speichern"])
        {            
            if ([appDelegate.device isEqualToString:@"ipad"])
            {                
                [appDelegate.detail dismissPopover];
            }
            
            [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(logout) userInfo:nil repeats:NO];
        }
    }
}

- (void) logoutFull {    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.master logout];
}

- (void) deleteAndLogout {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.username = @"";
    appDelegate.password = @"";
    appDelegate.onlineFlag = @"NO";
    appDelegate.saveData = @"NO";
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:@"" forKey:@"username"];
        [standardUserDefaults setObject:@"" forKey:@"password"];
        [standardUserDefaults synchronize];
    }
    
    if ([appDelegate.device isEqualToString:@"ipad"])
    {
        [appDelegate.detail dismissPopover];
        
        [NSTimer scheduledTimerWithTimeInterval:0.500 target:self selector:@selector(logoutFull) userInfo:nil repeats:NO];
    }
    else {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentModalViewController:uvc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self deleteAndLogout];
        }
    }
}

- (void)clear {
    servers = [[NSMutableArray alloc] initWithObjects:@"Sie sind nicht angemeldet", nil];
    [[self serverTableView] reloadData];
}

- (void)logout {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.onlineFlag = @"NO";
    appDelegate.saveData = @"YES";
        
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:appDelegate.username forKey:@"username"];
        [standardUserDefaults setObject:appDelegate.password forKey:@"password"];
        [standardUserDefaults synchronize];
    }
    
    if ([appDelegate.device isEqualToString:@"ipad"])
    {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [uvc setModalPresentationStyle:UIModalPresentationFormSheet];
        [uvc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:uvc animated:YES completion:nil];
        [self clear];
        [appDelegate.detail.navigationController popToRootViewControllerAnimated:YES];
        [appDelegate.detail clear];
    }
    else {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationController"];
        [self presentModalViewController:uvc animated:YES];
    }
}

@end
