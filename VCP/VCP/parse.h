//
//  parse.h
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "retdata.h"

@interface parse : NSObject <NSXMLParserDelegate>
{
    NSXMLParser   *revParser; 
    retdata *dataRet;
	NSMutableString *currentElement;
}

-(retdata*)parseReturn:(NSString *)xml;

@end
