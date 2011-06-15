//
//  StoryReaderTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStoryReader.h"
#import <OCMock/OCMock.h>

@interface SIStoryReaderTests : GHTestCase {}

@end

@implementation SIStoryReaderTests

-(void) testInitialiserWorks {
	SIStoryReader * reader = [[[SIStoryReader alloc] initWithStoryFileReader:nil storyFactory:nil] autorelease];
	NSError * error = nil;
	GHAssertNotNil([reader readStories:&error], @"Array not returned");
	GHAssertNil(error, @"Error returned %@", [error localizedDescription]);
}

-(void) testReadingStorySendsDataToFactory {
	
	id mockStoryFactory = [OCMockObject mockForClass:[SIStoryFactory class]];
	NSError * error = nil;
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
	
	SIStoryFileReader * fileReader = [[[SIStoryFileReader alloc]initWithFileName:@"Story files"] autorelease];
	SIStoryReader * reader = [[[SIStoryReader alloc] initWithStoryFileReader:fileReader storyFactory:mockStoryFactory] autorelease];

	GHAssertNotNil([reader readStories:&error], @"Array not returned");
	GHAssertNil(error, @"Error returned %@", [error localizedDescription]);
	
	[mockStoryFactory verify];
	
}

-(void) testReadingOtherStoryTypeDataSentToFactory {
	
	id mockStoryFactory = [OCMockObject mockForClass:[SIStoryFactory class]];
	NSError * error = nil;
	[[mockStoryFactory expect] didReadEmail:@"d4rkf1br3@gmail.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadURL:@"http://drekka.github.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadEmail:@"mailto:d4rkf1br3@gmail.com" error:&error];
	[[mockStoryFactory expect] didReadNewLine];
	[[mockStoryFactory expect] didReadEndOfInput];
	
	SIStoryFileReader * fileReader = [[[SIStoryFileReader alloc]initWithFileName:@"Other types"] autorelease];
	SIStoryReader * reader = [[[SIStoryReader alloc] initWithStoryFileReader:fileReader storyFactory:mockStoryFactory] autorelease];
	
	GHAssertNotNil([reader readStories:&error], @"Array not returned");
	GHAssertNil(error, @"Error returned %@", [error localizedDescription]);
	
	[mockStoryFactory verify];
	
}



@end
