//
//  serverTableView.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class serverDetailsTableViewController;

@interface serverTableView : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate> {
    
    NSMutableArray* servers;
}

- (IBAction)refreshServers:(id)sender;
- (void)receiveServers;
- (void)servers:(NSMutableArray*)srv;
- (void) reloadNow;
- (void) logout;

@property (nonatomic,retain) IBOutlet UITableView *serverTableView;
@property (nonatomic, retain) NSMutableArray* servers;
@property (strong, nonatomic) serverDetailsTableViewController *ServerDetailsTableViewController;

@end
