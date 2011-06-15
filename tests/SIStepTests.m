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

-(void) testStoresKeyword {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	GHAssertEquals(step.keyword, SIKeywordGiven, @"Keyword not returned");
}

-(void) testWordIsAdded {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	[step addWord:@"word"];
	GHAssertEqualStrings([step.words objectAtIndex:0], @"word", @"Word not stored");
	
}

-(void) testCanGenerateSimpleSelector {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGiven", @"Incorrect selector returned");
}

@end
