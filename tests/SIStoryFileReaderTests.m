//
//  FileTests.m
//  Simon
//
//  Created by Derek Clarkson on 5/29/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import <OCMock/OCMock.h>
#import "SIStoryFileReader.h"
#import "SIStoryFactory.h"

@interface SIStoryFileReaderTests : GHTestCase {}

@end

@implementation SIStoryFileReaderTests

-(void) testInitReturnsAllStoryFiles {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] init] autorelease];
	GHAssertEquals([fileSystemStoryReader.files count], (NSUInteger)2, @"Incorrect number of files returned");
	GHAssertTrue([(NSString *)[fileSystemStoryReader.files objectAtIndex:0] hasSuffix:STORY_EXTENSION], @"Incorrect extension");
}

-(void) testInitWithFileNameReturnsStoryFile {
	SIStoryFileReader * fileSystemStoryReader = [[[SIStoryFileReader alloc] initWithFileName:@"Story files"] autorelease];
	GHAssertEquals([fileSystemStoryReader.files count], (NSUInteger)1, @"Incorrect number of files returned");
	GHAssertTrue([(NSString *)[fileSystemStoryReader.files objectAtIndex:0] hasSuffix:@"Story files." STORY_EXTENSION], @"Wrong file returned");
}

-(void) testReadingStorySendsDataToFactory {

	SIStoryFileReader * fileReader = [[[SIStoryFileReader alloc]initWithFileName:@"Story files"] autorelease];

	id mockStoryFactory = [OCMockObject mockForClass:[SIStoryFactory class]];
	NSError * error = nil;
	[[mockStoryFactory expect] setDelegate:fileReader];
	[[mockStoryFactory expect] didReadWord:@"As" error:&error];
	[[mockStoryFactory expect] didReadWord:@"Simon" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadWord:@"Given" error:&error];
	[[mockStoryFactory expect] didReadWord:@"this" error:&error];
	[[mockStoryFactory expect] didReadWord:@"file" error:&error];
	[[mockStoryFactory expect] didReadWord:@"exists" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadWord:@"then" error:&error];
	[[mockStoryFactory expect] didReadWord:@"I" error:&error];
	[[mockStoryFactory expect] didReadWord:@"should" error:&error];
	[[mockStoryFactory expect] didReadWord:@"be" error:&error];
	[[mockStoryFactory expect] didReadWord:@"able" error:&error];
	[[mockStoryFactory expect] didReadWord:@"to" error:&error];
	[[mockStoryFactory expect] didReadWord:@"read" error:&error];
	[[mockStoryFactory expect] didReadNumber:5 error:&error];
	[[mockStoryFactory expect] didReadWord:@"and" error:&error];
	[[mockStoryFactory expect] didReadQuotedString:@"\"abc\"" error:&error];
	[[mockStoryFactory expect] didReadWord:@"from" error:&error];
	[[mockStoryFactory expect] didReadWord:@"it" error:&error];
	[[mockStoryFactory expect] didReadSymbol:@"." error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadEndOfInput];
	[[mockStoryFactory expect] setDelegate:nil];
	
	fileReader.storyFactory = mockStoryFactory;
	
	GHAssertNotNil([fileReader readStories:&error], @"Array not returned");
	GHAssertNil(error, @"Error returned %@", [error localizedDescription]);
	
	[mockStoryFactory verify];
	
}

-(void) testReadingOtherStoryTypeDataSentToFactory {

	SIStoryFileReader * fileReader = [[[SIStoryFileReader alloc]initWithFileName:@"Other types"] autorelease];

	id mockStoryFactory = [OCMockObject mockForClass:[SIStoryFactory class]];
	NSError * error = nil;
	[[mockStoryFactory expect] setDelegate:fileReader];
	[[mockStoryFactory expect] didReadEmail:@"d4rkf1br3@gmail.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadURL:@"http://drekka.github.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadEmail:@"mailto:d4rkf1br3@gmail.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadEndOfInput];
	[[mockStoryFactory expect] setDelegate:nil];
	
	fileReader.storyFactory = mockStoryFactory;
	
	GHAssertNotNil([fileReader readStories:&error], @"Array not returned");
	GHAssertNil(error, @"Error returned %@", [error localizedDescription]);
	
	[mockStoryFactory verify];
	
}


@end
