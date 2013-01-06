//
//  loginTableViewController.h
//  VCP
//
//  Created by Jens Sproede on 02.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "checkLogin.h"

@class checkLogin;

@interface loginTableViewController : UITableViewController <UITextFieldDelegate> {
    UITextField *username;
    UITextField *password;
    BOOL saveEnable;
    
    checkLogin *ch;
    UIActivityIndicatorView* indicator;
    
    UITableViewCell* loginCell;
    
    
}

@property (nonatomic,retain) IBOutlet UITableView *tableLogin;
@property (nonatomic,retain) UITextField *username;
@property (nonatomic,retain) UITextField *password;

- (void) closeKeyboard;
- (void)loginsuccess;
- (void)setNameAndPw;
- (void)reloadTable;

@end
