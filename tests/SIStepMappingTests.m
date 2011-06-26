//
//  SIStepMappingTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/23/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStepMapping.h"
#import "SIEnums.h"

@interface SIStepMappingTests : GHTestCase {
@private
	BOOL methodCalled;
}
-(void) invokeWithRegex:(NSString *) regex selector:(SEL) selector command:(NSString *) command;
@end

@implementation SIStepMappingTests

-(void) setUp {
	methodCalled = NO;
}

-(void) testCreateFailsWhenInvalidSelector {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doesNotExist) regex:@"abc" error:&error];
	GHAssertNil(mapping, @"Nil mapping returned, error %@", error.localizedDescription);
	GHAssertEquals(error.code, SIErrorUnknownSelector, @"Unknown selector message not returned");
}

-(void) testCreateFailsWhenSelectorAndRegexMissMatch {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomethingWithA:andB:) regex:@"abc (.*) def (.*) (.*)" error:&error];
	GHAssertNil(mapping, @"Mapping should be nil");
	GHAssertEquals(error.code, SIErrorRegularExpressionWillNotMatchSelector, @"Unknown selector message not returned");
}

-(void) testDoesntMapStepWhenInvalidRegex {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"[({.+*" error:&error];
	GHAssertNil(mapping, @"Mapping returned instead of nil");
	DC_LOG(@"%@", error);
	GHAssertEquals(error.code, SIErrorInvalidRegularExpression, @"Invalid regex message not returned");
}

-(void) testCanMapToStepReturnsTrueWhenMatched {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"abc" error:&error];
	GHAssertTrue([mapping canMapToStep:@"abc"], @"Did not map the step");
}

-(void) testCanMapToStepReturnsFalseWhenNoMatch {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"abc" error:&error];
	GHAssertNotNil(mapping, @"nil mapping, error says %@", error.localizedDescription);
	GHAssertFalse([mapping canMapToStep:@"xyz"], @"Should not have mapped the step.");
}

-(void) testInvokeInstantiatesClassAndCallsMethod {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"abc" error:&error];
	GHAssertNotNil(mapping, @"nil mapping, error says %@", error.localizedDescription);
	mapping.command = @"abc";
	mapping.target = self;
	
	BOOL ok = [mapping invoke:&error];
	
	GHAssertTrue(ok, @"Invocation should have worked");
	GHAssertTrue(methodCalled, @"Method not called");
}

-(void) testInvokePassesStringValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithString:) command:@"abc def"];
}

-(void) testInvokePassesNumberValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithNumber:) command:@"abc 5"];
}

-(void) testInvokePassesIntValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithInt:) command:@"abc 5"];
}

-(void) testInvokePassesIntegerValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithInteger:) command:@"abc 5"];
}

-(void) testInvokePassesDoubleValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithDouble:) command:@"abc 5"];
}

-(void) testInvokePassesFloatValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithFloat:) command:@"abc 5"];
}

-(void) testInvokePassesBOOLValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithBOOL:) command:@"abc yes"];
}

-(void) testInvokePassesBooleanValue {
	[self invokeWithRegex: @"abc (.*)" selector:@selector(doSomethingWithBoolean:) command:@"abc yes"];
}

// Helpers

-(void) invokeWithRegex:(NSString *) regex selector:(SEL) selector command:(NSString *) command {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:selector regex:regex error:&error];
	GHAssertNotNil(mapping, @"nil mapping, error says %@", error.localizedDescription);
	mapping.command = command;
	mapping.target = self;
	
	BOOL ok = [mapping invoke:&error];
	
	GHAssertTrue(ok, @"Invocation should have worked, error %@", error.localizedDescription);
	GHAssertTrue(methodCalled, @"Method not called");
}

// Called Methods.

-(void) doSomething {
	methodCalled = YES;	
}

-(void) doSomethingWithString:(NSString *) string {
	methodCalled = YES;
	GHAssertEqualStrings(string, @"def", @"Incorrect value passed to method.");
}

-(void) doSomethingWithNumber:(NSNumber *) number {
	methodCalled = YES;
	GHAssertEquals([number intValue], 5, @"Incorrect value passed to method.");
}

-(void) doSomethingWithInt:(int) number {
	methodCalled = YES;
	GHAssertEquals(number, 5, @"Incorrect value passed to method.");
}

-(void) doSomethingWithInteger:(NSInteger) number {
	methodCalled = YES;
	GHAssertEquals(number, (NSInteger)5, @"Incorrect value passed to method.");
}

-(void) doSomethingWithDouble:(double) number {
	methodCalled = YES;
	GHAssertEquals(number, 5.0, @"Incorrect value passed to method.");
}

-(void) doSomethingWithFloat:(float) number {
	methodCalled = YES;
	GHAssertEquals(number, (float)5.0, @"Incorrect value passed to method.");
}

-(void) doSomethingWithBOOL:(BOOL) yesNo {
	methodCalled = YES;
	GHAssertTrue(yesNo, @"Incorrect value passed to method.");
}

-(void) doSomethingWithBoolean:(Boolean) yesNo {
	methodCalled = YES;
	GHAssertTrue(yesNo, @"Incorrect value passed to method.");
}

-(void) doSomethingWithA:(NSString *) a andB:(NSString *) b {
	methodCalled = YES;
	GHAssertEqualStrings(a, @"abc", @"Incorrect value passed to method.");
	GHAssertEqualStrings(b, @"def", @"Incorrect value passed to method.");
}

@end
