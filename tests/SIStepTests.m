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


@end
