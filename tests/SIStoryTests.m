//
//  SIStoryTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/27/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import <OCMock/OCMock.h>
#import <OCMock/OCMArg.h>
#import "SIStep.h"
#import "SIStory.h"
#import "SISimon.h"
#import "SIStepMapping.h"

@interface SIStoryTests : GHTestCase {
@private
	BOOL abcMethodCalled;
	BOOL defMethodCalled;
}
@end

@implementation SIStoryTests

-(void) testInvokeReturnsStatusIfStepIsNotMapped {
	
	SIStory *story = [[[SIStory alloc] init] autorelease];
	[story newStepWithKeyword:SIKeywordGiven command:@"abc"];
	
	BOOL success = [story invoke];
	
	GHAssertFalse(success, @"Invoked should have failed");
	GHAssertEquals(story.status, SIStoryStatusNotMapped, @"Incorrect status returned");
	
}

-(void) testInvokeReturnsOk {
	
	SIStory *story = [[[SIStory alloc] init] autorelease];
	SIStep *step = [story newStepWithKeyword:SIKeywordGiven command:@"abc"];
	
	NSError * error = nil;
	
	SIStepMapping * mapping = [SIStepMapping stepMappingWithClass:[SIStoryTests class] selector:@selector(abc) regex:@"abc" error:&error];
	GHAssertNotNil(mapping, @"Mapping should not be nil, error %@", error.localizedDescription);
	step.stepMapping = mapping;
	
	BOOL success = [story invoke];
	
	GHAssertTrue(success, @"Invoked should have worked. Error %@", story.error.localizedFailureReason);
	GHAssertNil(story.error, @"Error not nil. Error %@", error.localizedFailureReason);
	GHAssertEquals(story.status, SIStoryStatusSuccess, @"Success code not returned");
}

-(void) testInvokeGivesStatusNotMapped {
	
	SIStory *story = [[[SIStory alloc] init] autorelease];
	[story newStepWithKeyword:SIKeywordGiven command:@"abc"];
	
	BOOL success = [story invoke];
	
	GHAssertFalse(success, @"Invocation should be false");
	GHAssertNil(story.error, @"Error not nil. Error %@", story.error.localizedFailureReason);
	GHAssertEquals(story.status, SIStoryStatusNotMapped, @"incorrect story status");
}

-(void) testInvocationSharesClassInstance {
	
	SIStory *story = [[[SIStory alloc] init] autorelease];
	SIStep *step1 = [story newStepWithKeyword:SIKeywordGiven command:@"abc"];
	SIStep *step2 = [story newStepWithKeyword:SIKeywordGiven command:@"def"];
	
	NSError * error = nil;
	
	SIStepMapping * mapping1 = [SIStepMapping stepMappingWithClass:[SIStoryTests class] selector:@selector(abc) regex:@"abc" error:&error];
	GHAssertNotNil(mapping1, @"Mapping should not be nil, error %@", error.localizedDescription);

	SIStepMapping * mapping2 = [SIStepMapping stepMappingWithClass:[SIStoryTests class] selector:@selector(def) regex:@"def" error:&error];
	GHAssertNotNil(mapping2, @"Mapping should not be nil, error %@", error.localizedDescription);

	step1.stepMapping = mapping1;
	step2.stepMapping = mapping2;
	
	BOOL success = [story invoke];
	
	GHAssertTrue(success, @"Invoked should have worked. Error %@", story.error.localizedFailureReason);
	GHAssertNil(story.error, @"Error not nil. Error %@", story.error.localizedFailureReason);
	GHAssertEquals(story.status, SIStoryStatusSuccess, @"Success code not returned");

}

// Used for testing.
-(void) abc {
	DC_LOG(@"Executing abc");
	abcMethodCalled = YES;
}

-(void) def {
	DC_LOG(@"Executing def");
	defMethodCalled = YES;
	GHAssertTrue(abcMethodCalled, @"Appear to in a different instance of the class.");
}

@end
