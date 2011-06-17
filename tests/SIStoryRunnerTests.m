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

@interface SIStoryRunnerTests : GHTestCase {}
-(void) asSimon;
-(void) givenThisFileExists;
-(void) thenIShouldBeAbleToRead:(NSNumber *) aNumber and:(NSString *) aString;
@end

@implementation SIStoryRunnerTests

-(void) testRunsBasicStory {
	SIStoryRunner * runner = [[[SIStoryRunner alloc] init] autorelease];
	SIStoryFileReader *reader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	runner.reader = reader;
	
	NSError *error = nil;
	[runner runStories:&error];
	
	GHAssertNil(error, @"Error returned %@", error.localizedDescription);
}

-(void) asSimon {
	DC_LOG(@"As Simon");
}

-(void) givenThisFileExists {
	DC_LOG(@"Given this file exists");
}

-(void) thenIShouldBeAbleToRead:(NSNumber *) aNumber and:(NSString *) aString {
	DC_LOG(@"Then I should be able to read %f and %@", [aNumber floatValue], aString);
}

@end
