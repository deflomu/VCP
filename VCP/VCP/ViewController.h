//
//  ViewController.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UITextField *textUsername;

- (IBAction)changeSave:(id)sender;
- (IBAction)checkData:(id)sender;
- (IBAction)closeKeyboard:(id)sender;
-(void)setNameAndPw:(NSString*)username:(NSString*)password;
-(NSString*)getUsername;
-(NSString*)getPassword;

@end
