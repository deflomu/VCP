//
//  detailRuleTableViewController.h
//  VCP
//
//  Created by Jens Sproede on 08.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "firewallRetData.h"

@interface detailRuleTableViewController : UITableViewController {
    NSMutableArray* ret;
    NSString* ruleID;
}
- (void)setzeRule:(firewallRetData*)rule;

@property (nonatomic,retain) IBOutlet UITableView *ruleTable;

@end
