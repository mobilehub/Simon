//
//  SIStoryRunnerTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryRunner.h"
#import "SISimon.h"
#import "SIStoryLogReporter.h"

@interface SIStoryRunnerTests : GHTestCase {
@private
	BOOL step1Called;
	BOOL step2Called;
	BOOL step3Called;
}
-(void) stepAs:(NSString *) name;
-(void) stepGivenThisFileExists;
-(void) stepThenIShouldBeAbleToRead:(NSNumber *) aNumber and:(NSString *) aString;
@end

@implementation SIStoryRunnerTests

-(void) testRunStories {
	SIStoryRunner * runner = [[[SIStoryRunner alloc] init] autorelease];
	SIStoryFileReader *reader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	runner.reader = reader;
	runner.reporter = [[[SIStoryLogReporter alloc] init] autorelease];
	
	NSError *error = nil;
	BOOL success = [runner runStories:&error];
	
	GHAssertFalse(success, @"Run should not have returned success.");
	GHAssertNotNil(error, @"Error should have been returned");
	GHAssertEquals(error.code, SIErrorStoryFailures, @"Incorrect error code returned");

}

-(void) testIsAbleToPassValuesBetweenClassInstances {
	SIStoryRunner * runner = [[[SIStoryRunner alloc] init] autorelease];
	SIStoryFileReader *reader = [[[SIStoryFileReader alloc] initWithFileName:@"Communication"] autorelease];
	runner.reader = reader;
	runner.reporter = [[[SIStoryLogReporter alloc] init] autorelease];
	
	NSError *error = nil;
	BOOL success = [runner runStories:&error];
	
	GHAssertTrue(success, @"Run should have returned success.");
	GHAssertNil(error, @"Error should nil, error %@", error.localizedFailureReason);
}

// ### Methods which are called by Simon ###

SIMapStepToSelector(@"As ([A-Z][a-z]+)", stepAs:)
-(void) stepAs:(NSString *) name {
	DC_LOG(@"As %@", name);
	GHAssertEqualStrings(name, @"Simon", @"Incorrect name passed to step.");
	step1Called = YES;
}

SIMapStepToSelector(@"Given this file exists", stepGivenThisFileExists)
-(void) stepGivenThisFileExists {
	DC_LOG(@"Given this file exists");
	GHAssertTrue(step1Called, @"Step 1 not called");
	step2Called = YES;
}

SIMapStepToSelector(@"then I should be able to read (\\d+) and ([a-z]+) from it", stepThenIShouldBeAbleToRead:and:)
-(void) stepThenIShouldBeAbleToRead:(NSNumber *) aNumber and:(NSString *) aString {
	DC_LOG(@"Then I should be able to read %f and %@", [aNumber floatValue], aString);
	GHAssertEquals([aNumber floatValue], (float) 5.0, @"Incorrect float value passed to step.");
	GHAssertEqualStrings(aString, @"abc", @"Incorrect value passed to step.");
	GHAssertTrue(step1Called, @"Step 1 not called");
	GHAssertTrue(step2Called, @"Step 2 not called");
	step3Called = YES;
}

@end
