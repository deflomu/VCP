//
//  menuTableView.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface menuTableView : UITableViewController  <UIActionSheetDelegate, UIAlertViewDelegate>
{
    UIAlertView *alert;
    
    UISwitch *betaSwi;
}

@property (nonatomic, strong) NSMutableArray *optionList;

@end
