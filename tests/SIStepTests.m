//
//  SIStepStories.m
//  Simon
//
//  Created by Derek Clarkson on 6/14/11.
//  Copyright 2011 Sensis. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStep.h"

@interface SIStepTests : GHTestCase {
@private
}
@end

@implementation SIStepTests

-(void) setUp {
}

-(void) testStoresKeywordAndCommand {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven command:@"abc"] autorelease];
	GHAssertEquals(step.keyword, SIKeywordGiven, @"Keyword not returned");
	GHAssertEqualStrings(step.command,	@"abc", @"command not returned");
}

-(void) testFindsMapping {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven command:@"abc"] autorelease];
	SIStepMapping * mapping = [[[SIStepMapping alloc] initWithClass:[self class] selector:@selector(setUp) regex:@"abc"] autorelease];
	NSArray * mappings = [NSArray arrayWithObject:mapping];
	[step findMappingInList:mappings];
	GHAssertTrue([step isMapped], @"Step did not find a mapping.");
}

-(void) testDoesNotFindMapping {
	SIStep * step = [[[SIStep alloc] initWithKeyword:SIKeywordGiven command:@"abc"] autorelease];
	SIStepMapping * mapping = [[[SIStepMapping alloc] initWithClass:[self class] selector:@selector(setUp) regex:@"xyz"] autorelease];
	NSArray * mappings = [NSArray arrayWithObject:mapping];
	[step findMappingInList:mappings];
	GHAssertFalse([step isMapped], @"Step should not have found a mapping.");
}

@end
