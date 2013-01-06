//
//  aboutTableViewController.m
//  VCP
//
//  Created by Jens Sproede on 25.11.12.
//
//

#import "aboutTableViewController.h"
#import "AppDelegate.h"
#import "Appirater.h"

@interface aboutTableViewController ()

@end

@implementation aboutTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
    UIColor *color = [UIColor colorWithRed:51/255.f green:149/255.f blue:168/255.f alpha:1];
    self.navigationController.navigationBar.tintColor = color;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate.device isEqualToString:@"ipad"] && [appDelegate.onlineFlag isEqualToString:@"YES"])
    {
        UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithTitle:@"Schließen" style:UIBarButtonItemStylePlain target:self action:@selector(closeMe)];
        self.navigationItem.leftBarButtonItem = bbi;
    }
}

- (void) closeMe {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 0;
    else if (section == 1) return 3;
    else
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate.onlineFlag isEqualToString:@"YES"])
            return 0;
        else return 1;
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) return @"Diese App ermöglicht Ihnen den Zugriff auf den Webservice des vServer Control Panels von netcup.\n\nnetcup bietet für diese App keinen Produktsupport an!";
    else if (section == 2)
    {
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:now];
        
        return [[NSString alloc] initWithFormat:@"\nVCP App - © %@ Jens Sproede\nVersion: %@", year, [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    }
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section == 0 && indexPath.row == 0)
    {}
    else if (indexPath.section == 1)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        if (indexPath.row == 0)
        {
            [cell.textLabel setText:@"Webseite des Entwicklers"];
        }
        else if (indexPath.row == 1)
        {
            [cell.textLabel setText:@"E-Mail an den Entwickler"];
        }
        else
        {
            [cell.textLabel setText:@"Diese App bewerten"];
        }
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setText:@"VCP-Einstellung zurücksetzen"];
    }
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) return 120;
    else return tableView.rowHeight;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"Webseite des Entwicklers"])
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"https://jenssproede.de/?seite=vcp"];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ([cell.textLabel.text isEqualToString:@"E-Mail an den Entwickler"])
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: @"mailto:?to=jens@jenssproede.de&subject=VCP"];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ([cell.textLabel.text isEqualToString:@"Diese App bewerten"])
    {
        [Appirater rateApp];
    }
    else if ([cell.textLabel.text isEqualToString:@"VCP-Einstellung zurücksetzen"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate changeLogintype:@"NO"];
        
        UIAlertView* msg = [[UIAlertView alloc] initWithTitle:@"Hinweis" message:@"Die VCP-Einstellung wurde zurückgesetzt.\n\nSie melden sich nun wieder im offiziellen VCP an." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msg show];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
