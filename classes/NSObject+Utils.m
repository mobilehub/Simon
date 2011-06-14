//
//  NSObject+Utils.m
//  Simon
//
//  Created by Derek Clarkson on 6/8/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (NSObject_Utils)

-(NSError *) errorForCode:(SIError) errorCode shortDescription:(NSString *) shortDescription description:(NSString *) description {
	NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
								 description, NSLocalizedDescriptionKey, 
								 shortDescription, NSLocalizedFailureReasonErrorKey, 
								 nil];
	return [NSError errorWithDomain:SIMON_ERROR_DOMAIN code:errorCode userInfo:dic];
}

@end
