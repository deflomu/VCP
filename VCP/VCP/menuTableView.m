//
//  menuTableView.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "menuTableView.h"
#import "ipsTableViewController.h"
#import "AppDelegate.h"

@implementation menuTableView

@synthesize optionList;

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
}

- (void)viewDidUnload
{
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
    return 4;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1)
    {        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate.device isEqualToString:@"ipad"])
        {
            return @"";
        }
        else
            return @"Nach dem Anmelden";
    }
    else if (section == 2) return @"IP-Adressen";
    else if (section == 3)return @"vServer Control Panel";
    else return @"Benutzerdaten";
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate.device isEqualToString:@"ipad"])
            return @"";
        else
            return @"Der erste vServer wird automatisch angezeigt, sobald Sie angemeldet sind.";
    }    
    else if (section == 3) return @"Sobald Sie diese Einstellung ändern werden Sie automatisch abgemeldet und anschließend wieder angemeldet.\n\nDiese Einstellung kann im \"Über\"-Bildschirm zurückgesetzt werden.";
    else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 1)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate.device isEqualToString:@"ipad"])
        {
            return 0;
        }
        else
        {
            return 1;
        }
    }
    else if (section == 2) return 2;
    else if (section == 0) return 2;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            if ( [appDelegate.alwaysSaveLogin isEqualToString:@"YES"] )
            {
                swi.on = YES;
            }
            else
            {
                swi.on = NO;
            }
            
            [swi addTarget:self action:@selector(flipAutosave:) forControlEvents:UIControlEventValueChanged];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.textLabel setText:@"Immer speichern"];
            
            cell.accessoryView = swi;
        }
        else
        {
            UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            if ( [appDelegate.dontAskBeforeDel isEqualToString:@"YES"] )
            {
                swi.on = YES;
            }
            else
            {
                swi.on = NO;
            }
            
            [swi addTarget:self action:@selector(flipAskBeforeDelete:) forControlEvents:UIControlEventValueChanged];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.textLabel setText:@"Fragen vorm Löschen"];
            
            cell.accessoryView = swi;
        }
    }
    if (indexPath.section == 1)
    {
        UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if ( [appDelegate.autoLoadServer isEqualToString:@"YES"] )
        {
            swi.on = YES;
        }
        else
        {
            swi.on = NO;
        }
        
        [swi addTarget:self action:@selector(flipAutoload:) forControlEvents:UIControlEventValueChanged];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.textLabel setText:@"Ersten vServer öffnen"];
        //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:12.0]];        
        
        cell.accessoryView = swi;

    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            if ( [appDelegate.removeSubnet isEqualToString:@"YES"] )
            {
                swi.on = YES;
            }
            else
            {
                swi.on = NO;
            }
            
            [swi addTarget:self action:@selector(flipSubnet:) forControlEvents:UIControlEventValueChanged];
                        
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        
            [cell.textLabel setText:@"Subnetze ausblenden"];
            //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
            
            cell.accessoryView = swi;
        }
        else if (indexPath.row == 1)
        {
            UISwitch *swi = [[UISwitch alloc] initWithFrame:CGRectZero];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            
            if ( [appDelegate.forceIPv4 isEqualToString:@"YES"] )
            {
                swi.on = YES;
            }
            else
            {
                swi.on = NO;
            }
            
            [swi addTarget:self action:@selector(flipForce4:) forControlEvents:UIControlEventValueChanged];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            [cell.textLabel setText:@"IPv4 in der Übersicht"];
            
            cell.accessoryView = swi;
        }
    }
    else if (indexPath.section == 3 && indexPath)
    {
        betaSwi = [[UISwitch alloc] initWithFrame:CGRectZero];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if ( ![appDelegate.beta isEqualToString:@"https://www.vservercontrolpanel.de/WSEndUser"] )
        {
            betaSwi.on = YES;
        }
        else
        {
            betaSwi.on = NO;
        }
        
        [betaSwi addTarget:self action:@selector(flipBeta:) forControlEvents:UIControlEventValueChanged];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.textLabel setText:@"Beta-VCP verwenden"];
        
        cell.accessoryView = betaSwi;

    }
    
    return cell;
}

- (IBAction)flipAutosave:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
        }
        else {
            state = @"NO";
        }
        appDelegate.alwaysSaveLogin = state;
        [standardUserDefaults setObject:state forKey:@"autosave"];
        [standardUserDefaults synchronize];
    }
}

