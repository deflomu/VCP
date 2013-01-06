//
//  FirewallViewController.h
//  VCP
//
//  Created by Jens Sproede on 07.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "firewallRetData.h"

@interface FirewallViewController : UITableViewController {
    UIToolbar *tb;
    
    UIBarButtonItem* refresh;
    UIBarButtonItem* add;
    
    firewallRetData* ret;
    
    firewallRetData* ip4ret;
    firewallRetData* ip6ret;
        
    int counter;    
    int amount4;
    int amount6;
}

@property (nonatomic,retain) IBOutlet UITableView *firewallTable;
- (void)setFirewall:(firewallRetData*)rett;

@end
