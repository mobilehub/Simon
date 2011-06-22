//
//  SIClassSelector.m
//  Simon
//
//  Created by Derek Clarkson on 6/19/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "SIStepMapping.h"
#import "NSObject+Utils.h"
#import <dUsefulStuff/DCCommon.h>

@implementation SIStepMapping

@synthesize regex;
@synthesize selector;
@synthesize class;
@synthesize executed;

-(id) initWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex {
	self = [super init];
	if (self) {
		class = theClass;
		selector = aSelector;
		NSError * error = nil;
		regex	= [[NSRegularExpression alloc] initWithPattern:theRegex 
																	options:NSRegularExpressionCaseInsensitive
																	  error:&error];
		if (regex == nil) {
			@throw [self errorForCode:SIErrorInvalidRegularExpression 
						shortDescription:error.localizedDescription 
							failureReason:error.localizedFailureReason];
		}
	}
	return self;
}

-(void) dealloc {
	DC_DEALLOC(regex);
	[super dealloc];
}

@end
