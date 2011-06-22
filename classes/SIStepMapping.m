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

-(BOOL) canMapToStep:(NSString *) step {
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:step options:0 range:NSMakeRange(0, [step length])];
	return ! NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0));
}

-(void) dealloc {
	DC_DEALLOC(regex);
	[super dealloc];
}

@end
