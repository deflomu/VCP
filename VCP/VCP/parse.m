//
//  parse.m
//  VCP
//
//  Created by Jens Sproede on 31.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "parse.h"

@implementation parse

-(retdata*)parseReturn:(NSString *)xml {
    
	dataRet = [[retdata alloc] init];
    
    dataRet.ret = [[NSMutableArray alloc] init];
    
	NSData* data=[xml dataUsingEncoding:NSUTF8StringEncoding];
    	
	revParser = [[NSXMLParser alloc] initWithData:data];
	
	[revParser setDelegate:self];
	[revParser setShouldProcessNamespaces:NO];
	[revParser setShouldReportNamespacePrefixes:NO];
	[revParser setShouldResolveExternalEntities:NO];
	[revParser parse]; 
    	
	return dataRet; 
}

- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError {
	NSLog(@"Error Parser:%@",[parseError localizedDescription]);
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName
     attributes: (NSDictionary *) attributeDict{
	
    if ([elementName isEqualToString:@"message"])
    {
        dataRet.message = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString:@"success"])
    {
        dataRet.success = [[NSString alloc] init];
    }
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName{
    
    if ([elementName isEqualToString:@"return"]) {
        [dataRet.ret addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"message"])
    {
        dataRet.message = currentElement;
    }
    else if ([elementName isEqualToString:@"success"])
    {
        dataRet.success = currentElement;
    }
    
    currentElement = nil;
}

- (void) parser: (NSXMLParser *) parser foundCharacters: (NSString *) string{
    
	if(!currentElement)
		currentElement = [[NSMutableString alloc] initWithString:string];
	else
		[currentElement appendString:string];
    
}

@end
