//
//  firewallRetData.h
//  VCP
//
//  Created by Jens Sproede on 08.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface firewallRetData : NSObject {
    NSMutableArray* comment;
    NSMutableArray* deactivated;
    NSMutableArray* destIP;
    NSMutableArray* destPort;
    NSMutableArray* direction;
    NSMutableArray* i_id;
    NSMutableArray* match;
    NSMutableArray* matchValue;
    NSMutableArray* protocol;
    NSMutableArray* sort;
    NSMutableArray* target;
    NSMutableArray* srcIP;
    NSMutableArray* srcPort;
}

@property (nonatomic,retain) NSMutableArray* comment;
@property (nonatomic,retain) NSMutableArray* deactivated;
@property (nonatomic,retain) NSMutableArray* destIP;
@property (nonatomic,retain) NSMutableArray* destPort;
@property (nonatomic,retain) NSMutableArray* direction;
@property (nonatomic,retain) NSMutableArray* i_id;
@property (nonatomic,retain) NSMutableArray* match;
@property (nonatomic,retain) NSMutableArray* matchValue;
@property (nonatomic,retain) NSMutableArray* protocol;
@property (nonatomic,retain) NSMutableArray* sort;
@property (nonatomic,retain) NSMutableArray* target;
@property (nonatomic,retain) NSMutableArray* srcIP;
@property (nonatomic,retain) NSMutableArray* srcPort;

@end
