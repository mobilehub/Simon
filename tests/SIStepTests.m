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
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenWord", @"Word not stored");
}

-(void) testCanGenerateSimpleSelector {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGiven", @"Incorrect selector returned");
}

-(void) testCanGenerateMultiwordSelector {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	[step addWord:@"I"];
	[step addWord:@"am"];
	[step addWord:@"Sam"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenIAmSam", @"Incorrect selector returned");
}

-(void) testCanGenerateSimpleSelectorWithOneStringParameter {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	[step addParameter:@"abc"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGiven:", @"Incorrect selector returned");
}

-(void) testCanGenerateSelectorWithTwoStringParameters {
	SIStep * step = [[SIStep alloc] initWithKeyword:SIKeywordGiven];
	[step addWord:@"I"];
	[step addWord:@"am"];
	[step addParameter:@"Fred"];
	[step addWord:@"from"];
	[step addParameter:@"A Company"];
	SEL selector = [step selector];
	GHAssertEqualStrings(NSStringFromSelector(selector), @"stepGivenIAm:andFrom:", @"Incorrect selector returned");
}


@end
