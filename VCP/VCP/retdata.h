//
//  retdata.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface retdata : NSObject
{
    //NSString* ret;
    NSString* message;
    NSString* success;
    
    NSMutableArray* ret;
}

//@property (nonatomic, retain) NSString* ret;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSMutableArray* ret;

@end
