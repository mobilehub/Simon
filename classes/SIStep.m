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
		selector = [[NSMutableString alloc]initWithString:@"step"];
		[selector appendString:[self stringFromKeyword:keyword]];
	}
	return self;
}

-(void) addWord:(NSString *) word {
	if (parametersAdded) {
		[selector appendString:@"and"];
	}
	[selector appendString:[word capitalizedString]];
}

-(SEL) selector {
	return NSSelectorFromString(selector);
}

-(void) addParameter:(id) parm {
	parametersAdded = YES;
	[selector appendString:@":"];
	[parameters addObject:parm];
}

-(void) dealloc {
	DC_DEALLOC(parameters);
	DC_DEALLOC(selector);
	[super dealloc];
}

@end
