//
//  serverDetailsTableViewController.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface serverDetailsTableViewController : UITableViewController <UISplitViewControllerDelegate>{
    NSString* online;
    NSString* load;
    NSString* uptime;
    NSString* ip;
    
    int reloadTries;
    bool shown;
}
@property (nonatomic,retain) IBOutlet UITableView *serverDetailTableView;

@property (strong, nonatomic) id detailItem;
@property (nonatomic,retain) IBOutlet UITableView *table;

- (void)reloadServerData;
- (void)showProcesses;

- (void)setzeState:(NSString*)s;
- (void)setzeLoad:(NSString*)l;
- (void)setzeUptime:(NSString*)u;
- (void)setzeIP:(NSString*)i;

- (void)dismissPopover;
- (void)clear;

@end
