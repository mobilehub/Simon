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

-(void) testRunsBasicStory {
	SIStoryRunner * runner = [[[SIStoryRunner alloc] init] autorelease];
	SIStoryFileReader *reader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	runner.reader = reader;
	
	NSError *error = nil;
	[runner runStories:&error];
	
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
	GHAssertTrue(step1Called, @"Step 1 not called");
	GHAssertTrue(step2Called, @"Step 2 not called");
	GHAssertTrue(step3Called, @"Step 3 not called");
}

// ### Methods which are called by Simon ###

SIMapStep(@"As ([A-Z][a-z]+)", stepAs:)
-(void) stepAs:(NSString *) name {
	DC_LOG(@"As %@", name);
	step1Called = YES;
}

SIMapStep(@"Given this file exists", stepGivenThisFileExists)
-(void) stepGivenThisFileExists {
	DC_LOG(@"Given this file exists");
	step2Called = YES;
}

SIMapStep(@"then I should be able to read (\\d+) and ([a-z]+) from it", stepThenIShouldBeAbleToRead:and:)
-(void) stepThenIShouldBeAbleToRead:(NSNumber *) aNumber and:(NSString *) aString {
	DC_LOG(@"Then I should be able to read %f and %@", [aNumber floatValue], aString);
	step3Called = YES;
}

@end
