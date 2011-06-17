//
//  Step.m
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStep.h"
#import <dUsefulStuff/DCCommon.h>
#import "NSObject+Utils.h"

@implementation SIStep

@synthesize keyword;

-(id) initWithKeyword:(SIKeyword) aKeyword {
	self = [super init];
	if (self) {
		keyword = aKeyword;
		parameters = [[NSMutableArray alloc] init];
		selectorTemplate = [[NSMutableString alloc]initWithString:@"step"];
		[selectorTemplate appendString:[self stringFromKeyword:keyword]];
	}
	return self;
}

-(void) addWord:(NSString *) word {

	// If parameters have been added and this is the next word then we need to insert 
	// an "and" before the next parameters name begins.
	if ([parameters count] > 0 && [selectorTemplate hasSuffix:@":"]) {
		
		[selectorTemplate appendString:@"and"];
		
		// Exit if the word to be added is also "and".
		NSString * upper = [word uppercaseString];
		if ([upper isEqualToString:@"AND"]) {
			return;
		}
	}
	
	// Add the next word. 
	[selectorTemplate appendString:[word capitalizedString]];
}

-(SEL) selector {
	DC_LOG(@"Returning selector %@", selectorTemplate);
	return NSSelectorFromString(selectorTemplate);
}

-(NSInvocation *) invocation {
	
	NSMutableString * parameterSignature = [[NSMutableString alloc] initWithString:@"v@:"];
	for (id parm in parameters) {
		[parameterSignature appendString:@"@"];
	}
	DC_LOG(@"Using method parameter signature %s", [parameterSignature UTF8String]);
	
	NSMethodSignature * signature = [NSMethodSignature signatureWithObjCTypes:[parameterSignature UTF8String]];
	
	NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
	DC_LOG(@"Invocation args count %i", [[invocation methodSignature] numberOfArguments]);
	[invocation setSelector:[self selector]];
	
	NSUInteger index = 2;
	for (id parm in parameters) {
		DC_LOG(@"Adding parameter value %@", parm);
		[invocation setArgument:parm atIndex:index++];
	}
	
	DC_DEALLOC(parameterSignature);
	return invocation;
}

-(void) addParameter:(id) parm {
	[selectorTemplate appendString:@":"];
	[parameters addObject:parm];
}

-(void) dealloc {
	DC_DEALLOC(parameters);
	DC_DEALLOC(selectorTemplate);
	[super dealloc];
}

@end
