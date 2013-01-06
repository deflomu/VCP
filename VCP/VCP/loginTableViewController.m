//
//  loginTableViewController.m
//  VCP
//
//  Created by Jens Sproede on 02.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "loginTableViewController.h"
#import "AppDelegate.h"
#import "serverTableView.h"


@implementation loginTableViewController
@synthesize tableLogin;
@synthesize username;
@synthesize password;

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

    self.title = @"Anmelden";
    
    UIColor *color = [UIColor colorWithRed:51/255.f green:149/255.f blue:168/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = color;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [button addTarget:self action:@selector(infoButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = infoItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) infoButton {
    UIViewController* uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutTableView"];
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)viewDidUnload
{
    [self setTableLogin:nil];
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
    appDelegate.firstLogin = true;
    
    if (appDelegate.pleaseLogout)
    {
        appDelegate.pleaseLogout = false;
        NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:0 inSection:1];
        [self tableView:self.tableView didSelectRowAtIndexPath:selectedCellIndexPath];
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

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (NSString *) tableView:(UITableView *) tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0)
        return @"";
    else {
        return @"Sie können nach dem Abmelden wählen, ob Ihre Benutzerdaten in dieser App gespeichert werden sollen oder nicht.";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return 2;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ( ((appDelegate.username.length != 0) && appDelegate.username != nil))
        {
            saveEnable = true;
        }

        
        static NSString *CellIdentifier = @"cells";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
        UITextField *textF;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            //textF = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 370, 30)];
            textF = [[UITextField alloc] initWithFrame:CGRectMake(40, 10, 460, 30)];
        }
        else {
            //textF = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 195, 30)];
            textF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 285, 30)];
        }
        
        textF.adjustsFontSizeToFitWidth = YES;
        textF.textColor = [UIColor blackColor];
        if ([indexPath row] == 0) {
            textF.placeholder = @"Benutzername";
            textF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textF.returnKeyType = UIReturnKeyNext;
        }
        else {
            textF.placeholder = @"Passwort";
            textF.keyboardType = UIKeyboardTypeDefault;
            textF.returnKeyType = UIReturnKeyDone;
            textF.secureTextEntry = YES;
        }       
        textF.backgroundColor = cell.backgroundColor;
        textF.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        textF.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
        textF.textAlignment = UITextAlignmentLeft;
        textF.tag = 0;
        textF.delegate = self;
        //textF.delegate = self;
        
        textF.clearButtonMode = UITextFieldViewModeWhileEditing ; // no clear 'x' button to the right
        [textF setEnabled: YES];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ( indexPath.row == 0 )
        {
            if (saveEnable)
                textF.text = appDelegate.username;
            
            //[cell.textLabel setText:@"Name"];
            [cell addSubview:textF];
            
            username = textF;            
        }
        else
        {
            if (saveEnable)
                textF.text = appDelegate.password;
                
            //[cell.textLabel setText:@"Passwort"];
            [cell addSubview:textF];
            
            password = textF;
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"cells";
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [cell.textLabel setText:@"Anmelden"];
        
        return cell;
    }
}

- (void)loginsuccess
{    
    [password resignFirstResponder];
    [username resignFirstResponder];
    
    [username setEnabled:NO];
    [password setEnabled:NO];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
    self.navigationItem.prompt = nil;
    [username setEnabled:YES];
    [password setEnabled:YES];
        
    [self setNameAndPw];                
        
    appDelegate.onlineFlag = @"YES";
        
    if ([appDelegate.device isEqualToString:@"iphone"])
    {
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
        [self presentModalViewController:uvc animated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
        [appDelegate.master receiveServers];
    }
}

-(void)setNameAndPw
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.username = username.text;
    appDelegate.password = password.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == username)
    {
        [password becomeFirstResponder];
    }
    else if (textField == password)
    {
        [self closeKeyboard];
    }
    return YES;
}

- (void) closeKeyboard
{
    [username resignFirstResponder];
    [password resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.device isEqualToString:@"iphone"])
    {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Fertig" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyboard)];
        self.navigationItem.rightBarButtonItem = bbi; 
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
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
    
    if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Anmelden"])
    {
        if (username.text.length != 0 && password.text.length != 0)
        {
            username.enabled = NO;
            password.enabled = NO;
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            appDelegate.username = username.text;
            appDelegate.password = password.text;
            
            checkLogin *chk = [[checkLogin alloc] init];
            ch = chk;
            [chk checkLogindata:username.text :password.text: self];
        
            loginCell = [tableView cellForRowAtIndexPath:indexPath];
        
            [tableView cellForRowAtIndexPath:indexPath].textLabel.text = @"Abbrechen";
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indicator startAnimating];
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryView:indicator];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Fehler" message:@"Sie haben keine Benutzerdaten eingetragen!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Abbrechen"])
    {
        
        [NSTimer scheduledTimerWithTimeInterval:0.250 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
        
        if (ch != nil)
        {
        }
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)reloadTable {
    [indicator removeFromSuperview];
    loginCell.textLabel.text = @"Anmelden";
    [loginCell setAccessoryView:nil];
    [loginCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    username.enabled = YES;
    password.enabled = YES;
    
    if (ch != nil)
    {
        [ch abortConn];
        ch = nil;
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [[self tableLogin] reloadData];
    }
}

@end
