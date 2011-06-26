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
#import "SIEnums.h"

@interface SIStepMapping()
-(NSInvocation *) createInvocationForMethod:(Method) method;
-(BOOL) populateInvocationParameters:(NSInvocation *) invocation withMethod:(Method) method error:(NSError **) error;
@end

@implementation SIStepMapping

@synthesize regex;
@synthesize selector;
@synthesize class;
@synthesize executed;
@synthesize command;
@synthesize target;

+(SIStepMapping *) stepMappingWithClass:(Class) theClass selector:(SEL) aSelector regex:(NSString *) theRegex error:(NSError **) error {
	SIStepMapping * mapping = [[[SIStepMapping alloc] init] autorelease];
	mapping.class = theClass;
	mapping.selector = aSelector;
	mapping.regex = [NSRegularExpression regularExpressionWithPattern:theRegex 
																				 options:NSRegularExpressionCaseInsensitive
																					error:error];
	if (mapping.regex == nil) {
		
		// Look for regular expression errors so we can provide a better message.
		if ([*error code] == 2048) {
			*error = [self errorForCode:SIErrorInvalidRegularExpression 
						  shortDescription:@"Invalid regular expression"
							  failureReason:
						 [NSString stringWithFormat:@"The passed regular expression \"%@\" is invalid.", theRegex]];
		} 
		return nil;
	}
	
	return mapping;
}

-(BOOL) canMapToStep:(NSString *) step {
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:step options:0 range:NSMakeRange(0, [step length])];
	return ! NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0));
}

-(BOOL) invoke:(NSError **) error {
	
	// Create the invocation.
	Method method = class_getInstanceMethod(class, selector);
	if (method == nil) {
		*error = [self errorForCode:SIErrorUnknownSelector 
					  shortDescription:@"Selector not found"
						  failureReason:
					 [NSString stringWithFormat:@"The passed selector %@ was not found in class %@", NSStringFromSelector(selector), NSStringFromClass(class)]];
		return NO;
	}
	
	NSInvocation *invocation = [self createInvocationForMethod:method];
	if (![self populateInvocationParameters:invocation withMethod:method error:error]) {
		return NO;		
	}
	
	// No perform the invocation.
	DC_LOG(@"Invoking methods on class");
	[invocation invokeWithTarget:self.target];
	return YES;
}

-(NSInvocation *) createInvocationForMethod:(Method) method {
	DC_LOG(@"Creating invocation for %@::%@", NSStringFromClass(class), NSStringFromSelector(selector));
	NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(method)];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
	invocation.selector = selector;
	return invocation;
}

-(BOOL) populateInvocationParameters:(NSInvocation *) invocation withMethod:(Method)method error:(NSError **) error {
	
	// Get the data values from the passed command.	
	NSArray *matches = [regex matchesInString:self.command options:0 range:NSMakeRange(0, [self.command length])];
	NSTextCheckingResult * match = [matches objectAtIndex:0];
	
	// Populate the invocation with the data from the command.
	int nbrArgs = method_getNumberOfArguments(method) - 2;
	for (int i = 0; i < nbrArgs; i++) {
		NSString *value = [self.command substringWithRange:[match rangeAtIndex:i + 1]];
		DC_LOG(@"Adding value to invocation: %@", value);
		// Remember to pass an address-of rather than the value for an object.
		[invocation setArgument:&value atIndex:i + 2];
	}
	return YES;
}

-(void) dealloc {
	self.class = nil;
	self.command = nil;
	self.target = nil;
	self.regex = nil;
	self.target = nil;
	[super dealloc];
}

@end
