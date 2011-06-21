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

@end
