//
//  processViewController.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "processViewController.h"
#import "checkLogin.h"
#import "AppDelegate.h"

@implementation processViewController
@synthesize processTextView;
@synthesize processWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.toolbarHidden =YES;
    
    UIBarButtonItem* bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadProcesses)];
    
    self.navigationItem.rightBarButtonItem = bbi;
    
    self.title = [NSString stringWithFormat:@"Prozessliste"];
    [self reloadProcesses];
}

- (void)reloadProcesses
{
    checkLogin* chk = [[checkLogin alloc] init];
    [chk getVServerProcesses:self];
}

- (void)setzeProzesse:(NSString*)t {
    if ([t isEqualToString:@"undefined error"])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate errorWhileLoad];
        [processTextView setText:@"Es ist ein Fehler aufgetreten."];
    }
    else
    {
        [processTextView setText:t];
    }
}

- (void)viewDidUnload
{
    [self setProcessTextView:nil];
    [self setProcessWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return YES;
}

@end
