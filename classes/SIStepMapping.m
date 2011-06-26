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
-(BOOL) setValue:(NSString *) value 
			 ofType:(char) type 
	 onInvocation:(NSInvocation *) invocation 
		atArgIndex:(NSUInteger) index 
			  error:(NSError **) error;
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

	// Validate that the method exists.
	Method method = class_getInstanceMethod(theClass, aSelector);
	if (method == nil) {
		*error = [self errorForCode:SIErrorUnknownSelector 
					  shortDescription:@"Selector not found"
						  failureReason:
					 [NSString stringWithFormat:@"The passed selector %@ was not found in class %@", NSStringFromSelector(aSelector), NSStringFromClass(theClass)]];
		return NO;
	}

	// Validate that the the regex's number of capture groups match the number of selector arguments.
	int nbrArgs = method_getNumberOfArguments(method) - 2;
	if ([mapping.regex numberOfCaptureGroups] != nbrArgs) {
		*error = [self errorForCode:SIErrorRegularExpressionWillNotMatchSelector 
					  shortDescription:@"Regular expression and selector mis-match."
						  failureReason:
					 [NSString stringWithFormat:@"The passed regular expression \"%@\" has a different number of arguments to the selector %@"
					  , theRegex, NSStringFromSelector(aSelector)]];
		return nil;
	}	
	
	// Everything is good.
	return mapping;
}

-(BOOL) canMapToStep:(NSString *) step {
	NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:step options:0 range:NSMakeRange(0, [step length])];
	return ! NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0));
}

-(BOOL) invoke:(NSError **) error {
	
	// Create the invocation.
	Method method = class_getInstanceMethod(class, selector);
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
	
	// Populate the invocation with the data from the command. Remember to allow for the first three
	// Arguments being the return type, class and selector.
	int nbrArgs = method_getNumberOfArguments(method) - 2;
	for (int i = 0; i < nbrArgs; i++) {
		
		// Values will be from regex groups after group 0 which is he complete match.
		NSString *value = [self.command substringWithRange:[match rangeAtIndex:i + 1]];
		DC_LOG(@"Adding value to invocation: %@", value);
		
		char argType = *method_copyArgumentType(method, i + 2);
		if (![self setValue:value ofType:argType onInvocation:invocation atArgIndex:i + 2 error:error]) {
			return NO;
		}
	}
	
	return YES;
}

/**
 * Helper method which sorts out how to pass the value to the invocation.
 */
-(BOOL) setValue:(NSString *) value 
			 ofType:(char) type 
	 onInvocation:(NSInvocation *) invocation 
		atArgIndex:(NSUInteger) index 
			  error:(NSError **) error {
	
	DC_LOG(@"Arg type = %c", type);
	switch (type) {
		case 'C':
		case 'c': {
			// char, BOOL or boolean.
			// First check for Boolean values.
			NSString * upper = [value uppercaseString];
			if ([upper isEqualToString:@"YES"] 
				 || [upper isEqualToString:@"NO"]
				 || [upper isEqualToString:@"TRUE"]
				 || [upper isEqualToString:@"FALSE"]) {
				// It's a boolean value.
				BOOL boolValue = [value boolValue];
				[invocation setArgument:&boolValue atIndex:index];
			} else {
				// Its a char.
				char charValue = [value characterAtIndex:0];
				[invocation setArgument:&charValue atIndex:index];
			}
			break;
		}
		case 'i': {
			// Integer.
			int intValue = [value intValue];
			[invocation setArgument:&intValue atIndex:index];
			break;
		}
		case 'I': {
			// NSInteger
			NSInteger integerValue = [value integerValue];
			[invocation setArgument:&integerValue atIndex:index];
			break;
		}
		case 'd': {
			// double.
			double doubleValue = [value doubleValue];
			[invocation setArgument:&doubleValue atIndex:index];
			break;
		}
		case 'f': {
			// float.
			float floatValue = [value floatValue];
			[invocation setArgument:&floatValue atIndex:index];
			break;
		}
		case '@':
			// Object expected.
			[invocation setArgument:&value atIndex:index];
			break;
			
		default:
			*error = [self errorForCode:SIErrorCannotConvertArgumentToType shortDescription:[NSString stringWithFormat:@"Cannot handle selector %@, argument %i, type %c", 
																														NSStringFromSelector(self.selector), index - 2, type]
							  failureReason:[NSString stringWithFormat:@"Selector %@ has an argument type of %c at parameter %i, I cannot handle that type at this time.",
												  NSStringFromSelector(self.selector), type, index - 2]];
			return NO;
	}
	return YES;
}


-(void) dealloc {
	self.class = nil;
	self.command = nil;
	self.target = nil;
	self.regex = nil;
	self.target = nil;
	self.selector = nil;
	[super dealloc];
}

@end