- (IBAction)flipAskBeforeDelete:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
        }
        else {
            state = @"NO";
        }
        appDelegate.dontAskBeforeDel = state;
        [standardUserDefaults setObject:state forKey:@"askdelete"];
        [standardUserDefaults synchronize];
    }
}

- (IBAction)flipAutoload:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
        }
        else {
            state = @"NO";
        }
        appDelegate.autoLoadServer = state;
        [standardUserDefaults setObject:state forKey:@"autoshow"];
        [standardUserDefaults synchronize];
        
        if (appDelegate.detail != nil)
        {
            if ( [[appDelegate.detail.navigationController.viewControllers objectAtIndex:appDelegate.detail.navigationController.viewControllers.count-1] isKindOfClass: [serverDetailsTableViewController class]])
            {
                [appDelegate.detail reloadServerData];
            }
        }
    }
    
}

- (IBAction)flipBeta:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults)
    {
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
            alert = [[UIAlertView alloc] initWithTitle:@"Wichtiger Hinweis" message:@"Aktivieren Sie diesen Schalter nur, wenn Sie Zugriff zum Beta-VCP haben. Ansonsten können Sie sich nicht mehr anmelden.\n\nSie werden nun abgemeldet und anschließend wieder angemeldet." delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Fortfahren", nil];
            alert.tag = 1;
            [alert show];
        }
        else {
            state = @"NO";
            
            alert = [[UIAlertView alloc] initWithTitle:@"Hinweis" message:@"Sie werden nun abgemeldet und anschließend wieder angemeldet." delegate:self cancelButtonTitle:@"Abbrechen" otherButtonTitles:@"Fortfahren", nil];
            alert.tag = 2;
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            betaSwi.on = NO;
        }
        else
        {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            if (standardUserDefaults)
            {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate changeLogintype:@"YES"];
                [standardUserDefaults setObject:@"YES" forKey:@"beta"];
                [standardUserDefaults synchronize];
                appDelegate.pleaseLogout = true;
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 0)
        {
            betaSwi.on = YES;
        }
        else
        {
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            if (standardUserDefaults)
            {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                [appDelegate changeLogintype:@"NO"];
                [standardUserDefaults setObject:@"NO" forKey:@"beta"];
                [standardUserDefaults synchronize];
                appDelegate.pleaseLogout = true;
                [[self navigationController] popToRootViewControllerAnimated:YES];
            }
        }

    }
}

- (IBAction)flipForce4:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) 
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
        }
        else {
            state = @"NO";
        }
        appDelegate.forceIPv4 = state;
        [standardUserDefaults setObject:state forKey:@"forceIP4"];
        [standardUserDefaults synchronize];
        
        if (appDelegate.detail != nil)
        {
            if ( [[appDelegate.detail.navigationController.viewControllers objectAtIndex:appDelegate.detail.navigationController.viewControllers.count-1] isKindOfClass: [serverDetailsTableViewController class]])
            {
                [appDelegate.detail reloadServerData];
            }
        }
    }    

}

- (IBAction)flipSubnet:(id)sender {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) 
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		UISwitch* swi = (UISwitch*)sender;
        NSString* state = [[NSString alloc] init];
        
        if (swi.on)
        {
            state = @"YES";
        }
        else {
            state = @"NO";
        }
        appDelegate.removeSubnet = state;
        [standardUserDefaults setObject:state forKey:@"explodeSubnet"];
        [standardUserDefaults synchronize];
        
        if (appDelegate.detail != nil) 
        {
            if ( [[appDelegate.detail.navigationController.viewControllers objectAtIndex:appDelegate.detail.navigationController.viewControllers.count-1] isKindOfClass: [serverDetailsTableViewController class]])
            {
                [appDelegate.detail reloadServerData];
            }
            else if ( [[appDelegate.detail.navigationController.viewControllers objectAtIndex:appDelegate.detail.navigationController.viewControllers.count-1] isKindOfClass: [ipsTableViewController class]])
            {
                [appDelegate.detail.navigationController popToRootViewControllerAnimated:NO];
                UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ipTableView"];
                [appDelegate.detail.navigationController pushViewController:uvc animated:NO];
            }
        }
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

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}*/

@end
