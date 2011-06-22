//
//  FileTests.m
//  Simon
//
//  Created by Derek Clarkson on 5/29/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryFileReader.h"
#import "SIEnums.h"
#import "SIStory.h"

@interface SIStoryFileReaderTests : GHTestCase {}

@end

@implementation SIStoryFileReaderTests

-(void) testInitReturnsAllStoryFiles {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] init] autorelease];
	GHAssertEquals([fileSystemStoryReader.files count], (NSUInteger)3, @"Incorrect number of files returned");
	GHAssertTrue([(NSString *)[fileSystemStoryReader.files objectAtIndex:0] hasSuffix:STORY_EXTENSION], @"Incorrect extension");
}

-(void) testInitWithFileNameReturnsStoryFile {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	GHAssertEquals([fileSystemStoryReader.files count], (NSUInteger)1, @"Incorrect number of files returned");
	GHAssertTrue([(NSString *)[fileSystemStoryReader.files objectAtIndex:0] hasSuffix:@"Story files." STORY_EXTENSION], @"Wrong file returned");
}

-(void) testThrowsErrorWhenCannotFindAFile {
	@try {
		[[[SIStoryFileReader alloc] initWithFileName:@"xxxxx"] autorelease];
		GHFail(@"Exception not thrown");
	}
	@catch (NSException *exception) {
		// Everything ok.
	}
}

-(void) testThrowsErrorWhenReadingInvalidSyntax {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] initWithFileName:@"Invalid Syntax"] autorelease];
	NSError * error = nil;
	[fileSystemStoryReader readStories:&error];
	GHAssertNotNil(error, @"Error not thrown");
	GHAssertEquals(error.code, SIErrorInvalidStorySyntax, @"Incorrect error thrown");
}

-(void) testReturnsValidStories {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	NSError * error = nil;
	NSArray * stories = [fileSystemStoryReader readStories:&error];
	GHAssertNil(error, @"Unexpected error thrown %@", error.localizedDescription);
	GHAssertEquals([stories count], (NSUInteger) 2, @"incorrect number of stories returned");
	SIStory * story = [stories	objectAtIndex:0];
	GHAssertNotNil(story, @"Nil story found");
}

-(void) testReturnsValidStoriesFromUnformattedSource {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] initWithFileName:@"Unformatted"] autorelease];
	NSError * error = nil;
	NSArray * stories = [fileSystemStoryReader readStories:&error];
	GHAssertNil(error, @"Unexpected error thrown %@", error.localizedDescription);
	GHAssertEquals([stories count], (NSUInteger) 1, @"incorrect number of stories returned");
	SIStory * story = [stories	objectAtIndex:0];
	GHAssertNotNil(story, @"Nil story found");
}

@end
