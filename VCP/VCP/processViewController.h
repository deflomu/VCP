//
//  processViewController.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "wsdlcheck.h"

@interface processViewController : UIViewController
@property (nonatomic,retain) IBOutlet UITextView *processTextView;
@property (weak, nonatomic) IBOutlet UIWebView *processWebView;

- (void)reloadProcesses;
- (void)setzeProzesse:(NSString*)t;

@end
