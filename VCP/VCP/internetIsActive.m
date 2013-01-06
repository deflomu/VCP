//
//  internetIsActive.m
//  VCP
//
//  Created by Jens Sproede on 06.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "internetIsActive.h"
#import "Reachability.h"

@implementation internetIsActive

- (BOOL)connected 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}

@end
