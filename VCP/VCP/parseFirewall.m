//
//  parseFirwall.m
//  VCP
//
//  Created by Jens Sproede on 08.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "parseFirewall.h"

@implementation parseFirwall

-(firewallRetData*)parseReturn:(NSString *)xml {
    
    depth = 0;
    counter = 0;
    elementsFound = 0;
    
    foundDestIP = false;
    foundDestPort = false;
    foundMatch = false;
    foundSrcIP = false;
    foundSrcPort = false;
    foundComment = false;
        
    fwDataRet = [[firewallRetData alloc] init];
    fwDataRet.comment = [[NSMutableArray alloc] init];
    fwDataRet.deactivated = [[NSMutableArray alloc] init];
    fwDataRet.destIP = [[NSMutableArray alloc] init];
    fwDataRet.destPort = [[NSMutableArray alloc] init];
    fwDataRet.srcPort = [[NSMutableArray alloc] init];
    fwDataRet.srcIP = [[NSMutableArray alloc] init];
    fwDataRet.direction = [[NSMutableArray alloc] init];
    fwDataRet.i_id = [[NSMutableArray alloc] init];
    fwDataRet.match = [[NSMutableArray alloc] init];
    fwDataRet.matchValue = [[NSMutableArray alloc] init];
    fwDataRet.protocol = [[NSMutableArray alloc] init];
    fwDataRet.sort = [[NSMutableArray alloc] init];
    fwDataRet.target = [[NSMutableArray alloc] init];
    
	NSData* data=[xml dataUsingEncoding:NSUTF8StringEncoding];
    
	revParser = [[NSXMLParser alloc] initWithData:data];
    	
	[revParser setDelegate:self];
	[revParser setShouldProcessNamespaces:NO];
	[revParser setShouldReportNamespacePrefixes:NO];
	[revParser setShouldResolveExternalEntities:YES];
	[revParser parse]; 
    
    
	return fwDataRet; 
}


- (void) parser: (NSXMLParser *) parser parseErrorOccurred: (NSError *) parseError {
	NSLog(@"Error Parser:%@",[parseError localizedDescription]);
}

- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName
     attributes: (NSDictionary *) attributeDict{
    
    if ([elementName isEqualToString:@"return"])
    {
        depth = 1;
    }
    
}

- (void) parser: (NSXMLParser *) parser didEndElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI
  qualifiedName: (NSString *) qName{
    
    if ([elementName isEqualToString:@"deactivated"]) {
        [fwDataRet.deactivated addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"destIP"]) {
        [fwDataRet.destIP addObject:currentElement];
        foundDestIP = true;
    }
    else if ([elementName isEqualToString:@"destPort"]) {
        [fwDataRet.destPort addObject:currentElement];
        foundDestPort = true;
    }
    else if ([elementName isEqualToString:@"direction"]) {
        [fwDataRet.direction addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"id"]) {
        [fwDataRet.i_id addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"match"]) {
        [fwDataRet.match addObject:currentElement];
        foundMatch = true;
    }
    else if ([elementName isEqualToString:@"matchValue"]) {
        [fwDataRet.matchValue addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"proto"]) {
        [fwDataRet.protocol addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"sort"]) {
        [fwDataRet.sort addObject:currentElement];
    }
    else if ([elementName isEqualToString:@"target"]) {
        [fwDataRet.target addObject:currentElement];
    }  
    else if ([elementName isEqualToString:@"comment"]) {
        [fwDataRet.comment addObject:currentElement];
        foundComment = true;
    }   
    else if ([elementName isEqualToString:@"srcIP"]) {
        [fwDataRet.srcIP addObject:currentElement];
        foundSrcIP = true;
    }   
    else if ([elementName isEqualToString:@"srcPort"]) {
        [fwDataRet.srcPort addObject:currentElement];
        foundSrcPort = true;
    }   
    else if ([elementName isEqualToString:@"return"]) 
    {    
        if (!foundDestIP)
        {
            [fwDataRet.destIP addObject:@"-"];
        }
        if (!foundDestPort)
        {
            [fwDataRet.destPort addObject:@"-"];
        }
        if (!foundMatch)
        {
            [fwDataRet.match addObject:@"-"];
            [fwDataRet.matchValue addObject:@"-"];
        }
        if (!foundSrcIP)
        {            
            [fwDataRet.srcIP addObject:@"-"];
        }
        if (!foundSrcPort)
        {
            [fwDataRet.srcPort addObject:@"-"];
        }
        if (!foundComment)
        {
            [fwDataRet.comment addObject:@"-"];
        }
            
        depth = 0;
        elementsFound = 0;
        counter++;
        
        foundDestIP = false;
        foundDestPort = false;
        foundMatch = false;
        foundSrcIP = false;
        foundSrcPort = false;
        foundComment = false;
    }
    
    if (depth == 1)
    {
        elementsFound++;
        
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
