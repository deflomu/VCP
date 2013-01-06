//
//  ipsTableViewController.h
//  VCP
//
//  Created by Jens Sproede on 06.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ipsTableViewController : UITableViewController {
    NSMutableArray* IPs;
    
    NSMutableArray* IPv4;
    NSMutableArray* IPv6;
    
    UIPasteboard *pasteboard;
}
@property (nonatomic,retain) IBOutlet UITableView *ipsTable;


- (void)setIPs:(NSMutableArray*)ip_list;
- (void)reloadIPs;


@end
