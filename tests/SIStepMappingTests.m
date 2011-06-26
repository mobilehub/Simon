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
@private
	BOOL doSomethingCalled;
	BOOL doSomethingWithStringCalled;
}
@end

@implementation SIStepMappingTests

-(void) setUp {
	doSomethingCalled = NO;
	doSomethingWithStringCalled = NO;
}

-(void) testMapsStep {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"abc" error:&error];
	GHAssertTrue([mapping canMapToStep:@"abc"], @"Did not map the step");
}

-(void) testDoesntMapStepWhenInvalidRegex {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomething) regex:@"[({.+*" error:&error];
	GHAssertNil(mapping, @"Mapping returned instead of nil");
	DC_LOG(@"%@", error);
	GHAssertEquals(error.code, SIErrorInvalidRegularExpression, @"Invalid regex message not returned");
}


-(void) testDoesNotMapStep {
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
	GHAssertTrue(doSomethingCalled, @"Method not called");
}

-(void) testInvokeFailsWhenInvalidSelector {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doesNotExist) regex:@"abc" error:&error];
	GHAssertNotNil(mapping, @"Nil mapping returned, error %@", error.localizedDescription);
	
	BOOL ok = [mapping invoke:&error];
	
	GHAssertFalse(ok, @"Invocation worked");
	GHAssertEquals(error.code, SIErrorUnknownSelector, @"Unknown selector message not returned");
}

-(void) testInvokePassesStringValue {
	NSError *error = nil;
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[self class] selector:@selector(doSomethingWithString:) regex:@"abc (.*)" error:&error];
	GHAssertNotNil(mapping, @"nil mapping, error says %@", error.localizedDescription);
	mapping.command = @"abc def";
	mapping.target = self;

	BOOL ok = [mapping invoke:&error];
	
	GHAssertTrue(ok, @"Invocation should have worked, error %@", error.localizedDescription);
	GHAssertTrue(doSomethingWithStringCalled, @"Method not called");
}

-(void) doSomething {
	doSomethingCalled = YES;	
}

-(void) doSomethingWithString:(NSString *) string {
	doSomethingWithStringCalled = YES;
	DC_LOG(@"Received string value %@", string);
	GHAssertEqualStrings(string, @"def", @"Incorrect value passed to method.");
}

@end
