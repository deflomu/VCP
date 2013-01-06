//
//  parseFirwall.h
//  VCP
//
//  Created by Jens Sproede on 08.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "firewallRetData.h"

@interface parseFirwall : NSObject <NSXMLParserDelegate> {
    NSXMLParser   *revParser; 
    firewallRetData *fwDataRet;
	NSMutableString *currentElement;
    
    NSInteger depth, counter, elementsFound;
    
    bool foundDestIP;
    bool foundDestPort;
    bool foundMatch;
    bool foundSrcIP;
    bool foundSrcPort;
    bool foundComment;
    
    NSMutableDictionary *dict;
}

-(firewallRetData*)parseReturn:(NSString *)xml;

@end