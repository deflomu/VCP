//
//  ViewController.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController
@synthesize textPassword;
@synthesize textUsername;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTextPassword:nil];
    [self setTextUsername:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.saveData = @"YES";
    if ( ((appDelegate.username.length != 0) && appDelegate.username != nil) && ((appDelegate.password.length != 0) && appDelegate.password != nil))
    {
        textUsername.text = appDelegate.username;
        textPassword.text = appDelegate.password;
    }
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
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return YES;
}

- (IBAction)changeSave:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UISwitch* swi = sender;
    
    if (swi.on == YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hinweis" message:@"Achtung: Ihre Benutzerdaten werden unverschlüsselt auf Ihrem Gerät gespeichert. Trotzdem kann nur dieses Programm auf die Daten zugreifen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        appDelegate.saveData = @"YES";
    }
    else
    {
        appDelegate.saveData = @"NO";
    }
}

- (IBAction)checkData:(id)sender {
    [textPassword resignFirstResponder];
    [textUsername resignFirstResponder];
    
    [textUsername setEnabled:NO];
    [textPassword setEnabled:NO];
    
    [sender setEnabled:NO];
    
    self.navigationItem.prompt = @"Bitte warten Sie! Daten werden geprüft ...";
    
    wsdlcheck* chkClass = [[wsdlcheck alloc] init];
    
    if([chkClass checkLogindata:textUsername.text :textPassword.text])
    {
        self.navigationItem.prompt = nil;
        [textPassword setEnabled:YES];
        [textUsername setEnabled:YES];
        [sender setEnabled:YES];
        
        [self setNameAndPw:textUsername.text :textPassword.text];                
        
        UIViewController *uvc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainNavigationController"];
        [self presentModalViewController:uvc animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Anmeldedaten falsch" message:@"Die eingegebenen Daten sind leider nicht korrekt!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.navigationItem.prompt = nil;
        [textPassword setEnabled:YES];
        [textUsername setEnabled:YES];
        [sender setEnabled:YES];
    }
    
}

- (IBAction)closeKeyboard:(id)sender {
    [textPassword resignFirstResponder];
    [textUsername resignFirstResponder];
}

-(void)setNameAndPw:(NSString*)username:(NSString*)password
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.username = username;
    appDelegate.password = password;
}

-(NSString*)getUsername
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.username;
}

-(NSString*)getPassword
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.password;
}

@end
